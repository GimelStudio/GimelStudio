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
from .interface import ImageViewportPanel, NodePropertiesPanel, NodeGraphPanel
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
        view_menu = flatmenu.FlatMenu()
        render_menu = flatmenu.FlatMenu()
        window_menu = flatmenu.FlatMenu()
        help_menu = flatmenu.FlatMenu()

        # File
        self.openprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="Open Project\tCtrl+O",
            helpString="Open and load a Gimel Studio project file",
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_NODEPROPERTIES_PANEL.GetBitmap()
        )

        self.saveprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="Save Project...\tCtrl+S",
            helpString="Save the current project file",
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.saveprojectfileas_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="Save Project As...\tCtrl+Shift+S",
            helpString="Save the current project as a Gimel Studio project",
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self._menubar.AddSeparator()

        self.exportasimage_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="Export Image As...\tShift+E",
            helpString="Export rendered composite image to a file",
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self._menubar.AddSeparator()

        self.quit_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="Quit\tShift+Q",
            helpString="Quit Gimel Studio",
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
        self._menubar.Append(file_menu, "File")
        self._menubar.Append(view_menu, "View")
        self._menubar.Append(render_menu, "Render")
        self._menubar.Append(window_menu, "Window")
        self._menubar.Append(help_menu, "Help")

        # Add menubar to main sizer
        self.mainSizer.Add(self._menubar, 0, wx.EXPAND)

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
            self.nodegraph_pnl,
            aui.AuiPaneInfo()
            .Name('nodegraph')
            .CaptionVisible(False)
            .Bottom()
            .CloseButton(visible=False)
            .BestSize(750, 800)
            )
        self._mgr.AddPane(
            self.prop_pnl,
            aui.AuiPaneInfo()
            .Name('nodeproperties')
            .Right()
            .CaptionVisible(False)
            .CloseButton(visible=False)
            .BestSize(750, 500)
            )
        self._mgr.AddPane(
            self.imageviewport_pnl,
            aui.AuiPaneInfo()
            .Name('imageviewport')
            .CaptionVisible(False)
            .Center()
            .CloseButton(visible=False)
            .BestSize(750, 500)
            )

        # self._mgr.AddPane(
        #     layer_pnl,
        #     aui.AuiPaneInfo()
        #     .Name('layers')
        #     .Caption('Layers')
        #     .Left()
        #     .CloseButton(visible=False)
        #     .Icon(ICON_LAYERS.GetBitmap())
        #     .BestSize(750, 500)
        #     )

        # Maximize the window & tell the AUI window
        # manager to "commit" all the changes just made, etc
        self.Maximize()
        self._menubar.PositionAUI(self._mgr)
        self._mgr.Update()
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
