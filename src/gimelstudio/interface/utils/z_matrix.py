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
# This file is code originally from EmbroidePy
# which is licensed under the MIT License
# Copyright (c) 2018 Metallicow
# ----------------------------------------------------------------------------

from wx import AffineMatrix2D


class ZMatrix(AffineMatrix2D):
    def __init__(self, *args, **kwds):
        AffineMatrix2D.__init__(self)

    def Reset(self):
        AffineMatrix2D.__init__(self)

    def PostScale(self, sx, sy=None, ax=0, ay=0):
        self.Invert()
        if sy is None:
            sy = sx
        if ax == 0 and ay == 0:
            self.Scale(1.0 / sx, 1.0 / sy)
        else:
            self.Translate(ax, ay)
            self.Scale(1.0 / sx, 1.0 / sy)
            self.Translate(-ax, -ay)
        self.Invert()

    def PostTranslate(self, px, py):
        self.Invert()
        self.Translate(-px, -py)
        self.Invert()

    def PostRotate(self, radians, rx=0, ry=0):
        self.Invert()
        if rx == 0 and ry == 0:
            self.Rotate(-radians)
        else:
            self.Translate(rx, ry)
            self.Rotate(-radians)
            self.Translate(-rx, -ry)
        self.Invert()

    def PreScale(self, sx, sy=None, ax=0, ay=0):
        if sy is None:
            sy = sx
        if ax == 0 and ay == 0:
            self.Scale(sx, sy)
        else:
            self.Translate(ax, ay)
            self.Scale(sx, sy)
            self.Translate(-ax, -ay)

    def PreTranslate(self, px, py):
        self.Translate(px, py)

    def PreRotate(self, radians, rx=0, ry=0):
        if rx == 0 and ry == 0:
            self.Rotate(radians)
        else:
            self.Translate(rx, ry)
            self.Rotate(radians)
            self.Translate(-rx, -ry)

    def GetScaleX(self):
        return self.Get()[0].m_11

    def GetScaleY(self):
        return self.Get()[0].m_22

    def GetSkewX(self):
        return self.Get()[0].m_12

    def GetSkewY(self):
        return self.Get()[0].m_21

    def GetTranslateX(self):
        return self.Get()[1].x

    def GetTranslateY(self):
        return self.Get()[1].y

    def InverseTransformPoint(self, position):
        self.Invert()
        converted_point = self.TransformPoint(position)
        self.Invert()
        return converted_point
