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
import wx.lib.agw.aui as aui
import wx.lib.agw.flatmenu as flatmenu

from .config import AppData
from .interface import (ImageViewportPanel, NodePropertiesPanel,
                        NodeGraphPanel, StatusBar)
from .interface import artproviders
from .datafiles.icons import (ICON_NODEPROPERTIES_PANEL,
                              ICON_NODEGRAPH_PANEL, ICON_GIMELSTUDIO_ICO)
from .corenodes import OutputNode, MixNode, ImageNode, BlurNode

from .core.renderer import Renderer


class AUIManager(aui.AuiManager):
    def __init__(self, managed_window):
        aui.AuiManager.__init__(self)
        self.SetManagedWindow(managed_window)


class ApplicationFrame(wx.Frame):
    def __init__(self):
        wx.Frame.__init__(self, None, title="Gimel Studio", size=(1000, 800))

        self.appdata = AppData(self)
        self.renderer = Renderer(self)

        # Set the program icon
        self.SetIcon(ICON_GIMELSTUDIO_ICO.GetIcon())

        # Create main sizer
        self.mainSizer = wx.BoxSizer(wx.VERTICAL)

        # Create the menubar
        self._menubar = flatmenu.FlatMenuBar(self, wx.ID_ANY, 40, 6, options=0)

        # Set the dark theme
        rm = self._menubar.GetRendererManager()
        theme = rm.AddRenderer(artproviders.UIMenuBarRenderer())
        rm.SetTheme(theme)

        # Init menus
        file_menu = flatmenu.FlatMenu()
        edit_menu = flatmenu.FlatMenu()
        view_menu = flatmenu.FlatMenu()
        render_menu = flatmenu.FlatMenu()
        window_menu = flatmenu.FlatMenu()
        help_menu = flatmenu.FlatMenu()

        # File
        self.openprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Open Project"), "\tCtrl+O"),
            helpString=_("Open and load a Gimel Studio project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_NODEPROPERTIES_PANEL.GetBitmap()
        )

        self.saveprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Save Project..."), "\tCtrl+S"),
            helpString=_("Save the current project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.saveprojectfileas_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Save Project As..."), "\tCtrl+Shift+S"),
            helpString=_("Save the current project as a Gimel Studio project"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self._menubar.AddSeparator()

        self.exportasimage_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Export Image As..."), "\tShift+E"),
            helpString=_("Export rendered image to a file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self._menubar.AddSeparator()

        self.quit_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Quit"), "\tShift+Q"),
            helpString=_("Quit Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_NODEPROPERTIES_PANEL.GetBitmap()
        )

        # Append menu items to menus
        file_menu.AppendItem(self.openprojectfile_menuitem)
        file_menu.AppendItem(self.saveprojectfile_menuitem)
        file_menu.AppendItem(self.saveprojectfileas_menuitem)
        file_menu.AppendItem(self.exportasimage_menuitem)
        file_menu.AppendItem(self.quit_menuitem)

        # Append menus to the menubar
        self._menubar.Append(file_menu, _("File"))
        self._menubar.Append(edit_menu, _("Edit"))
        self._menubar.Append(view_menu, _("View"))
        self._menubar.Append(render_menu, _("Render"))
        self._menubar.Append(window_menu, _("Window"))
        self._menubar.Append(help_menu, _("Help"))

        # Add menubar to main sizer
        self.mainSizer.Add(self._menubar, 0, wx.EXPAND)

        # Create the statusbar
        self.statusbar = StatusBar(self)
        self.SetStatusBar(self.statusbar)

        # Window manager
        self._mgr = AUIManager(self)
        self._mgr.SetArtProvider(artproviders.UIDockArt())
        art = self._mgr.GetArtProvider()
        extra_flags = aui.AUI_MGR_LIVE_RESIZE | aui.AUI_MGR_ALLOW_ACTIVE_PANE
        self._mgr.SetAGWFlags(self._mgr.GetAGWFlags() ^ extra_flags)

        art.SetMetric(aui.AUI_DOCKART_CAPTION_SIZE, 29)
        art.SetMetric(aui.AUI_DOCKART_GRIPPER_SIZE, 3)
        art.SetMetric(aui.AUI_DOCKART_SASH_SIZE, 6)
        art.SetMetric(aui.AUI_DOCKART_PANE_BORDER_SIZE, 0)
        art.SetMetric(aui.AUI_DOCKART_GRADIENT_TYPE, aui.AUI_GRADIENT_NONE)
        art.SetColour(aui.AUI_DOCKART_INACTIVE_CAPTION_COLOUR, wx.Colour("#424242"))
        art.SetColour(aui.AUI_DOCKART_ACTIVE_CAPTION_COLOUR, wx.Colour("#4D4D4D"))
        art.SetColour(aui.AUI_DOCKART_INACTIVE_CAPTION_TEXT_COLOUR, wx.Colour("#fff"))
        art.SetColour(aui.AUI_DOCKART_SASH_COLOUR, wx.Colour("#232323"))

        # Panels
        self.imageviewport_pnl = ImageViewportPanel(self)
        self.prop_pnl = NodePropertiesPanel(self, size=(350, 500))

        registry = {
            'image_node': ImageNode,
            'mix_node': MixNode,
            'output_node': OutputNode,
            'blur_node': BlurNode
        }
        self.nodegraph_pnl = NodeGraphPanel(self, registry, size=(100, 100))

        # Add panes
        self._mgr.AddPane(
            self.imageviewport_pnl,
            aui.AuiPaneInfo()
            .Name('imageviewport')
            .CaptionVisible(False)
            .Top()
            .Row(0)
            .Maximize()
            .CloseButton(visible=False)
            .BestSize(500, 500)
            )
        self._mgr.AddPane(
            self.prop_pnl,
            aui.AuiPaneInfo()
            .Name('nodeproperties')
            .Top()
            .Position(1)
            .Row(0)
            .CaptionVisible(False)
            .CloseButton(visible=False)
            .BestSize(500, 500)
            )
        self._mgr.AddPane(
            self.nodegraph_pnl,
            aui.AuiPaneInfo()
            .Name('nodegraph')
            .CaptionVisible(False)
            .Center()
            .CloseButton(visible=False)
            .BestSize(500, 500)
            )

        # This sorta feels like a hack to get the default proportions correct!
        self._mgr.GetPane("nodeproperties").dock_proportion = 10
        self._mgr.GetPane("imageviewport").dock_proportion = 25

        # Maximize the window & tell the AUI window
        # manager to "commit" all the changes just made, etc
        self.Maximize()
        self._menubar.PositionAUI(self._mgr)
        self._mgr.Update()
        self.statusbar.UpdateStatusBar()
        self.statusbar.Refresh()
        self._menubar.Refresh()

    def Render(self):
        try:
            import OpenImageIO as oiio
            # import time
            # start = time.time()
            image = self.renderer.Render(self.NodeGraph._nodes)
            # end = time.time()
            # print(end - start)

            self.imageviewport_pnl.UpdateViewerImage(image.Image("numpy"), 0)
        except ImportError:
            print("""OpenImageIO is required to render image! Disabling render!""")

    @property
    def NodeGraph(self):
        return self.nodegraph_pnl.NodeGraph

    @property
    def ImageViewport(self):
        return self.imageviewport_pnl
