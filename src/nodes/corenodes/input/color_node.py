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


class ColorNode(api.Node):
    def __init__(self, nodegraph, id):
        api.Node.__init__(self, nodegraph, id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Color",
            "author": "Gimel Studio",
            "version": (0, 0, 5),
            "category": "INPUT",
            "description": "Inputs a color."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        image = self.NodeEvalSelf()
        self.NodeUpdateThumb(image)
        self.RefreshNodeGraph()

    def NodeInitProps(self):
        color = api.ColorProp(
            idname="sel_color",
            default=(255, 255, 255, 255),
            label="",
            fpb_label="Color",
            can_be_exposed=False
        )
        self.NodeAddProp(color)

    def NodeInitOutputs(self):
        self.outputs = {
            "color": api.Output(idname="color", datatype="COLOR", label="Color"),
        }

    def NodeEvaluation(self, eval_info):
        color = self.EvalProperty(eval_info, "sel_color")

        return {
            "color": color
        }

api.RegisterNode(ColorNode, "corenode_color")



