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

from layer import Layer
from nodes import NodeGraph


class LayerStack(object):
    def __init__(self):
        self.layers = {}

    def GetLayers(self):
        return self.layers

    def AddLayer(self, layer):
        self.layers[layer._id] = layer



if __name__ == '__main__':

    nodegraph = NodeGraph()

    layer_stack = LayerStack()

    layer1 = Layer(1000, 1200)
    layer2 = Layer(1700, 1100)
    layer2.SetVisible(False)
    layer3 = Layer(800, 100)

    layer_stack.AddLayer(layer1)
    layer_stack.AddLayer(layer2)
    layer_stack.AddLayer(layer3)

    for layer_id in layer_stack.layers:
        layer = layer_stack.layers[layer_id]
        if layer.GetIsVisible() is True:
            print(layer, layer.height)
            print(layer.NodeGraph, "<<<")