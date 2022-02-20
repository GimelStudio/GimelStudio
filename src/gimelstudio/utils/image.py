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

import wx
import cv2
import math
import numpy as np


def ConvertImageToWx(cv2_image):
    height, width = cv2_image.shape[:2]
    cv2_image_rgb = cv2.normalize(src=cv2_image, dst=None, alpha=0, beta=255, norm_type=cv2.NORM_MINMAX, dtype=cv2.CV_32F)
    return wx.Bitmap.FromBufferRGBA(width, height, cv2_image_rgb.astype(np.uint8))


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
