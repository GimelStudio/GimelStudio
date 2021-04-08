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
# This file includes code from wx.lib.agw and the wxPython demo
# ----------------------------------------------------------------------------

import wx
import wx.lib.agw.aui as aui


class UITabArt(object):
    """ A custom implementation of a tab art. """

    def __init__(self):
        """ Default class constructor. """

        self._normal_font = wx.SystemSettings.GetFont(wx.SYS_DEFAULT_GUI_FONT)
        self._selected_font = wx.SystemSettings.GetFont(wx.SYS_DEFAULT_GUI_FONT)
        self._selected_font.SetWeight(wx.FONTWEIGHT_BOLD)
        self._measuring_font = self._selected_font

        self._agwFlags = 0
        self._fixed_tab_width = 300

        base_colour = wx.Colour("#232323")

        background_colour = base_colour
        normaltab_colour = wx.Colour("#303030")
        selectedtab_colour = wx.Colour("#424242")

        self._bkbrush = wx.Brush(background_colour)
        self._normal_bkbrush = wx.Brush(normaltab_colour)
        self._normal_bkpen = wx.Pen(wx.Colour(wx.TRANSPARENT))
        self._selected_bkbrush = wx.Brush(selectedtab_colour)
        self._selected_bkpen = wx.Pen(wx.Colour(wx.TRANSPARENT))

        self._active_close_bmp = aui.BitmapFromBits(aui.nb_close_bits, 16, 16, wx.BLACK)
        self._disabled_close_bmp = aui.BitmapFromBits(aui.nb_close_bits, 16, 16, wx.Colour(128, 128, 128))

        self._active_left_bmp = aui.BitmapFromBits(aui.nb_left_bits, 16, 16, wx.BLACK)
        self._disabled_left_bmp = aui.BitmapFromBits(aui.nb_left_bits, 16, 16, wx.Colour(128, 128, 128))

        self._active_right_bmp = aui.BitmapFromBits(aui.nb_right_bits, 16, 16, wx.BLACK)
        self._disabled_right_bmp = aui.BitmapFromBits(aui.nb_right_bits, 16, 16, wx.Colour(128, 128, 128))

        self._active_windowlist_bmp = aui.BitmapFromBits(aui.nb_list_bits, 16, 16, wx.BLACK)
        self._disabled_windowlist_bmp = aui.BitmapFromBits(aui.nb_list_bits, 16, 16, wx.Colour(128, 128, 128))


    def Clone(self):
        """ Clones the art object. """

        art = type(self)()
        art.SetNormalFont(self.GetNormalFont())
        art.SetSelectedFont(self.GetSelectedFont())
        art.SetMeasuringFont(self.GetMeasuringFont())

        art = aui.CopyAttributes(art, self)
        return art


    def SetAGWFlags(self, agwFlags):
        """
        Sets the tab art flags.

        :param integer `agwFlags`: a combination of the following values:

         ==================================== ==================================
         Flag name                            Description
         ==================================== ==================================
         ``AUI_NB_TOP``                       With this style, tabs are drawn along the top of the notebook
         ``AUI_NB_LEFT``                      With this style, tabs are drawn along the left of the notebook. Not implemented yet.
         ``AUI_NB_RIGHT``                     With this style, tabs are drawn along the right of the notebook. Not implemented yet.
         ``AUI_NB_BOTTOM``                    With this style, tabs are drawn along the bottom of the notebook
         ``AUI_NB_TAB_SPLIT``                 Allows the tab control to be split by dragging a tab
         ``AUI_NB_TAB_MOVE``                  Allows a tab to be moved horizontally by dragging
         ``AUI_NB_TAB_EXTERNAL_MOVE``         Allows a tab to be moved to another tab control
         ``AUI_NB_TAB_FIXED_WIDTH``           With this style, all tabs have the same width
         ``AUI_NB_SCROLL_BUTTONS``            With this style, left and right scroll buttons are displayed
         ``AUI_NB_WINDOWLIST_BUTTON``         With this style, a drop-down list of windows is available
         ``AUI_NB_CLOSE_BUTTON``              With this style, a close button is available on the tab bar
         ``AUI_NB_CLOSE_ON_ACTIVE_TAB``       With this style, a close button is available on the active tab
         ``AUI_NB_CLOSE_ON_ALL_TABS``         With this style, a close button is available on all tabs
         ``AUI_NB_MIDDLE_CLICK_CLOSE``        Allows to close :class:`~wx.lib.agw.aui.auibook.AuiNotebook` tabs by mouse middle button click
         ``AUI_NB_SUB_NOTEBOOK``              This style is used by :class:`~wx.lib.agw.aui.framemanager.AuiManager` to create automatic AuiNotebooks
         ``AUI_NB_HIDE_ON_SINGLE_TAB``        Hides the tab window if only one tab is present
         ``AUI_NB_SMART_TABS``                Use Smart Tabbing, like ``Alt`` + ``Tab`` on Windows
         ``AUI_NB_USE_IMAGES_DROPDOWN``       Uses images on dropdown window list menu instead of check items
         ``AUI_NB_CLOSE_ON_TAB_LEFT``         Draws the tab close button on the left instead of on the right (a la Camino browser)
         ``AUI_NB_TAB_FLOAT``                 Allows the floating of single tabs. Known limitation: when the notebook is more or less full
                                              screen, tabs cannot be dragged far enough outside of the notebook to become floating pages
         ``AUI_NB_DRAW_DND_TAB``              Draws an image representation of a tab while dragging (on by default)
         ``AUI_NB_ORDER_BY_ACCESS``           Tab navigation order by last access time for the tabs
         ``AUI_NB_NO_TAB_FOCUS``              Don't draw tab focus rectangle
         ==================================== ==================================

        """

        self._agwFlags = agwFlags


    def GetAGWFlags(self):
        """
        Returns the tab art flags.

        :see: :meth:`~AuiSimpleTabArt.SetAGWFlags` for a list of possible return values.
        """

        return self._agwFlags


    def SetSizingInfo(self, tab_ctrl_size, tab_count, minMaxTabWidth):
        """
        Sets the tab sizing information.

        :param wx.Size `tab_ctrl_size`: the size of the tab control area;
        :param integer `tab_count`: the number of tabs;
        :param tuple `minMaxTabWidth`: a tuple containing the minimum and maximum tab widths
         to be used when the ``AUI_NB_TAB_FIXED_WIDTH`` style is active.
        """

        self._fixed_tab_width = 100
        minTabWidth, maxTabWidth = minMaxTabWidth

        tot_width = tab_ctrl_size.x - self.GetIndentSize() - 4

        if self._agwFlags & aui.AUI_NB_CLOSE_BUTTON:
            tot_width -= self._active_close_bmp.GetWidth()
        if self._agwFlags & aui.AUI_NB_WINDOWLIST_BUTTON:
            tot_width -= self._active_windowlist_bmp.GetWidth()

        if tab_count > 0:
            self._fixed_tab_width = tot_width/tab_count

        if self._fixed_tab_width < 100:
            self._fixed_tab_width = 100

        if self._fixed_tab_width > tot_width/2:
            self._fixed_tab_width = tot_width/2

        if self._fixed_tab_width > 220:
            self._fixed_tab_width = 220

        if minTabWidth > -1:
            self._fixed_tab_width = max(self._fixed_tab_width, minTabWidth)
        if maxTabWidth > -1:
            self._fixed_tab_width = min(self._fixed_tab_width, maxTabWidth)

        self._tab_ctrl_height = tab_ctrl_size.y


    def DrawBackground(self, dc, wnd, rect):
        """
        Draws the tab area background.

        :param `dc`: a :class:`wx.DC` device context;
        :param `wnd`: a :class:`wx.Window` instance object;
        :param wx.Rect `rect`: the tab control rectangle.
        """

        # draw background
        dc.SetBrush(self._bkbrush)
        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.DrawRectangle(-1, -1, rect.GetWidth()+2, rect.GetHeight()+2)

        # draw base line
        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.DrawLine(0, rect.GetHeight()-1, rect.GetWidth(), rect.GetHeight()-1)


    def DrawTab(self, dc, wnd, page, in_rect, close_button_state, paint_control=False):
        """
        Draws a single tab.

        :param `dc`: a :class:`wx.DC` device context;
        :param `wnd`: a :class:`wx.Window` instance object;
        :param `page`: the tab control page associated with the tab;
        :param wx.Rect `in_rect`: rectangle the tab should be confined to;
        :param integer `close_button_state`: the state of the close button on the tab;
        :param bool `paint_control`: whether to draw the control inside a tab (if any) on a :class:`MemoryDC`.
        """

        # if the caption is empty, measure some temporary text
        caption = page.caption
        if caption == "":
            caption = "Xj"

        agwFlags = self.GetAGWFlags()

        dc.SetFont(self._selected_font)
        selected_textx, selected_texty, dummy = dc.GetFullMultiLineTextExtent(caption)

        dc.SetFont(self._normal_font)
        normal_textx, normal_texty, dummy = dc.GetFullMultiLineTextExtent(caption)

        control = page.control

        # figure out the size of the tab
        tab_size, x_extent = self.GetTabSize(dc, wnd, page.caption, page.bitmap,
                                             page.active, close_button_state, control)

        tab_height = tab_size[1]
        tab_width = tab_size[0]
        tab_x = in_rect.x - 4

        if page.active:
            tab_y = in_rect.y + in_rect.height - tab_height + 2
        else:
            tab_y = in_rect.y + in_rect.height - 28

        caption = page.caption
        # select pen, brush and font for the tab to be drawn

        if page.active:

            dc.SetPen(self._selected_bkpen)
            dc.SetBrush(self._selected_bkbrush)
            dc.SetFont(self._selected_font)
            textx = selected_textx
            texty = selected_texty

        else:

            dc.SetPen(self._normal_bkpen)
            dc.SetBrush(self._normal_bkbrush)
            dc.SetFont(self._normal_font)
            textx = normal_textx
            texty = normal_texty

        if not page.enabled:
            dc.SetTextForeground(wx.SystemSettings.GetColour(wx.SYS_COLOUR_GRAYTEXT))
        else:
            dc.SetTextForeground(wx.Colour("#fff"))

        # -- draw line --

        points = [wx.Point() for i in range(7)]
        points[0].x = tab_x
        points[0].y = tab_y + tab_height - 1
        points[1].x = tab_x + tab_height - 3
        points[1].y = tab_y + 2
        points[2].x = tab_x + tab_height + 1
        points[2].y = tab_y
        points[3].x = tab_x + tab_width - 2
        points[3].y = tab_y
        points[4].x = tab_x + tab_width
        points[4].y = tab_y + 2
        points[5].x = tab_x + tab_width
        points[5].y = tab_y + tab_height - 1
        points[6] = points[0]

        dc.SetClippingRegion(in_rect)
        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.DrawPolygon(points)

        close_button_width = 0

        if close_button_state != aui.AUI_BUTTON_STATE_HIDDEN:

            close_button_width = self._active_close_bmp.GetWidth()
            if agwFlags & aui.AUI_NB_CLOSE_ON_TAB_LEFT:
                if control:
                    text_offset = tab_x + (tab_height/2) + close_button_width - (textx/2) - 2
                else:
                    text_offset = tab_x + (tab_height/2) + ((tab_width+close_button_width)/2) - (textx/2) - 2
            else:
                if control:
                    text_offset = tab_x + (tab_height/2) + close_button_width - (textx/2)
                else:
                    text_offset = tab_x + (tab_height/2) + ((tab_width-close_button_width)/2) - (textx/2)

        else:

            text_offset = tab_x + (tab_height/3) + (tab_width/2) - (textx/2)
            if control:
                if agwFlags & aui.AUI_NB_CLOSE_ON_TAB_LEFT:
                    text_offset = tab_x + (tab_height/3) - (textx/2) + close_button_width + 2
                else:
                    text_offset = tab_x + (tab_height/3) - (textx/2)

        # set minimum text offset
        if text_offset < tab_x + tab_height:
            text_offset = tab_x + tab_height

        # chop text if necessary
        if agwFlags & aui.AUI_NB_CLOSE_ON_TAB_LEFT:
            draw_text = aui.ChopText(dc, caption, tab_width - (text_offset-tab_x))
        else:
            draw_text = aui.ChopText(dc, caption,
                                 tab_width - (text_offset-tab_x) - close_button_width)

        ypos = (tab_y + tab_height)/2 - (texty/2) + 1

        if control:
            if control.GetPosition() != wx.Point(text_offset+1, ypos):
                control.SetPosition(wx.Point(text_offset+1, ypos))

            if not control.IsShown():
                control.Show()

            if paint_control:
                bmp = aui.TakeScreenShot(control.GetScreenRect())
                dc.DrawBitmap(bmp, text_offset+1, ypos, True)

            controlW, controlH = control.GetSize()
            text_offset += controlW + 4

        # draw tab text
        rectx, recty, dummy = dc.GetFullMultiLineTextExtent(draw_text)
        dc.DrawLabel(draw_text, wx.Rect(text_offset, ypos, rectx, recty))

        # draw focus rectangle
        if page.active and wx.Window.FindFocus() == wnd and (agwFlags & aui.AUI_NB_NO_TAB_FOCUS) == 0:

            focusRect = wx.Rect(text_offset, ((tab_y + tab_height)/2 - (texty/2) + 1),
                                selected_textx, selected_texty)

            focusRect.Inflate(2, 2)
            # TODO:
            # This should be uncommented when DrawFocusRect will become
            # available in wxPython
            # wx.RendererNative.Get().DrawFocusRect(wnd, dc, focusRect, 0)

        out_button_rect = wx.Rect()
        # draw close button if necessary
        if close_button_state != aui.AUI_BUTTON_STATE_HIDDEN:

            if page.active:
                bmp = self._active_close_bmp
            else:
                bmp = self._disabled_close_bmp

            if agwFlags & aui.AUI_NB_CLOSE_ON_TAB_LEFT:
                rect = wx.Rect(tab_x + tab_height - 2,
                               tab_y + (tab_height/2) - (bmp.GetHeight()/2) + 1,
                               close_button_width, tab_height - 1)
            else:
                rect = wx.Rect(tab_x + tab_width - close_button_width - 1,
                               tab_y + (tab_height/2) - (bmp.GetHeight()/2) + 1,
                               close_button_width, tab_height - 1)

            # We're just NOT drawing the close button here...
            out_button_rect = wx.Rect(*rect)

        out_tab_rect = wx.Rect(tab_x, tab_y, tab_width, tab_height)
        dc.DestroyClippingRegion()

        return out_tab_rect, out_button_rect, x_extent


    def GetIndentSize(self):
        """ Returns the tabs indent size. """

        return 4


    def GetTabSize(self, dc, wnd, caption, bitmap, active, close_button_state, control=None):
        """
        Returns the tab size for the given caption, bitmap and button state.

        :param `dc`: a :class:`wx.DC` device context;
        :param `wnd`: a :class:`wx.Window` instance object;
        :param string `caption`: the tab text caption;
        :param wx.Bitmap `bitmap`: the bitmap displayed on the tab;
        :param bool `active`: whether the tab is selected or not;
        :param integer `close_button_state`: the state of the close button on the tab;
        :param wx.Window `control`: a :class:`wx.Window` instance inside a tab (or ``None``).
        """

        dc.SetFont(self._measuring_font)
        measured_textx, measured_texty, dummy = dc.GetFullMultiLineTextExtent(caption)

        tab_height = measured_texty + 12
        tab_width = measured_textx + tab_height + 34

        if close_button_state != aui.AUI_BUTTON_STATE_HIDDEN:
            tab_width += self._active_close_bmp.GetWidth()

        if self._agwFlags & aui.AUI_NB_TAB_FIXED_WIDTH:
            tab_width = self._fixed_tab_width

        if control:
            controlW, controlH = control.GetSize()
            tab_width += controlW + 4

        x_extent = tab_width - (tab_height/2) - 1

        return (tab_width, tab_height), x_extent


    def DrawButton(self, dc, wnd, in_rect, button, orientation):
        """
        Draws a button on the tab or on the tab area, depending on the button identifier.

        :param `dc`: a :class:`wx.DC` device context;
        :param `wnd`: a :class:`wx.Window` instance object;
        :param wx.Rect `in_rect`: rectangle the tab should be confined to;
        :param `button`: an instance of the button class;
        :param integer `orientation`: the tab orientation.
        """

        bitmap_id, button_state = button.id, button.cur_state

        if bitmap_id == aui.AUI_BUTTON_CLOSE:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                bmp = self._disabled_close_bmp
            else:
                bmp = self._active_close_bmp

        elif bitmap_id == aui.AUI_BUTTON_LEFT:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                bmp = self._disabled_left_bmp
            else:
                bmp = self._active_left_bmp

        elif bitmap_id == aui.AUI_BUTTON_RIGHT:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                bmp = self._disabled_right_bmp
            else:
                bmp = self._active_right_bmp

        elif bitmap_id == aui.AUI_BUTTON_WINDOWLIST:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                bmp = self._disabled_windowlist_bmp
            else:
                bmp = self._active_windowlist_bmp

        else:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                bmp = button.dis_bitmap
            else:
                bmp = button.bitmap

        if not bmp.IsOk():
            return

        rect = wx.Rect(*in_rect)

        if orientation == wx.LEFT:

            rect.SetX(in_rect.x)
            rect.SetY(((in_rect.y + in_rect.height)/2) - (bmp.GetHeight()/2))
            rect.SetWidth(bmp.GetWidth())
            rect.SetHeight(bmp.GetHeight())

        else:

            rect = wx.Rect(in_rect.x + in_rect.width - bmp.GetWidth(),
                           ((in_rect.y + in_rect.height)/2) - (bmp.GetHeight()/2),
                           bmp.GetWidth(), bmp.GetHeight())

        self.DrawButtons(dc, rect, bmp, wx.WHITE, button_state)

        out_rect = wx.Rect(*rect)
        return out_rect


    def ShowDropDown(self, wnd, pages, active_idx):
        """
        Shows the drop-down window menu on the tab area.

        :param `wnd`: a :class:`wx.Window` derived window instance;
        :param list `pages`: the pages associated with the tabs;
        :param integer `active_idx`: the active tab index.
        """

        menuPopup = wx.Menu()
        useImages = self.GetAGWFlags() & aui.AUI_NB_USE_IMAGES_DROPDOWN

        for i, page in enumerate(pages):

            if useImages:
                menuItem = wx.MenuItem(menuPopup, 1000+i, page.caption)
                if page.bitmap:
                    menuItem.SetBitmap(page.bitmap)

                menuPopup.Append(menuItem)

            else:

                menuPopup.AppendCheckItem(1000+i, page.caption)

            menuPopup.Enable(1000+i, page.enabled)

        if active_idx != -1 and not useImages:
            menuPopup.Check(1000+active_idx, True)

        cc = AuiCommandCapture()
        wnd.PushEventHandler(cc)
        wnd.PopupMenu(menuPopup)
        command = cc.GetCommandId()
        wnd.PopEventHandler(True)

        if command >= 1000:
            return command-1000

        return -1


    def GetBestTabCtrlSize(self, wnd, pages, required_bmp_size):
        """
        Returns the best tab control size.

        :param `wnd`: a :class:`wx.Window` instance object;
        :param list `pages`: the pages associated with the tabs;
        :param wx.Size `required_bmp_size`: the size of the bitmap on the tabs.
        """

        dc = wx.ClientDC(wnd)
        dc.SetFont(self._measuring_font)
        s, x_extent = self.GetTabSize(dc, wnd, "ABCDEFGHIj", wx.NullBitmap, True,
                                      aui.AUI_BUTTON_STATE_HIDDEN, None)

        max_y = s[1]

        for page in pages:
            if page.control:
                controlW, controlH = page.control.GetSize()
                max_y = max(max_y, controlH+4)

            textx, texty, dummy = dc.GetFullMultiLineTextExtent(page.caption)
            max_y = max(max_y, texty)

        return max_y + 3


    def SetNormalFont(self, font):
        """
        Sets the normal font for drawing tab labels.

        :param wx.Font `font`: the new font to use to draw tab labels in their normal, un-selected state.
        """

        self._normal_font = font


    def SetSelectedFont(self, font):
        """
        Sets the selected tab font for drawing tab labels.

        :param wx.Font `font`: the new font to use to draw tab labels in their selected state.
        """

        self._selected_font = font


    def SetMeasuringFont(self, font):
        """
        Sets the font for calculating text measurements.

        :param wx.Font `font`: the new font to use to measure tab labels text extents.
        """

        self._measuring_font = font


    def GetNormalFont(self):
        """ Returns the normal font for drawing tab labels. """

        return self._normal_font


    def GetSelectedFont(self):
        """ Returns the selected tab font for drawing tab labels. """

        return self._selected_font


    def GetMeasuringFont(self):
        """ Returns the font for calculating text measurements. """

        return self._measuring_font


    def SetCustomButton(self, bitmap_id, button_state, bmp):
        """
        Sets a custom bitmap for the close, left, right and window list buttons.

        :param integer `bitmap_id`: the button identifier;
        :param integer `button_state`: the button state;
        :param wx.Bitmap `bmp`: the custom bitmap to use for the button.
        """

        if bitmap_id == aui.AUI_BUTTON_CLOSE:
            if button_state == aui.AUI_BUTTON_STATE_NORMAL:
                self._active_close_bmp = bmp
                self._hover_close_bmp = self._active_close_bmp
                self._pressed_close_bmp = self._active_close_bmp
                self._disabled_close_bmp = self._active_close_bmp

            elif button_state == aui.AUI_BUTTON_STATE_HOVER:
                self._hover_close_bmp = bmp
            elif button_state == aui.AUI_BUTTON_STATE_PRESSED:
                self._pressed_close_bmp = bmp
            else:
                self._disabled_close_bmp = bmp

        elif bitmap_id == aui.AUI_BUTTON_LEFT:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                self._disabled_left_bmp = bmp
            else:
                self._active_left_bmp = bmp

        elif bitmap_id == aui.AUI_BUTTON_RIGHT:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                self._disabled_right_bmp = bmp
            else:
                self._active_right_bmp = bmp

        elif bitmap_id == aui.AUI_BUTTON_WINDOWLIST:
            if button_state & aui.AUI_BUTTON_STATE_DISABLED:
                self._disabled_windowlist_bmp = bmp
            else:
                self._active_windowlist_bmp = bmp
