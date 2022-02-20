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

import cv2
import numpy as np
try:
    import OpenImageIO as oiio
except ImportError:
    print("OpenImageIO is required!")


class Image(object):
    def __init__(self, size=(20, 20)):
        self.img = np.zeros((size[0], size[1], 4), dtype=np.float32)

    def GetImage(self):
        """ Returns the image
        :returns: ``numpy.ndarray``
        """
        return self.img

    def SetAsImage(self, image):
        """ Sets the render image.
        :param image: ``numpy.ndarray``
        """
        self.img = image

    def SetAsOpenedImage(self, path):
        """ Sets the image and opens it.
        :param path: image filepath to be opened
        """
        try:
            # Open the image as an array
            # img_input = oiio.ImageInput.open(path)
            # if img_input is None:
            #     print("[IO ERROR] ", oiio.geterror())
            # image = img_input.read_image(format="float32")

            img_input = cv2.imread(path)
            image = cv2.cvtColor(img_input, cv2.COLOR_BGRA2RGBA).astype("float32")

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
