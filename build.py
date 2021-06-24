import os
import sys
import shutil
import subprocess

def MAC():
    #Executes a console instruction, it can activate an specific environment
    def executeTerminalInstruction(inst,env='source env/bin/activate && '):
        terminalInstruction = env+inst
        os.system(terminalInstruction)

    #Checks if a path exists, if not, it runs the given instruction in the given destPath
    def CheckPathAndExecute(path,inst,destPath=''):
        if not os.path.exists(path):
            executeTerminalInstruction(inst,destPath)
    
    #Creates the Mac executable
    def installMac():
        #Install pyinstaller in virtual environtment
        executeTerminalInstruction("pip3 install pyinstaller")
        inst='pyinstaller --onefile src/main.py'
        for lib in open('requirements.txt'):
            inst+=' --hidden-import {}'.format(lib.replace('\n',''))
        inst+=' --hidden-import wx --windowed -i assets/GIMELSTUDIO_ICO.ico -n GimelStudio'
        inst+=' --noconfirm'
        executeTerminalInstruction(inst)
    
    #Ask for continue
    def Askcontinue():
        if input("Do you want to continue with installation y/n? ").lower()=="n":
            sys.exit()
    
    try:
        import OpenImageIO
    except:
        if "Homebrew" in subprocess.run(["brew","-v"],capture_output=True).stdout.decode("utf-8"):
            #Checks if brew is installed
            CheckPathAndExecute('/usr/local/Cellar/openimageio','brew install openimageio')
        else :
            print("Homebrew not installed, please install it and try again")
            Askcontinue()
    possible=True
    try:
        import OpenImageIO
    except:
        print('\033[91m',"Error loading OpenImageIO",'\033[0m')
        print("hint run:\n",'\033[93m',"brew doctor",'\033[0m')
        Askcontinue()
        possible=False

    #If the virtual environment is not created, it creates it.
    CheckPathAndExecute('env','python3 -m venv --system-site-packages env')
    #Installs the libraries contained in requirements
    executeTerminalInstruction('pip3 install -r requirements.txt')
    if possible:
        if input("Do you want to create an executable y/n?").lower()=="y":
            installMac()
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
else:
    print("openimageio not available")

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
elif sys.platform == "darwin":
    args.append("--hidden-import")
    args.append("wx")
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
elif sys.platform == "darwin":
    pass  # TODO
elif sys.platform == "win32":
    shutil.copytree("src/nodescripts", "dist/GimelStudio/nodescripts")
else:
    raise NotImplementedError("Only Windows, Linux and MacOs are supported!")