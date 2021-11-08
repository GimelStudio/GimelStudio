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

import wx
import cv2
import math
import numpy as np


# def _ConvertImageToWx(image):
#     """ Converts the given ``numpy.ndarray`` object into a
#     ``wx.Bitmap`` with RGBA.
#     :param image: ``numpy.ndarray`` to convert
#     :returns: ``wx.Bitmap``
#     """
#     height, width = image.shape[:2]

#     image = copy.deepcopy(image)

#     if image.shape[2] == 3:
#         image_rgba = cv2.cvtColor(image, cv2.COLOR_RGB2RGBA)
#     else:
#         image_rgba = image

#     # info = np.iinfo(image.dtype) # Get the information of the incoming image type
#     # data = image.astype(np.float64) / 200#info.max # normalize the data to 0 - 1
#     # data = 255 * data # Now scale by 255
#     image = image_rgba.astype(np.uint8)

#     return wx.Bitmap.FromBufferRGBA(width, height, image)


def ConvertImageToWx(cv2_image):
    height, width = cv2_image.shape[:2]

    info = np.iinfo(cv2_image.dtype)  # Get the information of the incoming image type
    data = cv2_image.astype(np.float64) / info.max  # normalize the data to 0 - 1
    data = 255 * data  # Now scale by 255
    cv2_image = data.astype(np.uint8)

    cv2_image_rgb = cv2.cvtColor(cv2_image, cv2.COLOR_RGB2RGBA)
    return wx.Bitmap.FromBufferRGBA(width, height, cv2_image_rgb)


def ResizeKeepAspectRatio(image, size):
    """ Resizes the given image while keeping the original
    image aspect ratio.
    :param image: np.ndarray image
    :param size: tuple of the desired size for resizing the image
    :returns: np.ndarray image
    """
    width = image.shape[1]
    height = image.shape[0]

    x, y = map(math.floor, size)
    if x >= width and y >= height:
        return

    def round_aspect(number, key):
        return max(min(math.floor(number), math.ceil(number), key=key), 1)

    # preserve aspect ratio
    aspect = width / height
    if x / y >= aspect:
        x = round_aspect(y * aspect, key=lambda n: abs(aspect - n / y))
    else:
        y = round_aspect(
            x / aspect, key=lambda n: 0 if n == 0 else abs(aspect - x / n)
        )
    size = (x, y)

    resized_img = cv2.resize(image, size)
    return resized_img
