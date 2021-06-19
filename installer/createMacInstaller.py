import os
def execS(inst,env='source env/bin/activate && '):
    terminalInstruction = env+inst
    os.system(terminalInstruction)
    
def checkPathandExecute(path,inst):
    if not os.path.exists(path):
        execS(inst,'')
def remDir(dir):
    return "rm -rf {}".format(dir)
    
def getFiles():
    dirFile=["assets","requirements.txt","src"]
    for file in dirFile:
        checkPathandExecute(file,"git clone https://github.com/GimelStudio/GimelStudio gs")
        break
    for file in dirFile:
        execS("mv gs/{f} {f}".format(f=file),"")
    execS(remDir('gs'),'')

getFiles()
checkPathandExecute('env','python3 -m venv --system-site-packages env')
checkPathandExecute('/usr/local/Cellar/openimageio','brew install openimageio')
def cleanFiles():
    execS('rm -rf env','')
    execS('rm -rf build','')
    execS('mv dist/GimelStudio.app GimelStudio.app','')
    execS('rm -rf dist','')
    execS('rm -rf *.spec','')
    execS('rm -rf assets','')
    execS('rm -f requirements.txt','')
    execS('rm -rf src','')
    
    
#Activating virtual enviroment
execS("pip3 install pyinstaller")
inst='pyinstaller --onefile src/main.py'
for lib in open('requirements.txt'):
    inst+=' --hidden-import {}'.format(lib.replace('\n',''))
inst+=' --hidden-import wx --windowed -i assets/GIMELSTUDIO_ICO.ico -n GimelStudio'
inst+=' --noconfirm'
execS(inst)
cleanFiles()




