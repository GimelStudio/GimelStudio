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

from gimelstudio import api


class ValueNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Value",
            "author": "Gimel Studio",
            "version": (0, 5, 0),
            "category": "INPUT",
            "description": "Input an integer or float.",
        }
        return meta_info

    def NodeOutputDatatype(self):
        return "VALUE"

    def NodeInitProps(self):
        value = api.PositiveIntegerProp(
            idname="value",
            default=100,
            min_val=0,
            max_val=100,
            fpb_label="Integer Value"
        )
        self.NodeAddProp(value)

    def NodeEvaluation(self, eval_info):
        value = self.EvalProperty(eval_info, "value")

        return value


api.RegisterNode(ValueNode, "node_value")
