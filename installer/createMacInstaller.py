import os
import sys
if getattr(sys, 'frozen', False):
    rootP = os.path.dirname(sys.executable)+'/'
elif __file__:
    rootP = os.path.dirname('')
print(rootP)

def execS(inst,env='source {}env/bin/activate && '.format(rootP)):
    terminalInstruction = env+inst
    os.system(terminalInstruction)
    
def checkPathandExecute(path,inst,g=False):
    if g:
        ar=path
    else:
        ar=rootP+path
    if not os.path.exists(ar):
        execS(inst,'')
def remDir(dir):
    return "rm -rf {}".format(rootP+dir)
def rem(fd,d="f"):
    execS("rm -"+d+" "+rootP+fd,'')

def getFiles():
    dirFile=["assets","requirements.txt","src"]
    for file in dirFile:
        checkPathandExecute(file,"git clone https://github.com/GimelStudio/GimelStudio {}gs".format(rootP))
        break
    for file in dirFile:
        execS("mv {r}gs/{f} {r}{f}".format(f=file,r=rootP),"")
    rem('gs',"rf")

def cleanFiles():
    rem('env','rf')
    rem('build','rf')
    execS('mv {r}dist/GimelStudio.app {r}GimelStudio.app'.format(r=rootP),'')
    rem('dist','rf')
    rem('*.spec')
    rem('assets','rf')
    rem('requirements.txt')
    rem('src','rf')



getFiles()
checkPathandExecute('env','python3 -m venv --system-site-packages {}env'.format(rootP))
checkPathandExecute('/usr/local/Cellar/openimageio','brew install openimageio',True)

    
    
#Activating virtual enviroment
execS("pip3 install pyinstaller")
inst='pyinstaller --onefile {}src/main.py'.format(rootP)
for lib in open('{}requirements.txt'.format(rootP)):
    inst+=' --hidden-import {}'.format(lib.replace('\n',''))
inst+=' --hidden-import wx --windowed -i {}assets/GIMELSTUDIO_ICO.ico -n GimelStudio'.format(rootP)
inst+=' --noconfirm'
inst+=' --distpath {}dist'.format(rootP)
inst+=' --workpath {}build'.format(rootP)
inst+=' --specpath {}'.format(rootP)

execS(inst)
cleanFiles()




