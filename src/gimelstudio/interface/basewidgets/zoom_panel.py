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
#
# This file includes code that was modified from EmbroidePy
# which is licensed under the MIT License
# Copyright (c) 2018 Metallicow
# ----------------------------------------------------------------------------

import wx

from gimelstudio.interface.utils import ZMatrix


class ZoomPanel(wx.Panel):
    def __init__(self, *args, **kwds):
        self.matrix = ZMatrix()
        self.identity = ZMatrix()
        self.matrix.Reset()
        self.identity.Reset()
        self.previous_position = None
        self._Buffer = None

        kwds["style"] = kwds.get("style", 0) | wx.DEFAULT_FRAME_STYLE
        wx.Panel.__init__(self, *args, **kwds)

        self.Bind(wx.EVT_PAINT, self.OnPaint)
        self.Bind(wx.EVT_ERASE_BACKGROUND, lambda x: None)
        self.Bind(wx.EVT_MOTION, self.OnMouseMove)
        self.Bind(wx.EVT_MOUSEWHEEL, self.OnMousewheel)
        self.Bind(wx.EVT_MIDDLE_DOWN, self.OnMouseMiddleDown)
        self.Bind(wx.EVT_MIDDLE_UP, self.OnMouseMiddleUp)
        self.Bind(wx.EVT_SIZE, self.OnSize)

    def OnPaint(self, event):
        dc = wx.BufferedPaintDC(self, self._Buffer)

    def OnSize(self, event):
        size = self.GetClientSize()

        # Make sure size is at least 1px to avoid
        # strange "invalid bitmap size" errors.
        if size[0] < 1:
            size = (10, 10)
        self._Buffer = wx.Bitmap(*size)
        self.UpdateDrawing()

    def UpdateDrawing(self):
        dc = wx.MemoryDC()
        dc.SelectObject(self._Buffer)
        self.OnDrawBackground(dc)
        dc.SetTransformMatrix(self.matrix)
        self.OnDrawScene(dc)
        dc.SetTransformMatrix(self.identity)
        self.OnDrawInterface(dc)
        del dc  # need to get rid of the MemoryDC before Update() is called.
        self.Refresh()
        self.Update()

    def OnDrawBackground(self, dc):
        pass

    def OnDrawScene(self, dc):
        pass

    def OnDrawInterface(self, dc):
        pass

    def SceneMatrixReset(self):
        self.matrix.Reset()

    def ScenePostScale(self, sx, sy=None, ax=0, ay=0):
        self.matrix.PostScale(sx, sy, ax, ay)

    def ScenePostPan(self, px, py):
        self.matrix.PostTranslate(px, py)

    def ScenePostRotate(self, angle, rx=0, ry=0):
        self.matrix.PostRotate(angle, rx, ry)

    def ScenePreScale(self, sx, sy=None, ax=0, ay=0):
        self.matrix.PreScale(sx, sy, ax, ay)

    def ScenePrePan(self, px, py):
        self.matrix.PreTranslate(px, py)

    def ScenePreRotate(self, angle, rx=0, ry=0):
        self.matrix.PreRotate(angle, rx, ry)

    def GetScaleX(self):
        return self.matrix.GetScaleX()

    def GetScaleY(self):
        return self.matrix.GetScaleY()

    def GetSkewX(self):
        return self.matrix.GetSkewX()

    def GetSkewY(self):
        return self.matrix.GetSkewY()

    def GetTranslateX(self):
        return self.matrix.GetTranslateX()

    def GetTranslateY(self):
        return self.matrix.GetTranslateY()

    def OnMousewheel(self, event):
        rotation = event.GetWheelRotation()
        mouse = event.GetPosition()
        if rotation > 1:
            self.ScenePostScale(1.1, 1.1, mouse[0], mouse[1])
        elif rotation < -1:
            self.ScenePostScale(0.9, 0.9, mouse[0], mouse[1])
        self.UpdateDrawing()

    def OnMouseMiddleDown(self, event):
        self.previous_position = event.GetPosition()
        self.SetCursor(wx.Cursor(wx.CURSOR_SIZING))

    def OnMouseMiddleUp(self, event):
        self.previous_position = None
        self.SetCursor(wx.Cursor(wx.CURSOR_ARROW))

    def OnMouseMove(self, event):
        if self.previous_position is None:
            return
        scene_position = event.GetPosition()
        previous_scene_position = self.previous_position
        dx = (scene_position[0] - previous_scene_position[0])
        dy = (scene_position[1] - previous_scene_position[1])
        self.ScenePostPan(dx, dy)
        self.UpdateDrawing()
        self.previous_position = scene_position

    def FocusPositionScene(self, scene_point):
        window_width, window_height = self.ClientSize
        scale_x = self.GetScaleX()
        scale_y = self.GetScaleY()
        self.SceneMatrixReset()
        self.ScenePostPan(-scene_point[0], -scene_point[1])
        self.ScenePostScale(scale_x, scale_y)
        self.ScenePostPan(window_width / 2.0, window_height / 2.0)

    def FocusViewportScene(self, new_scene_viewport, buffer=0, lock=True):
        window_width, window_height = self.ClientSize
        left = new_scene_viewport[0]
        top = new_scene_viewport[1]
        right = new_scene_viewport[2]
        bottom = new_scene_viewport[3]
        viewport_width = right - left
        viewport_height = bottom - top

        left -= viewport_width * buffer
        right += viewport_width * buffer
        top -= viewport_height * buffer
        bottom += viewport_height * buffer

        if right == left:
            scale_x = 100
        else:
            scale_x = window_width / float(right - left)
        if bottom == top:
            scale_y = 100
        else:
            scale_y = window_height / float(bottom - top)

        cx = ((right + left) / 2)
        cy = ((top + bottom) / 2)
        self.matrix.Reset()
        self.matrix.PostTranslate(-cx, -cy)
        if lock:
            scale = min(scale_x, scale_y)
            if scale != 0:
                self.matrix.PostScale(scale)
        else:
            if scale_x != 0 and scale_y != 0:
                self.matrix.PostScale(scale_x, scale_y)
        self.matrix.PostTranslate(window_width / 2.0, window_height / 2.0)

    def ConvertSceneToWindow(self, position):
        return self.matrix.TransformPoint([position[0], position[1]])

    def ConvertWindowToScene(self, position):
        return self.matrix.InverseTransformPoint([position[0], position[1]])
