# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2023 by the Gimel Studio project contributors
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


def ComputeMenuPosAlignedLeft(menu, btn):
    """ Given flatmenu and button objects, computes the positioning
    of the dropdown menu.

    :returns: wx.Point
    """
    y = btn.GetSize()[1] + btn.GetScreenPosition()[1] + 6
    x = btn.GetScreenPosition()[0] - menu.GetMenuWidth() + btn.GetSize()[1]
    return wx.Point(x, y)
