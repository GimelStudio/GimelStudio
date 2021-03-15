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


def Parameter(object):
    def __init__(self):
        self.input = None


def Property(object):
    def __init__(self):
        self.input = None


class NodeModel(object):
    def __init__(self, label):
        self._id = uuid.uuid4()
        self.label = label


class Node(NodeModel):
    def __init__(self, label):
        NodeModel.__init__(self, label)


class NodeGraph(object):
    def __init__(self):

        self._id = uuid.uuid4()
        self.nodes = {}


if __name__ == '__main__':

    nd1 = Node("image")
    nd2 = Node("image")
    nd3 = Node("mix")

    print(nd1._id)
    