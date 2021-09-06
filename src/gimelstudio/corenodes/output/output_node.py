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

from gimelstudio import api


class OutputNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    def IsOutputNode(self):
        return True

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Output",
            "author": "Gimel Studio",
            "version": (0, 1, 3),
            "category": "OUTPUT",
            "description": """The most important node of them all. :)
        This is registered here for the UI -the evaluation is handled elsewhere.
        This node should not be accessed by outside users.
        """
        }
        return meta_info

    def NodeInitParams(self):
        p = api.RenderImageParam('Image')
        self.NodeAddParam(p)

    def NodeEvaluation(self, eval_info):
        pass


api.RegisterNode(OutputNode, "corenode_outputcomposite")
