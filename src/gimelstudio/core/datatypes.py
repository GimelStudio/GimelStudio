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

import cv2
import numpy as np
try:
    import OpenImageIO as oiio
except ImportError:
    print("OpenImageIO is required!")


class RenderImage(object):
    def __init__(self, size=(20, 20)):
        self.img = np.zeros((size[0], size[1], 4), dtype=np.float32)

    def Image(self, data_type="numpy"):
        """ Returns the image in the requested datatype format.

        This is optimized so that it does node convert the datatype until
        Image() or OIIOImage() is called. This way, the datatype won't be
        converted for nothing e.g: if an oiio.ImageBuf type is needed for a
        line of nodes, no need to convert it to numpy array every time.

        :param data_type: the requested image datatype
        :returns: ``numpy.ndarray`` or ``oiio.ImageBuf`` object
        """
        current_data_type = type(self.img)
        if data_type == "numpy":
            if current_data_type == np.ndarray:
                return self.img
            else:
                self.img = self.img.get_pixels("float")
                return self.img

        elif data_type == "oiio":
            print("[WARNING] Converting to oiio is disabled!")
            # if current_data_type == oiio.ImageBuf:
            #     return self.img
            # else:
            #     self.img = self.NumpyArrayToImageBuf()
            #     return self.img

        else:
            raise TypeError("Not a valid datatype!")

    def NumpyArrayToImageBuf(self):
        """ Converts a np.ndarray to an OIIO ImageBuf image.
        :returns: ``oiio.ImageBuf`` object
        """
        height = self.img.shape[1]
        width = self.img.shape[0]
        spec = oiio.ImageSpec(width, height, 4, "float")
        buf = oiio.ImageBuf(spec)
        buf.set_pixels(oiio.ROI(), self.img)
        if buf.has_error:
            print("Error in NumpyArrayToImageBuf:", buf.geterror())
        return buf

    def SetAsOpenedImage(self, path):
        """ Sets the image and opens it.
        :param path: image filepath to be opened
        """
        try:
            # Open the image as an array
            img_input = oiio.ImageInput.open(path)
            if img_input is None:
                print("[IO ERROR] ", oiio.geterror())
            image = img_input.read_image(format="float32")

            # Check image size to warn about glsl texture max limit
            if image.shape[0] > 6000 or image.shape[1] > 6000:
                print("[WARNING] GLSL texture size is set for images less than 6000x6000px")

            # Enforce RGBA
            if image.shape[2] == 3:
                self.img = cv2.cvtColor(image, cv2.COLOR_RGB2RGBA)
            else:
                self.img = image
        except FileNotFoundError as error:
            print("[IO ERROR] Could not open image! ", error)

    def SetAsImage(self, image):
        """ Sets the render image.
        :param image: ``numpy.ndarray`` or ``oiio.ImageBuf`` object
        """
        self.img = image
