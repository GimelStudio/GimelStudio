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
        dest = "dist/nodescripts"
        inst = "cp -r src/nodescripts " + dest
        CheckPathAndExecute(dest, inst, inst2="rm -rf " + dest + " && "+ inst)
    
    # Ask whether to continue
    def AskContinue():
        if input("Do you want to continue with installation y/n?").lower() == "n":
            sys.exit()
    
    try:
        import OpenImageIO
    except:
        if "Homebrew" in subprocess.run(["brew", "-v"], capture_output=True).stdout.decode("utf-8"):
            # Checks if brew is installed
            CheckPathAndExecute('/usr/local/Cellar/openimageio', 'brew install openimageio')
        else :
            print("Homebrew not installed, please install it and try again")
            AskContinue()
    possible=True
    try:
        import OpenImageIO
    except:
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

if not sys.maxsize > 2**32:
    raise NotImplementedError("Only 64-bit systems are supported!")

# Install the required packages
if sys.platform == "linux" or sys.platform == "linux2":
    pass  # TODO
elif sys.platform == "darwin":
    MAC()
elif sys.platform == "win32":
    subprocess.call(["pip", "install", "-r", "requirements.txt"])
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")

# Prompt to install openimageio
if sys.platform == "win32":
    print("\n\npip install the openimageio wheel that matches your python version from https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio\n\n")

# Setup the correct arguments and options based on the platform
args = [
    "pyinstaller",
    "-n", "GimelStudio",
    "--noconsole",
    "--noconfirm",
    "--hidden-import",
    "pkg_resources.py2_warn"
    ]

if sys.platform == "linux" or sys.platform == "linux2":
    pass  # TODO
elif sys.platform == "win32":
    args.append("-i")
    args.append("assets/GIMELSTUDIO_ICO.ico")
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")

args.append("src/main.py")
subprocess.call(args)

# Create a new folder for custom node scripts then copy the
# nodescripts directory contents into the created folder.
if sys.platform == "linux" or sys.platform == "linux2":
    subprocess.call(["mkdir", "./dist/GimelStudio/nodescripts"])
    shutil.copytree("./src/nodescripts", "./dist/GimelStudio/nodescripts")
elif sys.platform == "win32":
    shutil.copytree("src/nodescripts", "dist/GimelStudio/nodescripts")
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")
