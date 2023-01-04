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

import os


def LoadPythonScripts(directory, module):
    """ Loads python scripts from the given directory. """
    paths = os.listdir(directory)
    for path in paths:
        name, ext = os.path.splitext(path)
        if name in ["__init__.py", "__pycache__"]:
            continue
        node_module = __import__(module, fromlist=[name])

def LoadNodes(type, directory, module):
    try:
        LoadPythonScripts(directory, module)
        print("[INFO] Registered {} nodes".format(type))
    except Exception as error:
        print("[WARNING] Error registering {} nodes: \n".format(type), error)
    finally:
        pass


# Load the output composite node
from .core.output_node import OutputNode

# Next, we load the core and custom nodes from the 'nodes' directory.
LoadNodes("core", "nodes/corenodes", "nodes.corenodes")
LoadNodes("custom", "nodes/customnodes", "nodes.customnodes")
