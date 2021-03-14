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
import wx.adv

from PIL import Image

from .utils import ConvertImageToWx
from .basewidgets import ZoomPanel
from gimelstudio.datafiles.icons import ICON_BRUSH_CHECKERBOARD


class ImageViewport(ZoomPanel):
    def __init__(self, parent):
        ZoomPanel.__init__(self, parent)

        self._parent = parent
        self._zoom = 100
        self._renderTime = 0.00
        self._rendering = False

        img = Image.new('RGBA', (500, 500), (0, 0, 0, 120))

        self._viewportImage = ConvertImageToWx(img)

        self.Bind(wx.EVT_KEY_DOWN, self.OnKeyEvent)

    def OnDrawBackground(self, dc):
        dc.SetBackground(wx.Brush('#434343'))
        dc.Clear()

    def OnDrawScene(self, dc):
        image = self._viewportImage
        x = (self.Size[0] - image.Width) / 2.0
        y = (self.Size[1] - image.Height) / 2.0

        # draw checkerboard bg
        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.SetBrush(wx.Brush(ICON_BRUSH_CHECKERBOARD.GetBitmap()))
        dc.DrawRectangle(wx.Rect(x, y, image.Width, image.Height))

        # Draw image
        dc.DrawBitmap(image, x, y, useMask=False)

    def OnDrawInterface(self, dc):
        gc = wx.GraphicsContext.Create(dc)

        self.UpdateZoomValue()
        text = self.CreateInfoText(self._renderTime,
                                   self._zoom, self._rendering)

        fnt = self._parent.GetFont().Bold()
        gc.SetFont(fnt, wx.Colour('#ccc'))
        gc.DrawText(text, 10, self.Size[1]-30)

    def OnKeyEvent(self, event):
        code = event.GetKeyCode()
        mouse = wx.Point(self.Size[0] / 2, self.Size[1] / 2)

        # plus (+)
        if code == wx.WXK_NUMPAD_ADD:
            self.ScenePostScale(1.1, 1.1, mouse[0], mouse[1])
        # minus (-)
        elif code == wx.WXK_NUMPAD_SUBTRACT:
            self.ScenePostScale(0.9, 0.9, mouse[0], mouse[1])

        self.UpdateDrawing()

    def CreateInfoText(self, render_time, zoom, rendering=False):
        if rendering is False:
            info = "Zoom {0}%".format(zoom)
        return info

    def UpdateInfoText(self, rendering=False):
        self._rendering = rendering
        self.UpdateDrawing()

    def UpdateZoomValue(self):
        self._zoom = round(self.GetScaleX() * 100)

    def UpdateViewerImage(self, image, render_time):
        """ Update the Image Viewport. This refreshes everything
        in the Viewport.

        :param image: wx.Bitmap
        :param float render_time: float value of the image's render time
        """
        self._renderTime = render_time
        self._viewportImage = image
        self.UpdateDrawing()
