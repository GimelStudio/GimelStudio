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


def ConvertImageToWx(image):
    """ Converts the given ``numpy.ndarray`` object into a
    ``wx.Bitmap`` with RGBA.
    :param image: ``numpy.ndarray`` to convert
    :returns: ``wx.Bitmap``
    """
    height, width = image.shape[:2]

    if image.shape[2] == 3:
        image_rgba = cv2.cvtColor(image, cv2.COLOR_RGB2RGBA)
    else:
        image_rgba = image

    return wx.Bitmap.FromBufferRGBA(width, height, image_rgba.astype("uint8"))
