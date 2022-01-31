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

import uuid


class NodeIdPool(object):
    def __init__(self):
        self.ids = []

    def GenerateId(self):
        return uuid.uuid4()

    def CanUseId(self, the_id):
        if the_id in self.ids:
            return self.GenerateId()
        else:
            self.ids.append(the_id)
            return the_id
