# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by the Gimel Studio project contributors
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

import json
import wx

from gsnodegraph.constants import SOCKET_INPUT, SOCKET_OUTPUT


class ProjectFileIO(object):
    def __init__(self, app_config):
        self.file_path = ""
        self.contents = {}
        self.app_config = app_config

        self.InitFileStructure()

    def InitFileStructure(self):
        self.contents["application"] = self.app_config.app_name
        self.contents["file_type"] = "Gimel Studio Project"
        self.contents["app_version"] = self.app_config.app_version
        self.contents["app_version_tag"] = self.app_config.app_version_tag
        self.contents["app_version_full"] = self.app_config.app_version_full
        self.contents["node_graph"] = {}
        self.contents["node_graph"]["nodes"] = {}

    def GetFilePath(self):
        return self.file_path

    def SaveNodesData(self, nodes):
        nodes_data = {}

        for node_id in nodes:
            data = {}
            node = nodes[node_id]

            # Parameters
            param_data = {}
            for param in node.parameters:
                parameter = node.parameters[param]
                if parameter.binding != None:
                    # We use the id of the node
                    binding = parameter.binding.id
                else:
                    # Represents that a node is not 
                    # connected to this socket.
                    binding = ""
                param_data[param] = {
                    "idname": parameter.idname,
                    "binding": binding
                }

            # Properties
            prop_data = {}
            for prop in node.properties:
                property = node.properties[prop]
                prop_data[prop] = {
                    "idname": property.idname,
                    "value": property.value
                }

            data["idname"] = node.idname
            data["pos"] = (node.pos.x, node.pos.y)
            data["muted"] = node.muted
            data["selected"] = node.selected
            data["active"] = node.active
            data["expanded"] = node.expanded
            data["parameters"] = param_data
            data["properties"] = prop_data

            nodes_data[node_id] = data

        self.contents["node_graph"]["nodes"] = nodes_data

    def CreateNodesFromData(self, nodegraph):
        # Clear previous nodes and wires
        nodegraph.nodes = {}
        nodegraph.wires = []

        # Create the nodes from the data
        nodes_data = self.contents["node_graph"]["nodes"]
        for node_id in nodes_data:
            node_data = nodes_data[node_id]

            # Create the node object
            node = nodegraph.AddNode(node_data["idname"], 
                                    pos=node_data["pos"], 
                                    nodeid=node_id,
                                    location="POSITION")

            # Create the node properties
            prop_data = node_data["properties"]
            for prop in prop_data:
                node.NodeEditProp(idname=prop_data[prop]["idname"],
                                  value=prop_data[prop]["value"], 
                                  render=False)

        # Create the parameters and node connections
        for node_id in nodes_data:
            node_data = nodes_data[node_id]
            node_objs = nodegraph.GetNodes()
            param_data = node_data["parameters"]
            node = node_objs[node_id]

            for socket in node.GetSockets():
                if socket.direction == SOCKET_INPUT:
                    dst_socket = socket

                    # Find the output socket, connect the input socket
                    src_node_id = param_data[dst_socket.idname]["binding"]  
                    if src_node_id != "":  # Make sure there actually is a node connected
                        src_node = node_objs[src_node_id]

                        for socket in src_node.GetSockets():
                            # We're assuming there is only one output
                            if socket.direction == SOCKET_OUTPUT:
                                src_socket = socket

                        # Finally, connect the sockets
                        nodegraph.ConnectNodes(src_socket, dst_socket)
            
        nodegraph.UpdateNodeGraph()

    def WriteFile(self, file_path, contents):
        try:
            with open(file_path, "w") as file:
                json.dump(contents, file, indent=4)
        except Exception as error:
            print(error)
        return file_path

    def OpenFile(self, file_path):
        with open(file_path, "r") as file:
            file_contents = json.load(file)
            self.contents = file_contents
        self.file_path = file_path

    def SaveFile(self):
        self.WriteFile(self.file_path, self.contents)

    def SaveFileAs(self, file_path):
        self.file_path = self.WriteFile(file_path, self.contents)
