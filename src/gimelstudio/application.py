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

import time
import webbrowser

import wx
import wx.lib.agw.aui as aui
import wx.lib.agw.flatmenu as flatmenu

from .node_importer import *
import gimelstudio.constants as appconst
from .interface import artproviders
from .datafiles.icons import ICON_GIMELSTUDIO_ICO
from .core import (Renderer, GLSLRenderer,
                   NODE_REGISTRY)
from .interface import (ImageViewportPanel, NodePropertiesPanel,
                        NodeGraphPanel, StatusBar, PreferencesDialog,
                        ExportImageHandler, NodeGraphDropTarget)


class AUIManager(aui.AuiManager):
    def __init__(self, managed_window):
        aui.AuiManager.__init__(self)
        self.SetManagedWindow(managed_window)


class ApplicationFrame(wx.Frame):
    def __init__(self, app_config=None):
        wx.Frame.__init__(self, None, title=appconst.APP_NAME, size=(1000, 800))

        # Application configuration
        self.appconfig = app_config

        # Initilize renderers and node registry
        self.renderer = Renderer(self)
        self.glsl_renderer = GLSLRenderer()
        self.registry = NODE_REGISTRY

        # Set the program icon
        self.SetIcon(ICON_GIMELSTUDIO_ICO.GetIcon())

        # Create main sizer
        self.mainSizer = wx.BoxSizer(wx.VERTICAL)

        # Create the menubar
        self.menubar = flatmenu.FlatMenuBar(self, wx.ID_ANY, 40, 6, options=0)

        # Set the dark theme
        rm = self.menubar.GetRendererManager()
        theme = rm.AddRenderer(artproviders.UIMenuBarRenderer())
        rm.SetTheme(theme)

        # Init menus
        file_menu = flatmenu.FlatMenu()
        edit_menu = flatmenu.FlatMenu()
        view_menu = flatmenu.FlatMenu()
        render_menu = flatmenu.FlatMenu()
        window_menu = flatmenu.FlatMenu()
        help_menu = flatmenu.FlatMenu()

        # Separator
        separator = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_SEPARATOR,
            kind=wx.ITEM_SEPARATOR,
        )

        # File
        self.newprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("New Project"), "\tCtrl+N"),
            helpString=_("Create a new Gimel Studio project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.openprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Open Project"), "\tCtrl+O"),
            helpString=_("Open and load a Gimel Studio project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.saveprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Save Project…"), "\tCtrl+S"),
            helpString=_("Save the current project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.saveprojectfileas_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Save Project As…"), "\tCtrl+Shift+S"),
            helpString=_("Save the current project as a Gimel Studio project"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.exportasimage_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Export Image As…"), "\tShift+E"),
            helpString=_("Export rendered image to a file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.quit_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Quit"), "\tShift+Q"),
            helpString=_("Quit Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        # Edit
        self.copytoclipboard_menuitem = flatmenu.FlatMenuItem(
            edit_menu,
            id=wx.ID_ANY,
            label=_("Copy Image to Clipboard"),
            helpString=_("Copy the current rendered image to the system clipboard"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.preferences_menuitem = flatmenu.FlatMenuItem(
            edit_menu,
            id=wx.ID_ANY,
            label=_("Preferences"),
            helpString=_("Edit preferences for Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        # View
        self.showstatusbar_menuitem = flatmenu.FlatMenuItem(
            edit_menu,
            id=wx.ID_ANY,
            label=_("Toggle Statusbar"),
            helpString=_("Toggle showing the statusbar"),
            kind=wx.ITEM_CHECK,
            subMenu=None
        )

        # Render
        self.toggleautorender_menuitem = flatmenu.FlatMenuItem(
            render_menu,
            id=wx.ID_ANY,
            label=_("Auto Render"),
            helpString=_("Toggle auto rendering after editing node properties, connections, etc"),
            kind=wx.ITEM_CHECK,
            subMenu=None
        )

        self.renderimage_menuitem = flatmenu.FlatMenuItem(
            render_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Render Image"), "\tF12"),
            helpString=_("Force an immediate, updated render of the current node graph"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        # Window
        self.togglewindowfullscreen_menuitem = flatmenu.FlatMenuItem(
            window_menu,
            id=wx.ID_ANY,
            label=_("Toggle Window Fullscreen"),
            helpString=_("Toggle the window to be fullscreen"),
            kind=wx.ITEM_CHECK,
            subMenu=None
        )

        self.maximizewindow_menuitem = flatmenu.FlatMenuItem(
            window_menu,
            id=wx.ID_ANY,
            label=_("Maximize Window"),
            helpString=_("Maximize the window size"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        # Help
        self.onlinemanual_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("Online Manual"),
            helpString=_("Open the online Gimel Studio manual in your browser"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.visitwebsite_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("Visit Website"),
            helpString=_("Open the offical Gimel Studio website in your browser"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.reportabug_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("Report a Bug"),
            helpString=_("Report a bug in Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        self.about_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("About Gimel Studio"),
            helpString=_("Information about Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None
        )

        # Set defaults
        self.showstatusbar_menuitem.Check(True)
        self.toggleautorender_menuitem.Check(True)

        # Append menu items to menus
        file_menu.AppendItem(self.newprojectfile_menuitem)
        file_menu.AppendItem(self.openprojectfile_menuitem)
        file_menu.AppendItem(separator)
        file_menu.AppendItem(self.saveprojectfile_menuitem)
        file_menu.AppendItem(self.saveprojectfileas_menuitem)
        file_menu.AppendItem(self.exportasimage_menuitem)
        file_menu.AppendItem(separator)
        file_menu.AppendItem(self.quit_menuitem)

        edit_menu.AppendItem(self.copytoclipboard_menuitem)
        edit_menu.AppendItem(self.preferences_menuitem)

        view_menu.AppendItem(self.showstatusbar_menuitem)

        render_menu.AppendItem(self.toggleautorender_menuitem)
        render_menu.AppendItem(self.renderimage_menuitem)

        window_menu.AppendItem(self.togglewindowfullscreen_menuitem)
        window_menu.AppendItem(self.maximizewindow_menuitem)

        help_menu.AppendItem(self.onlinemanual_menuitem)
        help_menu.AppendItem(self.visitwebsite_menuitem)
        help_menu.AppendItem(self.reportabug_menuitem)
        help_menu.AppendItem(separator)
        help_menu.AppendItem(self.about_menuitem)

        # Append menus to the menubar
        self.menubar.Append(file_menu, _("File"))
        self.menubar.Append(edit_menu, _("Edit"))
        self.menubar.Append(view_menu, _("View"))
        self.menubar.Append(render_menu, _("Render"))
        self.menubar.Append(window_menu, _("Window"))
        self.menubar.Append(help_menu, _("Help"))

        # Menu event bindings
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnExportAsImage,
                  self.exportasimage_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnQuit,
                  self.quit_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnPreferencesDialog,
                  self.preferences_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnToggleStatusbar,
                  self.showstatusbar_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnToggleFullscreen,
                  self.togglewindowfullscreen_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnMaximizeWindow,
                  self.maximizewindow_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnOnlineManual,
                  self.onlinemanual_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnReportABug,
                  self.reportabug_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnVisitWebsite,
                  self.visitwebsite_menuitem)

        # Add menubar to main sizer
        self.mainSizer.Add(self.menubar, 0, wx.EXPAND)

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

        # Node Graph
        self.nodegraph_pnl = NodeGraphPanel(self, self.registry, size=(100, 100))
        self.nodegraph_pnl.SetDropTarget(NodeGraphDropTarget(self.nodegraph_pnl))

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
        self.menubar.PositionAUI(self._mgr)
        self._mgr.Update()
        self.statusbar.UpdateStatusBar()
        self.statusbar.Refresh()
        self.menubar.Refresh()


    def Render(self):
        start = time.time()
        image = self.renderer.Render(self.NodeGraph._nodes)
        end = time.time()
        print("Render time: ", end - start)
        self.imageviewport_pnl.UpdateViewerImage(image.Image("numpy"), 0)

    @property
    def NodeGraph(self):
        return self.nodegraph_pnl.NodeGraph

    @property
    def ImageViewport(self):
        return self.imageviewport_pnl

    @property
    def AppConfig(self):
        return self.appconfig

    def OnExportAsImage(self, event):
        image = self.renderer.GetRender()

        try:
            export_handler = ExportImageHandler(self, image.Image("oiio"))
            export_handler.RunExport()
        except AttributeError:
            dlg = wx.MessageDialog(
                None,
                "Please render an image before attempting to export!",
                "No Image to export!",
                style=wx.ICON_EXCLAMATION
            )
            dlg.ShowModal()

    def OnQuit(self, event):
        quitdialog = wx.MessageDialog(self,
                                      _("Do you really want to quit? You will lose any unsaved data."),
                                      _("Quit Gimel Studio?"),
                                      wx.YES_NO | wx.YES_DEFAULT)

        if quitdialog.ShowModal() == wx.ID_YES:
            # Save configuration settings before quit
            self.appconfig.Save()
            # Make sure to release data used by GPU render engine
            self.glsl_renderer.Release()
            # Un-int the app and window mgr
            quitdialog.Destroy()
            self._mgr.UnInit()
            del self._mgr
            self.Destroy()
        else:
            event.Skip()

    def OnPreferencesDialog(self, event):
        categories = [
                "General",
                "Interface",
                "Add-ons",
                "Nodes",
                "Templates",
                "System",
                "File Paths"
                ]
        dlg = PreferencesDialog(self, title=_("Gimel Studio Preferences"),
                                app_config=self.appconfig, categories=categories)
        dlg.Show()

    def OnToggleStatusbar(self, event):
        if self.showstatusbar_menuitem.IsChecked() is False:
            self.statusbar.Hide()
        else:
            self.statusbar.Show()
        self.Layout()

    def OnToggleFullscreen(self, event):
        if self.togglewindowfullscreen_menuitem.IsChecked() is False:
            self.ShowFullScreen(False)
        else:
            self.ShowFullScreen(True,
                                style=wx.FULLSCREEN_NOCAPTION | wx.FULLSCREEN_NOBORDER)

    def OnMaximizeWindow(self, event):
        self.Maximize()

    def OnOnlineManual(self, event):
        url = ("https://gimelstudio.readthedocs.io/en/latest/")
        webbrowser.open(url)

    def OnReportABug(self, event):
        url = ("https://github.com/GimelStudio/GimelStudio/issues/new/choose")
        webbrowser.open(url)

    def OnVisitWebsite(self, event):
        url = ("https://gimelstudio.github.io")
        webbrowser.open(url)
