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

from gimelstudio.utils import NodeExistsError, NodeNotFoundError

# The node registry is simply a python dictionary holding all of the available
# nodes in this application session. To be registered means that is is usable in
# the application (i.e can be used in the nodegraph).
NODE_REGISTRY = {}


def RegisterNode(node, idname=""):
    """ Attempts to register a new node with the Node Registry.

    :param nodedef: subclass of NodeBase defining the node to be registered
    :param idname: type identifier of the node to be registered
    """
    if idname == "":
        raise TypeError("Please specify the idname of the node you want to register!")
    else:
        if idname in NODE_REGISTRY:
            raise NodeExistsError(idname)

        NODE_REGISTRY[idname] = node


def UnregisterNode(idname):
    """ Attempts to unregister a node in the Node Registry.

    :param idname: type identifier of the node to be unregistered
    """
    if idname == "":
        raise TypeError("Please specify the idname of the node you want to unregister!")
    else:
        if idname not in NODE_REGISTRY:
            raise NodeNotFoundError(idname)
        else:
            del NODE_REGISTRY[idname]
