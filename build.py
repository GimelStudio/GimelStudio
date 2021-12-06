# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2021 by Noah Rahm and contributors
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

import os
import sys
import shutil
import subprocess


# Set to True during development and testing
DEBUG = False

# -- Mac Installation -----------------------------------------------
# -------------------------------------------------------------------
def MAC():
    # Executes a console instruction, it can activate an specific environment
    def ExecuteTerminalInstruction(inst, env='source env/bin/activate && '):
        terminalInstruction = env + inst
        os.system(terminalInstruction)

    # Checks if a path exists, if not, it runs the given instruction in the given destPath
    def CheckPathAndExecute(path, inst, destPath='', inst2=None):
        if not os.path.exists(path):
            ExecuteTerminalInstruction(inst, destPath)
        elif os.path.exists(path) and inst2 != None:
            ExecuteTerminalInstruction(inst2, destPath)

    # Creates the Mac executable
    def InstallMac():
        # Install pyinstaller in virtual environtment
        ExecuteTerminalInstruction("pip3 install pyinstaller")
        inst = 'pyinstaller --onefile src/main.py'
        for lib in open('requirements.txt'):
            inst += ' --hidden-import {}'.format(lib.replace('\n', ''))
        inst += ' --hidden-import wx --windowed -i assets/GIMELSTUDIO_ICO.ico -n GimelStudio'
        inst += ' --noconfirm'
        ExecuteTerminalInstruction(inst)
        dest = "dist/nodes"
        inst = "cp -r src/nodes " + dest
        CheckPathAndExecute(dest, inst, inst2="rm -rf " + dest + " && "+ inst)

    # Ask whether to continue
    def AskContinue():
        if input("Do you want to continue with installation y/n?").lower() == "n":
            sys.exit()

    try:
        import OpenImageIO
    except ImportError:
        if "Homebrew" in subprocess.run(["brew", "-v"], capture_output=True).stdout.decode("utf-8"):
            # Checks if brew is installed
            CheckPathAndExecute('/usr/local/Cellar/openimageio', 'brew install openimageio')
        else :
            print("Homebrew not installed, please install it and try again")
            AskContinue()
    possible = True

    try:
        import OpenImageIO
    except ImportError:
        print('\033[91m',"Error loading OpenImageIO",'\033[0m')
        print("hint run:\n",'\033[93m',"brew doctor",'\033[0m')
        AskContinue()
        possible = False

    # If the virtual environment is not created, it creates it.
    CheckPathAndExecute('env', 'python3 -m venv --system-site-packages env')
    # Installs the libraries contained in requirements
    ExecuteTerminalInstruction('pip3 install -r requirements.txt')
    if possible:
        if input("Do you want to create an executable y/n?").lower() == "y":
            InstallMac()
            print("Executable created you can find it in dist/")
    else:
        print("Executable is not possible to be created since",'\033[91m',"import OpenImageIO",'\033[0m'," failed")
    print("All dependencies are installed already\nIf you want to run this code please activate virtual environment")
    print("To activate virtual environment just write in console\n",'\033[92m',"source env/bin/activate",'\033[0m')
    print("Once the virtual environment is activated you can execute any python program")
    sys.exit()

# -- Linux Installation ---------------------------------------------
# -------------------------------------------------------------------
def LINUX():
    # -- Python Paths --------------------------------
    sitePackages = ''
    tmpEnv = os.environ.copy()
    envPath = os.path.join('env', 'lib')
    pyBin = os.path.join('env', 'bin', 'python3')
    
    # -- Command Declarations ------------------------
    py39 = 'python3'
    pipCmd = f'{pyBin} -m pip'
    source = 'source env/bin/activate && '
    shellEnv = 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'

    # -- Version checking commands -------------------
    pyenvCheck = 'if type pyenv 2>/dev/null; then echo true; else echo false; fi'
    pyenvVerCheck = 'pyenv versions --bare | awk "{print $1}" | grep -v /  | grep 3.9 | tail -1'
    pyenvRelease = 'pyenv install --list | awk "{print $1}" | grep -v -- - | grep -v /  | grep 3.9 | tail -1'

    importResult = False

    # -- Prompt input text --------------------------- 
    inputText = ''' Homebrew (https://brew.sh/) is not detected on your system (It may not be on your system $PATH). 
 It is necessary to obtain OpenImageIO and it's dependencies, would you like to automatically install it now? y/n 
 (If it is installed from a previous attempt, but not on your $PATH, answer Y)'''

    installText = '''Note: Parts of this process require building from source code, so it might take a few minutes depending on your PCs performance.
 It may seem like is has stopped working, but it has not. Just hang in there.'''

    # -- Executes a console instruction, it ----------
    # -- can activate an specific environment --------
    def ExecuteTerminalInstruction(inst, prefix='', env=None):
        terminalInstruction = prefix + inst
        _exec = f'/bin/bash -c \'{terminalInstruction}\''
        if env is not None:
            proc_result = subprocess.check_output(_exec, shell=True, env=env)
        else:
            proc_result = subprocess.check_output(_exec, shell=True)
        return proc_result.decode("utf-8").strip()

    # -- Checks if a path exists, if not, it runs ----
    # -- the given instruction in the given destPath -
    def CheckPathAndExecute(path, inst, destPath='', inst2=None):
        if not os.path.exists(path):
            ExecuteTerminalInstruction(inst, destPath)
        elif os.path.exists(path) and inst2 != None:
            ExecuteTerminalInstruction(inst2, destPath)

    # -- Check if Brew is installed ------------------
    def BrewInstallCheck():
        hadIssue = True
        brewPath = '/home/linuxbrew/.linuxbrew'
        brewCheck = 'if type brew 2>/dev/null; then echo true; else echo false; fi'
        env = f'{shellEnv} && '

        try:
            import OpenImageIO
        except ImportError:
            # -- Checks if Homebrew is present -----------
            if "Homebrew" in ExecuteTerminalInstruction("brew -v"):
                CheckPathAndExecute(f'{brewPath}/Cellar/openimageio', 'brew install openimageio')
                hadIssue = False
                return True
        finally:
            if hadIssue:
                if os.path.exists(brewPath) and 'true' in ExecuteTerminalInstruction(f'{brewCheck}'):
                    result = ExecuteTerminalInstruction('brew list openimageio', env)
                    print(f'OpenImageIO Found')
                    return True
                else:
                    if input(inputText).lower() == "y":
                        print(installText)

                        # -- Install Homebrew ------------
                        homebrew_install = '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                        subprocess.run(homebrew_install, shell=True)
                        print('Brew install complete. Installing needed dependencies')
                        return True
                    else:
                        print('You can find installation instructions on the official Linux Homebrew page: https://brew.sh/')
                        sys.exit()
        return True

    # -- Setup Environment ---------------------------
    def VirtualEnvSetup():
        venv_path = f'{py39} -m venv env --system-site-packages'
        getIOPath = 'brew list openimageio | xargs -n1 | grep site-packages'

        # -- Check if venv is installed --------------
        pipCmd = f'{py39} -m pip'
        if 'venv' not in sys.modules:
            ExecuteTerminalInstruction(f'{pipCmd} install virtualenv')

        # -- Create virtual build environment --------
        sys.path.append('/usr/lib/python3/dist-packages')
        oiio_path = ExecuteTerminalInstruction(getIOPath, f'{shellEnv} && ')

        # --  Locate OpenImageIO path ----------------
        if 'OpenImageIO.cpython' in oiio_path:
            oiio_package = os.path.dirname(oiio_path)
            sys.path.append(oiio_package)

            # -- Confirm we have the right version ---
            py_version = os.path.basename(os.path.dirname(oiio_package))
            if "3.9" not in py_version:
                print("Could not detect OpenImageIO's Python version.")
                sys.exit()

            packages = os.path.join(envPath, py_version)
            if not os.path.exists(packages):
                subprocess.run(venv_path, shell=True)
            else: 
                subprocess.run(f'{venv_path} --clear', shell=True)

            # -- Enable locating of OpenImageIO ------
            subprocess.check_call(f'echo "{oiio_package}" > {packages}/site-packages/openimageio.pth', shell=True)

            # -- Enable env and install requirements -
            ExecuteTerminalInstruction(f'python3 -m pip install -r requirements.txt', source)
            return packages

    # -- Install application dependencies ------------ 
    def InstallDeps(tmpenv):
        deps = '''sudo apt-get update && sudo apt-get install -y \
                gcc dpkg-dev build-essential python3-dev python3-pip python3.9-dev libgtk-3-dev libpng-dev libjpeg-dev \
                libtiff-dev libxxf86vm1 libxxf86vm-dev libxi-dev libxrandr-dev libsdl-dev libsdl1.2-dev libnotify-dev \
                libsm-dev libsdl2-mixer-2.0-0 libsdl2-image-2.0-0 libsdl2-2.0-0 libpython3.9-dev freeglut3-dev libgl1-mesa-dev \
                libglu1-mesa-dev libgstreamer-plugins-base1.0-dev libsdl2-dev libwebkit2gtk-4.0-dev libxtst-dev python3.9-venv
                '''
        subprocess.run(deps, shell=True, env=tmpenv)

        # -- Install wxPython ------------------------
        home = os.environ.get('HOME')
        wxpythonCheck = f'if [ -d "{home}/.local/lib/python3.9/site-packages/wx" ]; then echo true; else echo false; fi'

        print('Dependency install complete. Checking for wxPython. If it is not installed, it will be installed now. This can take a few minutes as well.')
        
        wxResult = ExecuteTerminalInstruction(wxpythonCheck)
        if 'true' not in wxResult:
            subprocess.run('python3.9 -m pip install wxPython==4.1.1', shell=True, env=tmpenv)

        sys.path.append(f'{home}/.local/lib/python3.9/site-packages')
        tmpenv.update({'PYTHONPATH': f'{home}/.local/lib/python3.9/site-packages'})

        # -- Install OpenImageIO ---------
        print('wxPython install complete. Installing OpenImageIO. This can take a while depending on the performance of you PC.')
        ExecuteTerminalInstruction('brew install openimageio', f'{shellEnv} && ', env=tmpenv)
        ExecuteTerminalInstruction('echo "Be sure to add the following to your system path:  /home/linuxbrew/.linuxbrew/bin" ')
        return tmpenv

    # -- Perform Linux Installation ------------------
    def InstallLinux(tmpenv):
        # Install pyinstaller in virtual environment
        try:
            ExecuteTerminalInstruction(f'{pipCmd} install pyinstaller', env=tmpenv)
            inst = f'{source}'
            inst += f' {pyBin}'
            inst += f' $(which pyinstaller)'
            inst += ' --hidden-import glcontext'
            inst += ' --hidden-import distutils'
            inst += ' --hidden-import openimageio'
            inst += ' --hidden-import wx'
            for lib in open('requirements.txt'):
                inst += ' --hidden-import {}'.format(lib.replace('\n', ''))
            inst += ' -i assets/GIMELSTUDIO_ICO.ico'
            inst += ' -n GimelStudio --noconfirm'
            inst += ' src/main.py'
            ExecuteTerminalInstruction(inst)
            dest = "dist/GimelStudio/nodes"
            inst = "cp -r src/nodes " + dest
            CheckPathAndExecute(dest, inst, inst2="rm -rf " + dest + " && " + inst)
            return True
        except Exception as e:
            return False

    # -- Helper Methods ------------------------------
    # -- Ask whether to continue ---------------------
    def AskContinue():
        if input("Do you want to continue with installation y/n?").lower() == "n":
            sys.exit()

    # -- Selected program exit -----------------------
    def noThreeDotNine():
        print("Please run the build process again once you are using Python 3.9.x")
        sys.exit()

    # -- Obtain the current python version -----------
    def getPythonVersion():
        ver = sys.version_info[:2]
        return f'{ver[0]}.{ver[1]}'

    def FinalImageIOCheck():
        try:
            import OpenImageIO
            return True
        except ImportError:
            print('\033[91m', "Error loading OpenImageIO", '\033[0m')
            print("hint run:\n", '\033[93m', "brew doctor", '\033[0m')
            AskContinue()
            return False

    # /////////////////////////////////////////////////////////////// 
    # -- Initiate Requirement Verification --------------------------
    # ///////////////////////////////////////////////////////////////
    py_version = getPythonVersion()
    has_brew = False

    # -- Check for appropriate Python version --------
    if "3.9" not in py_version:
        print(f'OpenImageIO requires python version 3.9.x. Your current version is: {py_version}')
        pyenvResult = ExecuteTerminalInstruction(pyenvCheck)

        if "false" in pyenvResult:
            noThreeDotNine()
        else:
            envLatest = ExecuteTerminalInstruction(pyenvVerCheck)
            latestRelease = ExecuteTerminalInstruction(pyenvRelease)
            if envLatest:
                print(f'You have pyenv on your system and v{envLatest} available. Run the following command and then run the build again: pyenv global {envLatest}')
                sys.exit()
            else:
                print(f'You do not have the proper version of Python installed via Pyenv. Run the following command to install and activate it, then run the build again: pyenv install {latestRelease} && pyenv global {latestRelease} ')
                sys.exit()           

    # -- Check for Homebrew dependencies -------------
    has_brew = BrewInstallCheck()

    if has_brew:
        tmpEnv = InstallDeps(tmpEnv)
        sitePackages = VirtualEnvSetup()

    if sitePackages:
        importResult = FinalImageIOCheck()

    if importResult:
        # -- Prerequisites are met, continue with build --
        if input("Prerequisites and dependency installation complete. Do you want to create an executable? y/n ").lower() == "y":
            result = InstallLinux(tmpEnv)
            if result:
                if input(("Build complete. Run GimelStudio now? y/n ")).lower() == "y":
                    subprocess.Popen('cd dist/GimelStudio && ./GimelStudio &', shell=True)
                    sys.exit()
                else:
                    print('You can run GimelStudio any time by navigating to the dist/GimelStudio folder and running the following command: ./GimelStudio')
                    sys.exit()
        
        else:
            print("All dependencies are installed already\nIf you want to run this code please activate virtual environment")
            print("To activate virtual environment just write in console\n", '\033[92m', "source env/bin/activate", '\033[0m')
            print("Once the virtual environment is activated you can execute any python program")
    else:
        print("Executable is not possible to be created since", '\033[91m', "import OpenImageIO", '\033[0m', " failed")

    sys.exit()

# -- Build Process Initiation ---------------------------------------
# -------------------------------------------------------------------
# Check if this is 64-bit
if not sys.maxsize > 2**32:
    raise NotImplementedError("Only 64-bit systems are supported!")

currentPlatform = sys.platform

# Install the required packages
if "darwin" in currentPlatform:
    MAC()
elif currentPlatform in ["linux", "linux2"]:
    LINUX()
elif "win32" in currentPlatform:
    subprocess.call(["pip", "install", "-r", "requirements.txt"])
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")

# Prompt to install openimageio on windows
if "win32" in currentPlatform:
    try:
        import OpenImageIO
    except ImportError:
        print("\n\nPlease pip install the openimageio wheel that matches your python version from https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio\n\n")
        sys.exit()

# Setup the correct arguments and options based on the platform
args = [
    "pyinstaller",
    "src/main.py",
    "-n", "GimelStudio",
    "--noconfirm",
    "--hidden-import",
    "pkg_resources.py2_warn",
    "--hidden-import",
    "glcontext",
]

# if DEBUG is False:
#     args.append("--noconsole")

if "win32" in currentPlatform:
    args.append("-i")
    args.append("assets/GIMELSTUDIO_ICO.ico")
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")

subprocess.call(args)

if sys.platform == "win32":
    shutil.copytree("src/nodes", "dist/GimelStudio/nodes")
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")
