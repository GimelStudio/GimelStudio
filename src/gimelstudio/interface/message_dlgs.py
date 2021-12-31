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


def ShowNotImplementedDialog():
    dlg = wx.MessageDialog(None,
                           _("Sorry, that feature has not been implemented yet.\nPlease consider helping to implement this feature."),
                           _("Not yet implemented!"), style=wx.ICON_INFORMATION)
    dlg.ShowModal()
