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

class FloatNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Float",
            "author": "Gimel Studio",
            "version": (0, 6, 0),
            "category": "INPUT",
            "description": "Input a float",
        }
        
        return meta_info

    def NodeInitProps(self):
        float_ = api.FloatProp(
            idname="sel_float",
            default=1.0,
            min_val=-100000.0,
            max_val=100000.0,
            fpb_label="Float",
            can_be_exposed=False
        )

        self.NodeAddProp(float_)

    def NodeInitOutputs(self):
        self.outputs = {
            "float": api.Output(idname="float", datatype="FLOAT", label="Float")
        }

    def NodeEvaluation(self, evel_info):
        float_ = self.EvalProperty(eval_info, "sel_float")

        return {
            "float": float_
        }

api.RegisterNode(FloatNode, "node_float")

