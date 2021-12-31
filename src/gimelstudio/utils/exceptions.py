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


class NodeExistsError(Exception):
    """ This exception is raised when a node is registered
    that already exists in the Node Registry. """

    def __init__(self, name):
        super(NodeExistsError, self).__init__(name)
        self._name = name

    def __str__(self):
        return "The node {} already exists within the registry.".format(self._name)


class NodeNotFoundError(Exception):
    """ This exception is raised when a node is not found in
    the Node Registry. """

    def __init__(self, name):
        super(NodeNotFoundError, self).__init__(name)
        self._name = name

    def __str__(self):
        return """The node {} could not be found in the registry.
        Maybe you forgot to register it? """.format(self._name)