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

import uuid
from typing import Tuple

import numpy as np


# Layer types
LAYER_TYPE_VECTOR = "vector"
LAYER_TYPE_RASTER = "raster"

# Layer modes
LAYER_MODE_NORMAL = "normal"
LAYER_MODE_MULTIPLY = "multiply"
LAYER_MODE_OVERLAY = "overlay"


class LayerModel(object):
    def __init__(self, width, height, label="", visible=True, locked=False, 
                 opacity=100, node_graph=None, _type=LAYER_TYPE_RASTER):
        self._id = str(uuid.uuid4())
        self.width = width
        self.height = height
        self.label = label
        self.visible = visible
        self.locked = locked
        self.opacity = opacity
        self.mode = LAYER_MODE_NORMAL
        self.nodegraph = node_graph
        self.type = _type
        self.selected = False

        self._cache = None
        self._thumb = None

    def GetSize(self) -> Tuple:
        return (self.width, self.height)

    def SetSize(self, width: int, height: int) -> None:
        self.width = width
        self.height = height

    def GetLabel(self):
        return self.label

    def SetLabel(self, label):
        self.label = label

    def GetIsVisible(self) -> bool:
        return self.visible

    def SetVisible(self, visible: bool) -> None:
        self.visible = visible

    def GetIsLocked(self) -> bool:
        return self.locked

    def SetLocked(self, locked: bool) -> bool:
        self.locked = locked

    def GetOpacity(self) -> int:
        return self.opacity

    def SetOpacity(self, opacity: int) -> None:
        self.opacity = opacity

    def GetMode(self) -> str:
        return self.mode

    def SetMode(self, mode: str) -> None:
        self.mode = mode

    def GetType(self) -> str:
        return self.type

    def SetType(self, _type: str) -> None:
        self.type = _type

    def GetIsSelected(self) -> bool:
        return self.selected

    def SetSelected(self, selected: bool) -> None:
        self.selected = selected

    def GetCache(self) -> np.ndarray:
        return self._cache

    def CacheImage(self, image: np.ndarray) -> None:
        self._cache = image

    def GetThumb(self) -> np.ndarray:
        return self._thumb

    def SetThumb(self, thumb: np.ndarray) -> None:
        self._thumb = thumb

    @property
    def NodeGraph(self):
        return self.nodegraph

    def Evaluate(self) -> None:
        """ Evaluate the current layer's node graph. """
        if self.GetIsVisible() is True:
            pass  # eval the node graph
        else:
            pass


class Layer(LayerModel):
    def __init__(self, width, height, label="", visible=True, locked=False, 
                 opacity=100, node_graph=None, _type=LAYER_TYPE_RASTER):
        LayerModel.__init__(self, width, height, label, visible, locked, 
                            opacity, node_graph, _type)



if __name__ == '__main__':

    layer1 = Layer(1000, 1200)
    layer2 = Layer(1700, 1100)
    layer2.SetVisible(False)
    layer3 = Layer(800, 100)

    layer_stack = [layer1, layer2, layer3]

    for layer in layer_stack:
        if layer.GetIsVisible() is True:
            print(layer, layer.height)
