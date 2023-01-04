# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
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


class IntegerNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Integer",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "INPUT",
            "description": "Input an integer.",
        }
        return meta_info

    def NodeInitProps(self):
        integer = api.IntegerProp(
            idname="sel_integer",
            default=1,
            min_val=0,
            max_val=800,
            fpb_label="Integer",
            can_be_exposed=False
        )
        self.NodeAddProp(integer)

    def NodeInitOutputs(self):
        self.outputs = {
            "integer": api.Output(idname="integer", datatype="INTEGER", label="Integer"),
        }

    def NodeEvaluation(self, eval_info):
        integer = self.EvalProperty(eval_info, "sel_integer")

        return {
            "integer": integer
        }


api.RegisterNode(IntegerNode, "node_integer")
