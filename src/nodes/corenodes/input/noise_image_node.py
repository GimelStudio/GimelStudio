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

try:
    import OpenImageIO as oiio
except ImportError:
    print("""OpenImageIO is required! Get the python wheel for Windows at:
     https://www.lfd.uci.edu/~gohlke/pythonlibs/#openimageio""")

from gimelstudio import api


class NoiseImageNode(api.Node):
    def __init__(self, nodegraph, _id):
        api.Node.__init__(self, nodegraph, _id)

    @property
    def NodeMeta(self):
        meta_info = {
            "label": "Noise",
            "author": "Gimel Studio",
            "version": (0, 0, 5),
            "category": "INPUT",
            "description": "Creates a noise image."
        }
        return meta_info

    def NodeWidgetEventHook(self, idname, value):
        if idname == "noise_seed":
            image = self.NodeEvalSelf()
            self.NodeUpdateThumb(image)
            self.RefreshNodeGraph()

    def NodeDndEventHook(self):
        image = self.NodeEvalSelf()
        self.NodeUpdateThumb(image)
        self.RefreshNodeGraph()

    def NodeInitProps(self):
        noise_seed = api.PositiveIntegerProp(
            idname="noise_seed",
            default=1,
            min_val=0,
            max_val=100,
            fpb_label="Noise Seed"
        )

        self.NodeAddProp(noise_seed)

    def NodeEvaluation(self, eval_info):
        noise_seed = self.EvalProperty(eval_info, "noise_seed")

        render_image = api.RenderImage()

        buf = oiio.ImageBuf(oiio.ImageSpec(1200, 1200, 4, oiio.FLOAT))
        oiio.ImageBufAlgo.noise (buf, "gaussian", 0.5, 0.5, mono=True, seed=noise_seed)

        render_image.SetAsImage(buf)
        self.NodeUpdateThumb(render_image)
        return render_image


api.RegisterNode(NoiseImageNode, "corenode_noiseimage")
