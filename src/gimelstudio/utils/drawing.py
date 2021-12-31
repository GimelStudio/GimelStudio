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

import wx


def DrawCheckerBoard(dc, rect, checkcolor, box=1):
    """ Draws a checkerboard pattern on a wx.DC. Useful for
    Alpha channel backgrounds, etc.

    NOTE: Seems to only work with the wx.DC
    """
    y = rect.y
    dc.SetPen(wx.Pen(checkcolor))
    dc.SetBrush(wx.Brush(checkcolor))
    dc.SetClippingRegion(rect)

    while y < rect.height:
        x = box * ((y // box) % 2) + 2
        while x < rect.width:
            dc.DrawRectangle(x, y, box, box)
            x += box * 2
        y += box
