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

from gimelstudio import api


class StringNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "String",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "INPUT",
            "description": "Input a string.",
        }
        return meta_info

    def NodeInitProps(self):
        string = api.StringProp(
            idname="sel_string",
            default="",
            fpb_label="String",
            can_be_exposed=False
        )
        self.NodeAddProp(string)

    def NodeInitOutputs(self):
        self.outputs = {
            "string": api.Output(idname="string", datatype="STRING", label="String"),
        }

    def NodeEvaluation(self, eval_info):
        string = self.EvalProperty(eval_info, "sel_string")

        return {
            "string": string
        }


api.RegisterNode(StringNode, "corenode_string")
