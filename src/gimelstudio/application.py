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

import webbrowser

import wx
import wx.lib.agw.aui as aui
import wx.lib.agw.flatmenu as flatmenu

from gimelstudio.constants import (APP_FULL_TITLE, AREA_TOPBAR_COLOR, DARK_COLOR, 
                                   PROJECT_FILE_WILDCARD)
from gimelstudio.utils import ConvertImageToWx
from .interface import artproviders
from .datafiles.icons import (ICON_BUG, ICON_CAMERA, ICON_CLOSE, ICON_COPY, ICON_DOCS, 
                              ICON_EXPORT, ICON_FOLDER, ICON_GIMELSTUDIO_ICO, ICON_SAVE, 
                              ICON_INFO, ICON_NEW_FILE, ICON_SETTINGS, ICON_WEBSITE)
from .core import (Renderer, GLSLRenderer, ProjectFileIO, NODE_REGISTRY)
from .interface import (ImageViewportPanel, NodePropertiesPanel,
                        NodeGraphPanel, StatusBar, PreferencesDialog,
                        ExportImageHandler, NodeGraphDropTarget,
                        AboutDialog, ShowNotImplementedDialog)
from .node_importer import *


class AUIManager(aui.AuiManager):
    def __init__(self, managed_window):
        aui.AuiManager.__init__(self)
        self.SetManagedWindow(managed_window)


class ApplicationFrame(wx.Frame):
    def __init__(self, app_config=None):
        wx.Frame.__init__(self, None, title=APP_FULL_TITLE, size=(1000, 800))

        # Application configuration project file IO
        self.appconfig = app_config

        # Project file IO
        self.projectfileio = ProjectFileIO(app_config)

        # Initilize renderers and node registry
        self.renderer = Renderer(self)
        self.glsl_renderer = GLSLRenderer()
        self.registry = NODE_REGISTRY

        # Set the program icon
        self.SetIcon(ICON_GIMELSTUDIO_ICO.GetIcon())

        # Create main sizer
        self.main_sizer = wx.BoxSizer(wx.VERTICAL)

        # Create the menubar
        self.menubar = flatmenu.FlatMenuBar(self, wx.ID_ANY, 40, 7, options=0)

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
        separator = flatmenu.FlatMenuItem(file_menu, id=wx.ID_SEPARATOR,
                                          kind=wx.ITEM_SEPARATOR)

        # File
        self.newprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("New Project"), "\tCtrl+N"),
            helpString=_("Create a new Gimel Studio project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_NEW_FILE.GetBitmap()
        )

        self.openprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Open Project"), "\tCtrl+O"),
            helpString=_("Open and load a Gimel Studio project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_FOLDER.GetBitmap()
        )

        self.saveprojectfile_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Save Project…"), "\tCtrl+S"),
            helpString=_("Save the current project file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_SAVE.GetBitmap()
        )

        self.saveprojectfileas_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Save Project As…"), "\tCtrl+Shift+S"),
            helpString=_("Save the current project as a Gimel Studio project"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_SAVE.GetBitmap()
        )

        self.exportasimage_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Export Image As…"), "\tShift+E"),
            helpString=_("Export rendered image to a file"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_EXPORT.GetBitmap()
        )

        self.quit_menuitem = flatmenu.FlatMenuItem(
            file_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Quit"), "\tShift+Q"),
            helpString=_("Quit Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_CLOSE.GetBitmap()
        )

        # Edit
        self.copytoclipboard_menuitem = flatmenu.FlatMenuItem(
            edit_menu,
            id=wx.ID_ANY,
            label=_("Copy Image to Clipboard"),
            helpString=_("Copy the current rendered image to the system clipboard"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_COPY.GetBitmap()
        )

        # self.preferences_menuitem = flatmenu.FlatMenuItem(
        #     edit_menu,
        #     id=wx.ID_ANY,
        #     label=_("Preferences"),
        #     helpString=_("Edit preferences for Gimel Studio"),
        #     kind=wx.ITEM_NORMAL,
        #     subMenu=None,
        #     normalBmp=ICON_SETTINGS.GetBitmap()
        # )

        # View
        self.showimageviewport_menuitem = flatmenu.FlatMenuItem(
            edit_menu,
            id=wx.ID_ANY,
            label=_("Show Image Viewport"),
            helpString=_("Show the Image Viewport panel"),
            kind=wx.ITEM_CHECK,
            subMenu=None
        )
        self.showstatusbar_menuitem = flatmenu.FlatMenuItem(
            edit_menu,
            id=wx.ID_ANY,
            label=_("Show Statusbar"),
            helpString=_("Show the statusbar"),
            kind=wx.ITEM_CHECK,
            subMenu=None
        )

        # Render
        self.toggleautorender_menuitem = flatmenu.FlatMenuItem(
            render_menu,
            id=wx.ID_ANY,
            label=_("Auto Render Image"),
            helpString=_("Enable auto rendering after editing node properties, connections, etc"),
            kind=wx.ITEM_CHECK,
            subMenu=None
        )

        self.renderimage_menuitem = flatmenu.FlatMenuItem(
            render_menu,
            id=wx.ID_ANY,
            label="{0}{1}".format(_("Render Image"), "\tF12"),
            helpString=_("Force an immediate, updated render of the current node graph"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_CAMERA.GetBitmap()
        )

        # Window
        self.togglewindowfullscreen_menuitem = flatmenu.FlatMenuItem(
            window_menu,
            id=wx.ID_ANY,
            label=_("Window Fullscreen"),
            helpString=_("Set the window to be fullscreen"),
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
            subMenu=None,
            normalBmp=ICON_DOCS.GetBitmap()
        )

        self.visitwebsite_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("Visit Website"),
            helpString=_("Open the offical Gimel Studio website in your browser"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_WEBSITE.GetBitmap()
        )

        self.reportabug_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("Report a Bug"),
            helpString=_("Report a bug in Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_BUG.GetBitmap()
        )

        self.about_menuitem = flatmenu.FlatMenuItem(
            help_menu,
            id=wx.ID_ANY,
            label=_("About Gimel Studio"),
            helpString=_("Information about Gimel Studio"),
            kind=wx.ITEM_NORMAL,
            subMenu=None,
            normalBmp=ICON_INFO.GetBitmap()
        )

        # Set defaults
        self.showimageviewport_menuitem.Check(True)
        self.showstatusbar_menuitem.Check(False)
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
        #edit_menu.AppendItem(separator)
        #edit_menu.AppendItem(self.preferences_menuitem)

        view_menu.AppendItem(self.showimageviewport_menuitem)
        # view_menu.AppendItem(self.showstatusbar_menuitem)

        render_menu.AppendItem(self.toggleautorender_menuitem)
        render_menu.AppendItem(separator)
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
        
        # Adds vertical spacing to the menubar popups
        for item in self.menubar._items:
            item.GetMenu()._marginHeight = self.menubar._margin + 18
            item.GetMenu().ResizeMenu()

        # Menu event bindings
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnNewProjectFile,
                  self.newprojectfile_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnOpenProjectFile,
                  self.openprojectfile_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnSaveProjectFile,
                  self.saveprojectfile_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnSaveProjectFileAs,
                  self.saveprojectfileas_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnExportAsImage,
                  self.exportasimage_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnQuit,
                  self.quit_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnCopyImageToClipboard,
                  self.copytoclipboard_menuitem)
        # self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
        #           self.OnPreferencesDialog,
        #           self.preferences_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnToggleImageViewport,
                  self.showimageviewport_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnToggleStatusbar,
                  self.showstatusbar_menuitem)

        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnToggleAutoRender,
                  self.toggleautorender_menuitem)
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnRender,
                  self.renderimage_menuitem)

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
        self.Bind(flatmenu.EVT_FLAT_MENU_SELECTED,
                  self.OnAboutDialog,
                  self.about_menuitem)

        # Add menubar to main sizer
        self.main_sizer.Add(self.menubar, 0, wx.EXPAND)

        # Create the statusbar
        self.statusbar = StatusBar(self)
        #self.SetStatusBar(self.statusbar)
        self.statusbar.Hide()

        # Window manager
        self.mgr = AUIManager(self)
        self.mgr.SetArtProvider(artproviders.UIDockArt())
        art = self.mgr.GetArtProvider()
        extra_flags = aui.AUI_MGR_LIVE_RESIZE | aui.AUI_MGR_ALLOW_ACTIVE_PANE
        self.mgr.SetAGWFlags(self.mgr.GetAGWFlags() ^ extra_flags)

        art.SetMetric(aui.AUI_DOCKART_CAPTION_SIZE, 29)
        art.SetMetric(aui.AUI_DOCKART_GRIPPER_SIZE, 3)
        art.SetMetric(aui.AUI_DOCKART_SASH_SIZE, 6)
        art.SetMetric(aui.AUI_DOCKART_PANE_BORDER_SIZE, 0)
        art.SetMetric(aui.AUI_DOCKART_GRADIENT_TYPE, aui.AUI_GRADIENT_NONE)
        art.SetColour(aui.AUI_DOCKART_INACTIVE_CAPTION_COLOUR, wx.Colour(AREA_TOPBAR_COLOR))
        art.SetColour(aui.AUI_DOCKART_ACTIVE_CAPTION_COLOUR, wx.Colour(AREA_TOPBAR_COLOR))
        art.SetColour(aui.AUI_DOCKART_INACTIVE_CAPTION_TEXT_COLOUR, wx.Colour("#fff"))
        art.SetColour(aui.AUI_DOCKART_SASH_COLOUR, wx.Colour(DARK_COLOR))

        # Setup the main panels
        self.prop_pnl = NodePropertiesPanel(self,
                                            idname="PROPERTIES_PNL",
                                            menu_item=None,
                                            size=(360, 500))
        self.mgr.AddPane(self.prop_pnl,
                          aui.AuiPaneInfo()
                          .Name("PROPERTIES_PNL")
                          .Right().Layer(2)
                          .CaptionVisible(False)
                          .CloseButton(visible=False)
                          .BestSize(360, 500))

        self.nodegraph_pnl = NodeGraphPanel(self, registry=self.registry, size=(100, 100))
        self.nodegraph_pnl.SetDropTarget(NodeGraphDropTarget(self.nodegraph_pnl))
        self.mgr.AddPane(self.nodegraph_pnl,
                          aui.AuiPaneInfo()
                          .Name("NODE_EDITOR")
                          .CaptionVisible(False)
                          .CenterPane()
                          .CloseButton(visible=False)
                          .BestSize(500, 300))

        self.imageviewport_pnl = ImageViewportPanel(self,
                                                    idname="IMAGE_VIEWPORT",
                                                    menu_item=self.showimageviewport_menuitem)
        self.mgr.AddPane(self.imageviewport_pnl,
                          aui.AuiPaneInfo()
                          .Name("IMAGE_VIEWPORT")
                          .CaptionVisible(False)
                          .Top()
                          .MinSize((-1, 400))
                          .CloseButton(visible=False)
                          .BestSize((500, 1700)))

        # Get the default proportions correct
        self.mgr.GetPane("PROPERTIES_PNL").dock_proportion = 5

        # Maximize the window & tell the AUI window
        # manager to "commit" all the changes just made, etc
        self.Maximize()
        self.menubar.PositionAUI(self.mgr)
        self.mgr.Update()
        # self.statusbar.UpdateStatusBar()
        # self.statusbar.Refresh()
        self.menubar.Refresh()

        # Set the output node for the renderer
        self.renderer.SetOutputNode(self.NodeGraph.GetOutputNode())

    def Render(self):
        image = self.renderer.Render()
        render = image.GetImage()
        self.imageviewport_pnl.UpdateViewerImage(render, 0)
        self.SetAppTitle(False)
        return render

    @property
    def NodeGraph(self):
        return self.nodegraph_pnl.NodeGraph

    @property
    def ImageViewport(self):
        return self.imageviewport_pnl

    @property
    def AppConfig(self):
        return self.appconfig

    def SetAppTitle(self, is_saved):
        file_path = self.projectfileio.GetFilePath()
        if file_path != "":
            file_path = "({})".format(file_path)
        if is_saved is not True:
            suffix = "*"
        else:
            suffix = ""
        self.SetTitle("{0}{1} {2}".format(APP_FULL_TITLE, suffix, file_path))

    def OnNewProjectFile(self, event):
        ShowNotImplementedDialog()

    def OnOpenProjectFile(self, event):
        dlg = wx.FileDialog(self, message=_("Open project file…"),
                            wildcard=PROJECT_FILE_WILDCARD, style=wx.FD_OPEN)

        if dlg.ShowModal() == wx.ID_OK:
            file_path = dlg.GetPath()
            self.projectfileio.OpenFile(file_path)
            self.projectfileio.CreateNodesFromData(self.NodeGraph)
            self.SetAppTitle(True)
        dlg.Destroy()

    def OnSaveProjectFile(self, event):
        self.projectfileio.SaveNodesData(self.NodeGraph.GetNodes())
        self.projectfileio.SaveFile()
        self.SetAppTitle(True)

    def OnSaveProjectFileAs(self, event):
        dlg = wx.FileDialog(self, message=_("Save project file as…"),
                            defaultFile="untitled.gimel",
                            wildcard=PROJECT_FILE_WILDCARD, 
                            style=wx.FD_SAVE | wx.FD_OVERWRITE_PROMPT)

        if dlg.ShowModal() == wx.ID_OK:
            file_path = dlg.GetPath()
            self.projectfileio.SaveNodesData(self.NodeGraph.GetNodes())
            self.projectfileio.SaveFileAs(file_path)
            self.SetAppTitle(True)
        dlg.Destroy()

    def OnExportAsImage(self, event):
        image = self.renderer.GetRender()

        try:
            export_handler = ExportImageHandler(self, image.GetImage())
            export_handler.RunExport()
        except AttributeError:
            dlg = wx.MessageDialog(None,
                _("Please render an image before attempting to export!"),
                _("No Image to Export!"), style=wx.ICON_EXCLAMATION)
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
            self.mgr.UnInit()
            del self.mgr
            # Finally close the window
            self.Destroy()
        else:
            event.Skip()

    def OnCopyImageToClipboard(self, event):
        if wx.TheClipboard.Open():
            try:
                image = self.renderer.GetRender()
                image = image.GetImage()
                image = ConvertImageToWx(image)
                image = wx.BitmapDataObject(image)
                wx.TheClipboard.SetData(image)
                wx.TheClipboard.Close()
            except AttributeError:
                dlg = wx.MessageDialog(None,
                    _("Please render an image before attempting to copy it!"),
                    _("No Image to copy!"), style=wx.ICON_EXCLAMATION)
                dlg.ShowModal()

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

    def OnToggleImageViewport(self, event):
        if self.showimageviewport_menuitem.IsChecked() is False:
            self.imageviewport_pnl.HidePanel()
        else:
            self.imageviewport_pnl.ShowPanel()

    def OnToggleStatusbar(self, event):
        # if self.showstatusbar_menuitem.IsChecked() is False:
        #     self.statusbar.Hide()
        # else:
        #     self.statusbar.Show()
        self.Layout()

    def OnToggleAutoRender(self, event):
        ShowNotImplementedDialog()

    def OnRender(self, event):
        self.Render()

    def OnToggleFullscreen(self, event):
        style = wx.FULLSCREEN_NOCAPTION | wx.FULLSCREEN_NOBORDER
        if self.togglewindowfullscreen_menuitem.IsChecked() is False:
            self.ShowFullScreen(False)
        else:
            self.ShowFullScreen(True, style=style)

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

    def OnAboutDialog(self, event):
        dlg = AboutDialog(self)
        dlg.Show()
