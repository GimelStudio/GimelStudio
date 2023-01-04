# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
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

"""
Utility script to generate PyEmbeddedImage bitmap icons and write into
'icons.py' file from images in the icons_source directory.

1. Just run this file in-place and an 'icons.py' file should be
generated.
2. Place the icons file in the Gimel Studio 'datafiles' directory.
"""

import os
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

    # Add import statement to top
    with open("icons.py", "r+") as file:
        file.write("from wx.lib.embeddedimage import PyEmbeddedImage\n#")
    print("Done!")
