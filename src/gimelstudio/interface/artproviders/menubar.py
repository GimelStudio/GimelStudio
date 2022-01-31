# ----------------------------------------------------------------------------
# Gimel Studio Copyright 2019-2022 by the Gimel Studio project contributors
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
# This file includes code from wx.lib.agw.flatmenu and the wxPython demo
# ----------------------------------------------------------------------------

import wx
import wx.lib.agw.flatmenu as flatmenu
from wx.lib.agw.artmanager import ArtManager, DCSaver
from wx.lib.agw.fmresources import ControlFocus, ControlPressed

from gimelstudio.constants import ACCENT_COLOR, DARK_COLOR


def switchRGBtoBGR(colour):
    return wx.Colour(colour.Blue(), colour.Green(), colour.Red())


class UIMenuBarRenderer(flatmenu.FMRenderer):
    def __init__(self):
        flatmenu.FMRenderer.__init__(self)

        self.highlightCheckAndRadio = True

        self.menuFaceColour = wx.Colour(DARK_COLOR)
        self.menuBarFaceColour = wx.Colour(DARK_COLOR)

        self.menuBarFocusFaceColour = wx.Colour(ACCENT_COLOR)
        self.menuBarFocusBorderColour = wx.Colour(ACCENT_COLOR)
        self.menuBarPressedFaceColour = wx.Colour(ACCENT_COLOR)
        self.menuBarPressedBorderColour = wx.Colour(ACCENT_COLOR)

        self.menuFocusFaceColour = wx.Colour(ACCENT_COLOR)
        self.menuFocusBorderColour = wx.Colour(ACCENT_COLOR)
        self.menuPressedFaceColour = wx.Colour(ACCENT_COLOR)
        self.menuPressedBorderColour = wx.Colour(ACCENT_COLOR)

        self.buttonFaceColour = wx.Colour(ACCENT_COLOR)
        self.buttonBorderColour = wx.Colour(ACCENT_COLOR)
        self.buttonFocusFaceColour = wx.Colour(ACCENT_COLOR)
        self.buttonFocusBorderColour = wx.Colour(ACCENT_COLOR)
        self.buttonPressedFaceColour = wx.Colour(ACCENT_COLOR)
        self.buttonPressedBorderColour = wx.Colour(ACCENT_COLOR)

    def DrawSeparator(self, dc, xCoord, yCoord, textX, sepWidth):
        """
        Draws a separator inside a :class:`FlatMenu`.

        :param `dc`: an instance of :class:`wx.DC`;
        :param integer `xCoord`: the current x position where to draw the separator;
        :param integer `yCoord`: the current y position where to draw the separator;
        :param integer `textX`: the menu item label x position;
        :param integer `sepWidth`: the width of the separator, in pixels.
        """

        dcsaver = DCSaver(dc)
        sepRect1 = wx.Rect(xCoord + textX, yCoord + 1, sepWidth/2, 1)
        sepRect2 = wx.Rect(xCoord + textX + sepWidth/2, yCoord + 1, sepWidth/2-1, 1)

        artMgr = ArtManager.Get()
        backColour = wx.Colour("#3b3b3b")
        lightColour = wx.Colour("#3d3d3d")

        artMgr.PaintStraightGradientBox(dc, sepRect1, backColour, lightColour, False)
        artMgr.PaintStraightGradientBox(dc, sepRect2, lightColour, backColour, False)

    def DrawMenuItem(self, item, dc, xCoord, yCoord, imageMarginX, markerMarginX, textX, rightMarginX, selected=False, backgroundImage=None):
        """
        Draws the menu item.

        :param `item`: a :class:`FlatMenuItem` instance;
        :param `dc`: an instance of :class:`wx.DC`;
        :param integer `xCoord`: the current x position where to draw the menu;
        :param integer `yCoord`: the current y position where to draw the menu;
        :param integer `imageMarginX`: the spacing between the image and the menu border;
        :param integer `markerMarginX`: the spacing between the checkbox/radio marker and
         the menu border;
        :param integer `textX`: the menu item label x position;
        :param integer `rightMarginX`: the right margin between the text and the menu border;
        :param bool `selected`: ``True`` if this menu item is currentl hovered by the mouse,
         ``False`` otherwise.
        :param `backgroundImage`: if not ``None``, an instance of :class:`wx.Bitmap` which will
         become the background image for this :class:`FlatMenu`.
        """

        borderXSize = item._parentMenu.GetBorderXWidth()
        itemHeight = item._parentMenu.GetItemHeight()
        menuWidth = item._parentMenu.GetMenuWidth()

        # Define the item actual rectangle area
        itemRect = wx.Rect(xCoord, yCoord, menuWidth, itemHeight)

        # Define the drawing area
        rect = wx.Rect(xCoord + 2, yCoord, menuWidth - 4, itemHeight)

        # Draw the background
        backColour = self.menuFaceColour
        penColour = backColour
        backBrush = wx.Brush(backColour)
        leftMarginWidth = item._parentMenu.GetLeftMarginWidth()

        if backgroundImage is None:
            pen = wx.Pen(penColour)
            dc.SetPen(pen)
            dc.SetBrush(backBrush)
            dc.DrawRoundedRectangle(rect, 3)

        # Draw the left margin gradient
        if self.drawLeftMargin:
            self.DrawLeftMargin(item, dc, itemRect)

        # check if separator
        if item.IsSeparator():
            # Separator is a small grey line separating between menu items.
            sepWidth = xCoord + menuWidth - textX - 1
            yCoord += 2
            self.DrawSeparator(dc, xCoord, yCoord, textX, sepWidth)
            return

        # Keep the item rect
        item._rect = itemRect

        # Get the bitmap base on the item state (disabled, selected ..)
        bmp = item.GetSuitableBitmap(selected)

        # First we draw the selection rectangle
        if selected:
            self.DrawMenuButton(dc, rect.Deflate(1, 0), ControlFocus)
            #copy.Inflate(0, menubar._spacer)

        if bmp.IsOk():

            # Calculate the postion to place the image
            imgHeight = bmp.GetHeight()
            imgWidth = bmp.GetWidth()

            if imageMarginX == 0:
                xx = rect.x + (leftMarginWidth - imgWidth) / 2
            else:
                xx = rect.x + ((leftMarginWidth - rect.height) - imgWidth) / 2 + rect.height

            yy = rect.y + (rect.height - imgHeight) / 2
            dc.DrawBitmap(bmp, xx, yy, True)

        if item.GetKind() == wx.ITEM_CHECK:

            # Checkable item
            if item.IsChecked():

                # Draw surrounding rectangle around the selection box
                xx = rect.x + 1
                yy = rect.y + 1
                rr = wx.Rect(xx, yy, rect.height - 2, rect.height - 2)

                if not selected and self.highlightCheckAndRadio:
                    self.DrawButton(dc, rr, ControlFocus)

                dc.DrawBitmap(item._checkMarkBmp, rr.x + (rr.width - 16) / 2, rr.y + (rr.height - 16) / 2, True)

        if item.GetKind() == wx.ITEM_RADIO:

            # Checkable item
            if item.IsChecked():

                # Draw surrounding rectangle around the selection box
                xx = rect.x + 1
                yy = rect.y + 1
                rr = wx.Rect(xx, yy, rect.height - 2, rect.height - 2)

                if not selected and self.highlightCheckAndRadio:
                    self.DrawButton(dc, rr, ControlFocus)

                dc.DrawBitmap(item._radioMarkBmp, rr.x + (rr.width - 16) / 2, rr.y + (rr.height - 16) / 2, True)

        # Draw text - without accelerators
        text = item.GetLabel()

        if text:

            font = item.GetFont()
            if font is None:
                font = wx.SystemSettings.GetFont(wx.SYS_DEFAULT_GUI_FONT)

            # EDITED - This is my edit to always have the font color white:
            enabledTxtColour = wx.Colour("#fff")

            disabledTxtColour = self.itemTextColourDisabled
            textColour = (item.IsEnabled() and [enabledTxtColour] or [disabledTxtColour])[0]

            if item.IsEnabled() and item.GetTextColour():
                textColour = item.GetTextColour()

            dc.SetFont(font)
            w, h = dc.GetTextExtent(text)
            dc.SetTextForeground(textColour)

            if item._mnemonicIdx != wx.NOT_FOUND:

                # We divide the drawing to 3 parts
                text1 = text[0:item._mnemonicIdx]
                text2 = text[item._mnemonicIdx]
                text3 = text[item._mnemonicIdx + 1:]

                w1, dummy = dc.GetTextExtent(text1)
                w2, dummy = dc.GetTextExtent(text2)
                w3, dummy = dc.GetTextExtent(text3)

                posx = xCoord + textX + borderXSize
                posy = (itemHeight - h) / 2 + yCoord

                # Draw first part
                dc.DrawText(text1, posx, posy)

                # mnemonic
                if "__WXGTK__" not in wx.Platform:
                    font.SetUnderlined(True)
                    dc.SetFont(font)

                posx += w1
                dc.DrawText(text2, posx, posy)

                # last part
                font.SetUnderlined(False)
                dc.SetFont(font)
                posx += w2
                dc.DrawText(text3, posx, posy)

            else:

                w, h = dc.GetTextExtent(text)
                dc.DrawText(text, xCoord + textX + borderXSize, (itemHeight - h) / 2 + yCoord)

        # Now draw accelerator
        # Accelerators are aligned to the right
        if item.GetAccelString():

            accelWidth, accelHeight = dc.GetTextExtent(item.GetAccelString())
            dc.DrawText(item.GetAccelString(), xCoord + rightMarginX -
                        accelWidth, (itemHeight - accelHeight) / 2 + yCoord)

        # Check if this item has sub-menu - if it does, draw
        # right arrow on the right margin
        if item.GetSubMenu():

            # Draw arrow
            rightArrowBmp = wx.Bitmap(menu_right_arrow_xpm)
            rightArrowBmp.SetMask(wx.Mask(rightArrowBmp, wx.WHITE))

            xx = xCoord + rightMarginX + borderXSize
            rr = wx.Rect(xx, rect.y + 1, rect.height - 2, rect.height - 2)
            dc.DrawBitmap(rightArrowBmp, rr.x + 4, rr.y + (rr.height - 16) / 2, True)

    def DrawButton(self, dc, rect, state, colour=None):
        """
        Draws a button.

        :param `dc`: an instance of :class:`wx.DC`;
        :param `rect`: an instance of :class:`wx.Rect`, representing the button client rectangle;
        :param integer `state`: the button state;
        :param `colour`: if not ``None``, an instance of :class:`wx.Colour` to be used to draw
         the :class:`FlatMenuItem` background.
        """

        # switch according to the status
        if state == ControlFocus:
            if colour is None:
                penColour   = self.buttonFocusBorderColour
                brushColour = self.buttonFocusFaceColour
            else:
                penColour   = colour
                brushColour = ArtManager.Get().LightColour(colour, 75)

        elif state == ControlPressed:
            if colour is None:
                penColour   = self.buttonPressedBorderColour
                brushColour = self.buttonPressedFaceColour
            else:
                penColour   = colour
                brushColour = ArtManager.Get().LightColour(colour, 60)
        else:
            if colour is None:
                penColour   = self.buttonBorderColour
                brushColour = self.buttonFaceColour
            else:
                penColour   = colour
                brushColour = ArtManager.Get().LightColour(colour, 75)

        dcsaver = DCSaver(dc)
        dc.SetPen(wx.Pen(penColour))
        dc.SetBrush(wx.Brush(brushColour))
        dc.DrawRoundedRectangle(rect, 2)

    def DrawMenuBar(self, menubar, dc):
        """
        Draws everything for :class:`FlatMenuBar`.

        :param `menubar`: an instance of :class:`FlatMenuBar`.
        :param `dc`: an instance of :class:`wx.DC`.
        """

        #artMgr = ArtManager.Get()
        fnt = wx.SystemSettings.GetFont(wx.SYS_DEFAULT_GUI_FONT)

        # EDITED - This is my edit to always make the font color white
        textColour = wx.Colour("#fff")
        highlightTextColour = wx.Colour("#fff")

        dc.SetFont(fnt)
        dc.SetTextForeground(textColour)

        clientRect = menubar.GetClientRect()

        self.DrawMenuBarBackground(dc, clientRect)

        padding, dummy = dc.GetTextExtent("W")

        posx = 0
        posy = menubar._margin

        # Monkey-patch padding between menus
        padding += 11

        # ---------------------------------------------------------------------------
        # Draw as much items as we can if the screen is not wide enough, add all
        # missing items to a drop down menu
        # ---------------------------------------------------------------------------
        menuBarRect = menubar.GetClientRect()

        # mark all items as non-visibles at first
        for item in menubar._items:
            item.SetRect(wx.Rect())

        for item in menubar._items:

            # Handle accelerator ('&')
            title = item.GetTitle()

            fixedText = title
            location, labelOnly = flatmenu.GetAccelIndex(fixedText)

            # Get the menu item rect
            textWidth, textHeight = dc.GetTextExtent(fixedText)
            #rect = wx.Rect(posx+menubar._spacer/2, posy, textWidth, textHeight)
            rect = wx.Rect(posx + padding / 2, posy, textWidth, textHeight)

            # Can we draw more??
            # the +DROP_DOWN_ARROW_WIDTH  is the width of the drop down arrow
            if posx + rect.width + flatmenu.DROP_DOWN_ARROW_WIDTH >= menuBarRect.width:
                break

            # In this style the button highlight includes the menubar margin
            button_rect = wx.Rect(*rect)
            button_rect.height = menubar._menuBarHeight
            #button_rect.width = rect.width + menubar._spacer
            button_rect.width = rect.width + padding
            button_rect.x = posx
            button_rect.y = 0

            # Keep the item rectangle, will be used later in functions such
            # as 'OnLeftDown', 'OnMouseMove'
            copy = wx.Rect(*button_rect)
            #copy.Inflate(0, menubar._spacer)
            item.SetRect(copy)

            selected = False
            if item.GetState() == ControlFocus:
                self.DrawMenuBarButton(dc, button_rect, ControlFocus)
                dc.SetTextForeground(highlightTextColour)
                selected = True
            else:
                dc.SetTextForeground(textColour)

            ww, hh = dc.GetTextExtent(labelOnly)
            textOffset = (rect.width - ww) / 2

            if not menubar._isLCD and item.GetTextBitmap().IsOk() and not selected:
                dc.DrawBitmap(item.GetTextBitmap(), rect.x, rect.y, True)
            elif not menubar._isLCD and item.GetSelectedTextBitmap().IsOk() and selected:
                dc.DrawBitmap(item.GetSelectedTextBitmap(), rect.x, rect.y, True)
            else:
                if not menubar._isLCD:
                    # Draw the text on a bitmap using memory dc,
                    # so on following calls we will use this bitmap instead
                    # of calculating everything from scratch
                    bmp = wx.Bitmap(rect.width, rect.height)
                    memDc = wx.MemoryDC()
                    memDc.SelectObject(bmp)
                    if selected:
                        memDc.SetTextForeground(highlightTextColour)
                    else:
                        memDc.SetTextForeground(textColour)

                    # Fill the bitmap with the masking colour
                    memDc.SetPen(wx.Pen(wx.Colour(255, 0, 0)))
                    memDc.SetBrush(wx.Brush(wx.Colour(255, 0, 0)))
                    memDc.DrawRoundedRectangle(0, 0, rect.width, rect.height, 3)
                    memDc.SetFont(fnt)

                if location == wx.NOT_FOUND or location >= len(fixedText):
                    # draw the text
                    if not menubar._isLCD:
                        memDc.DrawText(title, textOffset, 0)
                    dc.DrawText(title, rect.x + textOffset, rect.y)

                else:

                    # underline the first '&'
                    before = labelOnly[0:location]
                    underlineLetter = labelOnly[location]
                    after = labelOnly[location + 1:]

                    # before
                    if not menubar._isLCD:
                        memDc.DrawText(before, textOffset, 0)
                    dc.DrawText(before, rect.x + textOffset, rect.y)

                    # underlineLetter
                    if "__WXGTK__" not in wx.Platform:
                        w1, h = dc.GetTextExtent(before)
                        fnt.SetUnderlined(True)
                        dc.SetFont(fnt)
                        dc.DrawText(underlineLetter, rect.x + w1 + textOffset, rect.y)
                        if not menubar._isLCD:
                            memDc.SetFont(fnt)
                            memDc.DrawText(underlineLetter, textOffset + w1, 0)

                    else:
                        w1, h = dc.GetTextExtent(before)
                        dc.DrawText(underlineLetter, rect.x + w1 + textOffset, rect.y)
                        if not menubar._isLCD:
                            memDc.DrawText(underlineLetter, textOffset + w1, 0)

                        # Draw the underline ourselves since using the Underline in GTK,
                        # causes the line to be too close to the letter

                        uderlineLetterW, uderlineLetterH = dc.GetTextExtent(underlineLetter)
                        dc.DrawLine(rect.x + w1 + textOffset, rect.y + uderlineLetterH - 2,
                                    rect.x + w1 + textOffset + uderlineLetterW, rect.y + uderlineLetterH - 2)

                    # after
                    w2, h = dc.GetTextExtent(underlineLetter)
                    fnt.SetUnderlined(False)
                    dc.SetFont(fnt)
                    dc.DrawText(after, rect.x + w1 + w2 + textOffset, rect.y)
                    if not menubar._isLCD:
                        memDc.SetFont(fnt)
                        memDc.DrawText(after, w1 + w2 + textOffset, 0)

                    if not menubar._isLCD:
                        memDc.SelectObject(wx.NullBitmap)
                        # Set masking colour to the bitmap
                        bmp.SetMask(wx.Mask(bmp, wx.Colour(255, 0, 0)))
                        if selected:
                            item.SetSelectedTextBitmap(bmp)
                        else:
                            item.SetTextBitmap(bmp)

            posx += rect.width + padding  # + menubar._spacer

        # Get a background image of the more menu button
        moreMenubtnBgBmpRect = wx.Rect(*menubar.GetMoreMenuButtonRect())
        if not menubar._moreMenuBgBmp:
            menubar._moreMenuBgBmp = wx.Bitmap(moreMenubtnBgBmpRect.width, moreMenubtnBgBmpRect.height)

        if menubar._showToolbar and len(menubar._tbButtons) > 0:
            rectX = 0
            rectWidth = clientRect.width - moreMenubtnBgBmpRect.width
            if len(menubar._items) == 0:
                rectHeight = clientRect.height
                rectY = 0
            else:
                rectHeight = clientRect.height - menubar._menuBarHeight
                rectY = menubar._menuBarHeight
            rr = wx.Rect(rectX, rectY, rectWidth, rectHeight)
            self.DrawToolBarBg(dc, rr)
            menubar.DrawToolbar(dc, rr)

        if menubar._showCustomize or menubar.GetInvisibleMenuItemCount() > 0 or menubar.GetInvisibleToolbarItemCount() > 0:
            memDc = wx.MemoryDC()
            memDc.SelectObject(menubar._moreMenuBgBmp)
            try:
                memDc.Blit(0, 0, menubar._moreMenuBgBmp.GetWidth(), menubar._moreMenuBgBmp.GetHeight(), dc,
                           moreMenubtnBgBmpRect.x, moreMenubtnBgBmpRect.y)
            except:
                pass
            memDc.SelectObject(wx.NullBitmap)

            # Draw the drop down arrow button
            menubar.DrawMoreButton(dc, menubar._dropDownButtonState)
            # Set the button rect
            menubar._dropDownButtonArea = moreMenubtnBgBmpRect


    def DrawMenuBarButton(self, dc, rect, state):
        """
        Draws the highlight on a :class:`FlatMenuBar`.

        :param `dc`: an instance of :class:`wx.DC`;
        :param `rect`: an instance of :class:`wx.Rect`, representing the button client rectangle;
        :param integer `state`: the button state.
        """

        # switch according to the status
        if state == ControlFocus:
            penColour   = self.menuBarFocusBorderColour
            brushColour = self.menuBarFocusFaceColour
        elif state == ControlPressed:
            penColour   = self.menuBarPressedBorderColour
            brushColour = self.menuBarPressedFaceColour

        dcsaver = DCSaver(dc)
        dc.SetPen(wx.Pen(penColour))
        dc.SetBrush(wx.Brush(brushColour))
        dc.DrawRoundedRectangle(rect, 3)


    def DrawMenuButton(self, dc, rect, state):
        """
        Draws the highlight on a FlatMenu

        :param `dc`: an instance of :class:`wx.DC`;
        :param `rect`: an instance of :class:`wx.Rect`, representing the button client rectangle;
        :param integer `state`: the button state.
        """

        # switch according to the status
        if state == ControlFocus:
            penColour   = self.menuFocusBorderColour
            brushColour = self.menuFocusFaceColour
        elif state == ControlPressed:
            penColour   = self.menuPressedBorderColour
            brushColour = self.menuPressedFaceColour

        dcsaver = DCSaver(dc)
        dc.SetPen(wx.Pen(penColour))
        dc.SetBrush(wx.Brush(brushColour))
        dc.DrawRoundedRectangle(rect, 3)


    def DrawMenu(self, flatmenu, dc):
        """
        Draws the menu.

        :param `flatmenu`: the :class:`FlatMenu` instance we need to paint;
        :param `dc`: an instance of :class:`wx.DC`.
        """

        menuRect = flatmenu.GetClientRect()
        menuBmp = wx.Bitmap(menuRect.width, menuRect.height)

        mem_dc = wx.MemoryDC()
        mem_dc.SelectObject(menuBmp)

        # colour the menu face with background colour
        backColour = self.menuFaceColour
        backBrush = wx.Brush(backColour)
        pen = wx.Pen(wx.TRANSPARENT_PEN)

        mem_dc.SetPen(pen)
        mem_dc.SetBrush(backBrush)
        mem_dc.DrawRectangle(menuRect)

        backgroundImage = flatmenu._backgroundImage

        if backgroundImage:
            mem_dc.DrawBitmap(backgroundImage, flatmenu._leftMarginWidth, 0, True)

        # draw items
        posy = 3
        nItems = len(flatmenu._itemsArr)

        # make all items as non-visible first
        for item in flatmenu._itemsArr:
            item.Show(False)

        visibleItems = 0
        screenHeight = wx.SystemSettings.GetMetric(wx.SYS_SCREEN_Y)

        numCols = flatmenu.GetNumberColumns()
        switch, posx, index = 1e6, 0, 0
        if numCols > 1:
            switch = int(math.ceil((nItems - flatmenu._first)/float(numCols)))

        # If we have to scroll and are not using the scroll bar buttons we need to draw
        # the scroll up menu item at the top.
        if not self.scrollBarButtons and flatmenu._showScrollButtons:
            posy += flatmenu.GetItemHeight()

        for nCount in range(flatmenu._first, nItems):

            visibleItems += 1
            item = flatmenu._itemsArr[nCount]
            self.DrawMenuItem(item, mem_dc, posx, posy,
                              flatmenu._imgMarginX, flatmenu._markerMarginX,
                              flatmenu._textX, flatmenu._rightMarginPosX,
                              nCount == flatmenu._selectedItem,
                              backgroundImage=backgroundImage)
            posy += item.GetHeight()
            item.Show()

            if visibleItems >= switch:
                posy = 2
                index += 1
                posx = flatmenu._menuWidth*index
                visibleItems = 0

            # make sure we draw only visible items
            pp = flatmenu.ClientToScreen(wx.Point(0, posy))

            menuBottom = (self.scrollBarButtons and [pp.y] or [pp.y + flatmenu.GetItemHeight() * 2])[0]

            if menuBottom > screenHeight:
                break

        if flatmenu._showScrollButtons:
            if flatmenu._upButton:
                flatmenu._upButton.Draw(mem_dc)
            if flatmenu._downButton:
                flatmenu._downButton.Draw(mem_dc)

        dc.Blit(0, 0, menuBmp.GetWidth(), menuBmp.GetHeight(), mem_dc, 0, 0)
