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

import numpy as np
from gimelstudio import api


class VectorNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Vector",
            "author": "Gimel Studio",
            "version": (0, 0, 5),
            "category": "INPUT",
            "description": "Inputs a vector."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        image = self.NodeEvalSelf()
        self.NodeUpdateThumb(image)
        self.RefreshNodeGraph()

    def NodeInitProps(self):
        vector = api.VectorProp(
            idname="sel_vector", 
            default=(1, 1, 1), 
            labels=("X", "Y", "Z"),
            min_vals=(1, 1, 1), 
            max_vals=(800, 800, 800),
            show_p=False, 
            enable_z=True,
            fpb_label="Vector",
            can_be_exposed=False
        )
        self.NodeAddProp(vector)

    def NodeInitOutputs(self):
        self.outputs = {
            "vector": api.Output(idname="vector", datatype="VECTOR", label="Vector"),
        }

    def NodeEvaluation(self, eval_info):
        vector = self.EvalProperty(eval_info, "sel_vector")

        return {
            "vector": vector
        }

api.RegisterNode(VectorNode, "corenode_vector")
