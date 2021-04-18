# ----------------------------------------------------------------------------
# GS Nodegraph Copyright 2019-2021 by Noah Rahm and contributors
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

from gsnodegraph import NodeBase


class OutputNode(NodeBase):
    def __init__(self, nodegraph):
        NodeBase.__init__(self, nodegraph)

        self._label = "Output"
        self._isoutput = True
        self._category = "OUTPUT"


class ImageNode(NodeBase):
    def __init__(self, nodegraph):
        NodeBase.__init__(self, nodegraph)

        self._label = "Image"
        self._category = "INPUT"


class MixNode(NodeBase):
    def __init__(self, nodegraph):
        NodeBase.__init__(self, nodegraph)

        self._label = "Mix"
        self._category = "BLEND"
