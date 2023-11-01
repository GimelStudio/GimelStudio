# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by Noah Rahm and contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

<#
	.NOTES
	======================================================
	 Project:      GimelStudio
     Last Edit:    01/07/2022
     Created by:   instance.id (https://github.com/instance-id)
     Platform:     Windows/Linux?
	 Filename:     build.ps1
     PSVersion:    Created and tested with 5.0/7.3.x
	======================================================
	.DESCRIPTION
		GimelStudio Windows build process
	.PARAMETER mingw64
        If set to true, the build will use the mingw64 compiler
    .PARAMETER pyinstaller
        If set to true, the build will use pyinstaller to create a standalone executable
#>

Param (
    [Parameter()]
    [switch]$mingw64,
    [switch]$pyinstaller,
    [switch]$interactive,
    [switch]$doDebug
)

$currentPath = $PSScriptRoot

$nodes = "src/nodes"
$dataFiles = "gimelstudio/datafiles/"
$defaultConfig = "src/gimelstudio/datafiles/default_config.json"

$datas = @(
[PSCustomObject]@{ origin = $defaultConfig; dest = $dataFiles }
#[PSCustomObject]@{ origin = "${nodes}/*"; dest = "nodes/" }
)

function PyInstallAddData() { return $datas | foreach { " --add-data '$($_.origin);$($_.dest)'" } }
function NuitkaAddData() { return $datas | foreach { " --include-data-file=$($_.origin)=$($_.dest)" } }

# --| Conda Setup Begin -------------------------
function InstallConda() {
    $condaPath = "${currentPath}\.conda"
    $env:ANACONDA_HOME = $condaPath
    $tmpEnv = "tmpCondaEnv"

    $libraries = [System.Collections.ArrayList]@("libpython-static", "vs2015_runtime", "c-compiler", "nuitka", "vc", "importlib-metadata")
    $paths = @("", "condabin", "Scripts", "Library\bin", "envs\${tmpEnv}", "envs\${tmpEnv}\Lib", "envs\${tmpEnv}\Scripts", "envs\${tmpEnv}\Library\bin")
    if ($pyinstaller) { [void]$libraries.Add("pyinstaller") }

    $env:PATH = $env:PYTHONPATH = $($($paths | foreach { ";${condaPath}\$_".Trim() }) -join ('')) + ";C:\Windows\System32\"
    if ($debug) { echo $env:PATH }

    if (!(test-path -path $condaPath)) {
        try {
            $progressPreference = 'silentlyContinue'

            echo "Downloading conda"
            $condaInstallerURL = "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
            $condaInstaller = "$env:TMP\\Miniconda3-latest-Windows-x86_64.exe"

            invoke-webrequest $condaInstallerURL -outfile $condaInstaller

            echo "Installing conda"
            $progressPreference = 'Continue'

            $condaArgs = "/InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /S /D=${condaPath}"
            Start-Process $condaInstaller $condaArgs -Wait
        }
        catch {
            $_
            echo "Error installing conda"
            exit 1a
        }
    }

    conda update conda -y

    $condaVer = conda --version
    if ($debug) { echo "$condaVer" }
    if (!($condaVer -match "4.1*.*")) {
        echo "Could not locate conda executable"
        exit 1
    }

    conda config --add channels conda-forge
    conda config --set channel_priority strict

    $result = conda info --env | findstr $tmpEnv
    if ($debug) { echo "Found env: ${result}" }

    if ( [string]::IsNullOrEmpty($result)) {
        echo "Creating conda environment"
        $envStr = "conda create -n ${tmpEnv} -y python=3.9 libpython-static"
        iex $envStr
    }
    else {
        echo "Conda environment already exists"
    }

    $activate = "conda activate ${tmpEnv}"
    iex $activate

    $instStr = "conda install -c conda-forge -y $($libraries | % { "$_" })"
    iex $instStr

    if ($debug) { echo "PATH: $env:PATH" }
    if ($debug) { echo "PYTHONPATH: $env:PYTHONPATH" }

    $version = $(python --version).replace('Python ', '')
}

# --| Begin Build Process ----------------------------
$installer = ''

# --| PyInstaller ------------------------------------
function BuildPyInstaller() {
    $req = Get-Content requirements.txt
    $imports = @('glcontext', 'openimageio', 'wx', 'numpy', 'opencv-python', 'gswidgetkit', 'gsnodegraph')
    $tmp = $env:TEMP

    $installer = 'pyinstaller'
    $args = [System.Collections.ArrayList]@()
    # [void]$args.Add('--upx-dir .\upx')
    [void]$args.Add("${installer} ")
    # [void]$args.Add("--onefile ")
    [void]$args.Add("--noconfirm")
    [void]$args.Add("-n GimelStudio")
    [void]$args.Add("$(PyInstallAddData)")
    [void]$args.Add("--workpath '${tmp}'")
    [void]$args.Add("--runtime-tmpdir ${tmp}")
    [void]$args.Add("--exclude-module=.git")
    [void]$args.Add("-i assets/GIMELSTUDIO_ICO.ico")
    [void]$args.Add("$($req | % { "--hidden-import $_".Trim() })")
    [void]$args.Add("$($imports | % { "--hidden-import $_".Trim() })")
    [void]$args.Add("src/main.py")
    return $args
}

# --| Nuitka -----------------------------------------
function BuildNuitka() {
    # -- Install ccache to greatly speed --------
    # -- up subsequent compilations -------------
    try {
        $ccachePath = [System.IO.Path]::Combine($currentPath, '.tools', 'ccache')
        $ccacheUrl = "https://github.com/ccache/ccache/releases/download/v4.5.1/ccache-4.5.1-windows-64.zip"

        if (!(test-path -path $ccachePath)) {
            mkdir $ccachePath -force | out-null

            $progressPreference = 'silentlyContinue'
            $response = invoke-webrequest $ccacheUrl -OutFile "${ccachePath}/ccache.zip"
            $progressPreference = 'Continue'
            Expand-Archive -Path "${ccachePath}/ccache.zip" -DestinationPath $ccachePath -force
        }

        $ccacheBin = $ccachePath | gci -recurse | where { $_.Extension -eq '.exe' }
        if ( [string]::IsNullOrEmpty($ccacheBin[0].FullName)) {
            echo "Unable to use ccache, continuing regardless..."
        }
        else { $env:NUITKA_CCACHE_BINARY = $ccacheBin[0].FullName; $env:PATH = $env:PYTHONPATH += $ccacheBin[0].Directory }
    }
    catch {
        echo "Unable to use ccache, continuing regardless..."
    }

    # -- Nuitka build settings ------------------
    $installer = 'nuitka'
    $args = [System.Collections.ArrayList]@()
    [void]$args.Add("python -m ${installer} ")
    if ($mingw64) { [void]$args.Add("--mingw64") }
    [void]$args.Add("--standalone")
    [void]$args.Add("--follow-imports")
    [void]$args.Add("--output-dir=build")
    [void]$args.Add("--include-module=wx")
    [void]$args.Add("--static-libpython=no")
    [void]$args.Add("--enable-plugin=numpy")
    [void]$args.Add("--assume-yes-for-downloads")
    [void]$args.Add("--include-module=glcontext")
    [void]$args.Add("--include-package-data=*.pyd")
    [void]$args.Add("--include-data-dir=src/nodes=nodes")
    [void]$args.Add("--include-plugin-directory=src/nodes")
    # -- Was giving build errors but want to revisit this during GitHub action build    
    # [void]$installArgs.Add("--windows-icon-from-ico=assets/GIMELSTUDIO_ICO.ico")
    [void]$args.Add("$(NuitkaAddData)")
    [void]$args.Add("src/main.py")
    return $args
}

function ExecuteBuild() {
    $pyInstallResults = ''
    $installArgs = [System.Collections.ArrayList]@()

    if ($pyinstaller) { $installArgs = BuildPyInstaller }
    else { $installArgs = BuildNuitka }

    if ($debug) { echo "InstallArgs: $installArgs" }

    # -- Turn formatter off so as not to goof up the version number text
    # @formatter:off
    $doInstall = {
        param([System.Collections.ArrayList]$arguments)
        try {
            python -m pip install --upgrade pip
            python -m pip install -r requirements.txt --extra-index-url https://pypi.bartbroe.re
            python -m pip install --extra-index-url https://pypi.bartbroe.re openimageio==2.2.18.0 scons

            if ($debug) { echo "arguments: $arguments" }
            $argString = $($arguments | % { "$_" })

            if ($debug) { echo "argString: $argString" }
            $cmd = "${argString}"

            if ($debug) { echo "cmd: ${cmd}" }
            iex ${cmd}

            if ($pyinstaller) { $dest = "dist/GimelStudio/" }
            else {
                $dest = "build/main.dist/";
                mv -path "build/main.dist/main.exe" -destination "build/main.dist/GimelStudio.exe"
            }
            cp -recurse -force -path $nodes -destination $dest

        }
        catch { $_; $pyInstallResults = $_; "Error installing OpenImageIO. GimelStudio will not work without it. Exiting..."; exit 1; }
    } # @formatter:on

    try { & $doInstall $installArgs }
    catch { $_; "Error installing OpenImageIO. GimelStudio will not work without it. Exiting..."; exit 1; }

    # -- Check for errors on installation of components ---
    if (!([string]::IsNullOrEmpty($pyInstallResults)) -and ($pyInstallResults -match "OpenImageIO")) {
        "Error installing OpenImageIO. GimelStudio will not work without it. Exiting..."; exit 1;
    }
}

# --| Declarations ----------------------------------------
# --|------------------------------------------------------
$originalPath = $env:PATH
try {
    $tmpPath = [System.Collections.ArrayList]@()
    # @formatter:off
    $tmpPath = @(
        'C:\Windows\System32\Wbem;',
        'C:\Program Files\PowerShell\7;',
        'C:\Program Files\PowerShell\7-preview;',
        'C:\Program Files\Git\cmd\;',
        'C:\Windows\System32\;',
        'C:\Windows;',
        'C:\Windows\System32\WindowsPowerShell\v1.0'
    )
    $env:PATH = $($($tmpPath | % { "$_".Trim() }) -join (''))
    # @formatter:on

    [switch]$debug = $doDebug

    $introText = @"
GimelStudio build process initiation for missing dependencies
=============================================================

This script will download and locally install the required dependencies for the build process within the .conda and .tools directories.
No permanent modifications are made to the system. These folders can be removed after the build process is complete.

Dependencies include, but are not limited to:
  - MiniConda3
  - Python3.9.x
  - Nuitka (or PyInstaller)
  - OpenImageIO
  - The contents of the requirements.txt file and their dependencies
"@
    
    # --| Main Setup Start ------------------------------------
    # --|------------------------------------------------------
    if ($interactive) {
        echo $introText
        $continue = read-host 'Do you want to continue? (Y/N)'
    }
    else { $continue = 'y' }

    # -- Exit early if user does not want to continue ---------
    if (!($continue.ToLower().StartsWith('y'))) { echo 'Exiting script. Please run again when ready to start the build process'; exit 0 }

    InstallConda
    ExecuteBuild
}
finally {
    $env:PATH = $originalPath
}
