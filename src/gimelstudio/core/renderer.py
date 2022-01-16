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

from .eval_info import EvalInfo
from .datatypes import RenderImage


class Renderer(object):
    """
    The core renderer which evaluates the nodes in the node tree and
    outputs the final render image.
    """
    def __init__(self, parent):
        self.parent = parent
        self.render = None
        self.output_node = None

    def GetParent(self):
        return self.parent

    def GetRender(self):
        return self.render

    def SetRender(self, render):
        self.render = render

    def SetOutputNode(self, node):
        self.output_node = node

    def Render(self):
        """ Render method for evaluating the Node Graph
        to render an image.

        :returns: RenderImage object
        """
        # Render the image
        image = self.RenderNodeGraph(self.output_node)
        self.SetRender(image)

        # TODO: Only if node thumbnails are enabled
        self.output_node.NodeUpdateThumb(image)
        return image

    def RenderNodeGraph(self, output_node):
        """ Render the image, starting from the output node.

        :param output_node: the output node object
        :returns: RenderImage object
        """
        # Get the node connected to the output node and evaluate from there.
        node = output_node.parameters["image"].binding
        if node is not None:
            eval_info = EvalInfo(node)
            image = eval_info.node.EvaluateNode(eval_info)
            return image
        else:
            # If there is no connection, then return a default transparent image.
            return RenderImage()
