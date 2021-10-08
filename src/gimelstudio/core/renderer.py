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

from .output_eval import OutputNodeEval


class Renderer(object):
    """
    The core renderer which evaluates the data of the node tree and
    outputs the final render image.
    """
    def __init__(self, parent):
        self._parent = parent
        self._render = None

    def GetParent(self):
        return self._parent

    def GetRender(self):
        return self._render

    def SetRender(self, render):
        self._render = render

    def Render(self, nodes):
        """ Render method for evaluating the Node Graph
        to render an image.

        :param nodes: dictionary of nodes of the Node Graph
        :returns: rendered image
        """

        # Render the image
        output_node = self.GetOutputNode(nodes)
        rendered_image = self.RenderNodeGraph(output_node, nodes)

        # Get rendered image, otherwise use
        # the default transparent image.
        if rendered_image is not None:
            image = rendered_image
        else:
            # TODO: don't hardcode this
            image = output_node._parameters["Image"].value

        self.SetRender(image)
        return image

    def RenderNodeGraph(self, output_node, nodes):
        """ Render the image, starting from the output node.

        :param output_node: the output node object
        :param nodes: dictionary of nodes of the Node Graph
        :returns: RenderImage object
        """
        output_data = OutputNodeEval()
        output_data.SetNode(output_node)
        return output_data.RenderImage()

    def GetOutputNode(self, nodes):
        """ Get the output composite node.

        :param nodes: dictionary of nodes of the Node Graph
        :returns: node object of output node
        """
        for nodeid in nodes:
            if nodes[nodeid].IsOutputNode() is True:
                output_node = nodes[nodeid]
        return output_node
