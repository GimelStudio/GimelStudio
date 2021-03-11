#!/usr/bin/env python

"""
This is a way to save the startup time when running img2py on lots of
files...

Add this to the top of the file:
    from wx.lib.embeddedimage import PyEmbeddedImage

Then you're good to go!
"""

import os
import sys
from wx.tools import img2py


def PrepareIconCommands(dest_file='icons.py'):
    filelist = []
    for file in os.listdir("icons_source/"):
        if file.endswith('.png'):
            filelist.append(file)

    commandlines = []
    for icon in filelist:
        ico_path = "icons_source/{}".format(icon)
        ico_name = icon.split('.')[0]
        cmd = "-a -n ICON_{} {} {}".format(ico_name, ico_path, dest_file)
        commandlines.append(cmd)
    return commandlines


if __name__ == "__main__":
    command_lines = PrepareIconCommands()
    for line in command_lines:
        args = line.split()
        img2py.main(args)

