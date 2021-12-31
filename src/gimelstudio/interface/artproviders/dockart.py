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
#
# This file includes code from wx.lib.agw and the wxPython demo
# ----------------------------------------------------------------------------

import wx
import wx.lib.agw.aui as aui

optionActive = 2**14


class UIDockArt(object):
    def __init__(self):
        """ Default class constructor. """

        self.Init()

        isMac = wx.Platform == "__WXMAC__"

        self._caption_font = wx.SystemSettings.GetFont(wx.SYS_DEFAULT_GUI_FONT).Bold()

        self.SetDefaultPaneBitmaps(isMac)
        self._restore_bitmap = wx.Bitmap(aui.restore_xpm)

        # default metric values
        self._sash_size = 4

        if isMac:
            # This really should be implemented in wx.SystemSettings
            # There is no way to do this that I am aware outside of using
            # the cocoa python bindings. 8 pixels looks correct on my system
            # so hard coding it for now.

            # How do I translate this?!? Not sure of the below implementation...
            # SInt32 height;
            # GetThemeMetric( kThemeMetricSmallPaneSplitterHeight , &height );
            # self._sash_size = height;

            self._sash_size = 8 # Carbon.Appearance.kThemeMetricPaneSplitterHeight

        elif wx.Platform == "__WXGTK__":
            self._sash_size = wx.RendererNative.Get().GetSplitterParams(wx.GetTopLevelWindows()[0]).widthSash

        else:
            self._sash_size = 4

        self._caption_size = 19
        self._border_size = 1
        self._button_size = 14
        self._gripper_size = 9
        self._gradient_type = aui.AUI_GRADIENT_VERTICAL
        self._draw_sash = False


    def Init(self):
        """ Initializes the dock art. """

        self.SetDefaultColours()

        isMac = wx.Platform == "__WXMAC__"

        if isMac:
            self._active_caption_colour = wx.SystemSettings.GetColour(wx.SYS_COLOUR_HIGHLIGHT)
        else:
            self._active_caption_colour = wx.SystemSettings.GetColour(wx.SYS_COLOUR_ACTIVECAPTION)

        self._active_caption_gradient_colour = aui.LightContrastColour(wx.SystemSettings.GetColour(wx.SYS_COLOUR_HIGHLIGHT))
        self._active_caption_text_colour = wx.SystemSettings.GetColour(wx.SYS_COLOUR_HIGHLIGHTTEXT)
        self._inactive_caption_text_colour = wx.BLACK


    def SetDefaultColours(self, base_colour=None):
        """
        Sets the default colours, which are calculated from the given base colour.

        :param `base_colour`: an instance of :class:`wx.Colour`. If defaulted to ``None``, a colour
         is generated accordingly to the platform and theme.
        """

        if base_colour is None:
            base_colour = aui.GetBaseColour()

        darker1_colour = aui.StepColour(base_colour, 85)
        darker2_colour = aui.StepColour(base_colour, 75)
        darker3_colour = aui.StepColour(base_colour, 60)
        darker4_colour = aui.StepColour(base_colour, 40)

        self._background_colour = base_colour
        self._background_gradient_colour = aui.StepColour(base_colour, 180)

        self._inactive_caption_colour = darker1_colour
        self._inactive_caption_gradient_colour = aui.StepColour(base_colour, 97)

        self._sash_brush = wx.Brush(base_colour)
        self._background_brush = wx.Brush(base_colour)
        self._border_pen = wx.Pen(darker2_colour)
        self._gripper_brush = wx.Brush(base_colour)
        self._gripper_pen1 = wx.Pen(darker4_colour)
        self._gripper_pen2 = wx.Pen(darker3_colour)
        self._gripper_pen3 = wx.WHITE_PEN

        self._hint_background_colour = aui.colourHintBackground
        self._hint_border_colour = aui.colourHintBorder


    def GetMetric(self, id):
        """
        Gets the value of a certain setting.

        :param integer `id`: can be one of the size values in `Metric Ordinals`.
        """


        if id == aui.AUI_DOCKART_SASH_SIZE:
            return self._sash_size
        elif id == aui.AUI_DOCKART_CAPTION_SIZE:
            return self._caption_size
        elif id == aui.AUI_DOCKART_GRIPPER_SIZE:
            return self._gripper_size
        elif id == aui.AUI_DOCKART_PANE_BORDER_SIZE:
            return self._border_size
        elif id == aui.AUI_DOCKART_PANE_BUTTON_SIZE:
            return self._button_size
        elif id == aui.AUI_DOCKART_GRADIENT_TYPE:
            return self._gradient_type
        elif id == aui.AUI_DOCKART_DRAW_SASH_GRIP:
            return self._draw_sash
        else:
            raise Exception("Invalid Metric Ordinal.")


    def SetMetric(self, id, new_val):
        """
        Sets the value of a certain setting using `new_val`

        :param integer `id`: can be one of the size values in `Metric Ordinals`;
        :param `new_val`: the new value of the setting.
        """

        if id == aui.AUI_DOCKART_SASH_SIZE:
            self._sash_size = new_val
        elif id == aui.AUI_DOCKART_CAPTION_SIZE:
            self._caption_size = new_val
        elif id == aui.AUI_DOCKART_GRIPPER_SIZE:
            self._gripper_size = new_val
        elif id == aui.AUI_DOCKART_PANE_BORDER_SIZE:
            self._border_size = new_val
        elif id == aui.AUI_DOCKART_PANE_BUTTON_SIZE:
            self._button_size = new_val
        elif id == aui.AUI_DOCKART_GRADIENT_TYPE:
            self._gradient_type = new_val
        elif id == aui.AUI_DOCKART_DRAW_SASH_GRIP:
            self._draw_sash = new_val
        else:
            raise Exception("Invalid Metric Ordinal.")


    def GetColor(self, id):
        """
        Gets the colour of a certain setting.

        :param integer `id`: can be one of the colour values in `Metric Ordinals`.
        """

        if id == aui.AUI_DOCKART_BACKGROUND_COLOUR:
            return self._background_brush.GetColour()
        elif id == aui.AUI_DOCKART_BACKGROUND_GRADIENT_COLOUR:
            return self._background_gradient_colour
        elif id == aui.AUI_DOCKART_SASH_COLOUR:
            return self._sash_brush.GetColour()
        elif id == aui.AUI_DOCKART_INACTIVE_CAPTION_COLOUR:
            return self._inactive_caption_colour
        elif id == aui.AUI_DOCKART_INACTIVE_CAPTION_GRADIENT_COLOUR:
            return self._inactive_caption_gradient_colour
        elif id == aui.AUI_DOCKART_INACTIVE_CAPTION_TEXT_COLOUR:
            return self._inactive_caption_text_colour
        elif id == aui.AUI_DOCKART_ACTIVE_CAPTION_COLOUR:
            return self._active_caption_colour
        elif id == aui.AUI_DOCKART_ACTIVE_CAPTION_GRADIENT_COLOUR:
            return self._active_caption_gradient_colour
        elif id == aui.AUI_DOCKART_ACTIVE_CAPTION_TEXT_COLOUR:
            return self._active_caption_text_colour
        elif id == aui.AUI_DOCKART_BORDER_COLOUR:
            return self._border_pen.GetColour()
        elif id == aui.AUI_DOCKART_GRIPPER_COLOUR:
            return self._gripper_brush.GetColour()
        elif id == aui.AUI_DOCKART_HINT_WINDOW_COLOUR:
            return self._hint_background_colour
        elif id == aui.AUI_DOCKART_HINT_WINDOW_BORDER_COLOUR:
            return self._hint_border_colour
        else:
            raise Exception("Invalid Colour Ordinal.")


    def SetColor(self, id, colour):
        """
        Sets the colour of a certain setting.

        :param integer `id`: can be one of the colour values in `Metric Ordinals`;
        :param `colour`: the new value of the setting.
        :type `colour`: :class:`wx.Colour` or tuple or integer
        """

        colour = wx.Colour(colour)

        if id == aui.AUI_DOCKART_BACKGROUND_COLOUR:
            self._background_brush.SetColour(colour)
        elif id == aui.AUI_DOCKART_BACKGROUND_GRADIENT_COLOUR:
            self._background_gradient_colour = colour
        elif id == aui.AUI_DOCKART_SASH_COLOUR:
            self._sash_brush.SetColour(colour)
        elif id == aui.AUI_DOCKART_INACTIVE_CAPTION_COLOUR:
            self._inactive_caption_colour = colour
            if not self._custom_pane_bitmaps and wx.Platform == "__WXMAC__":
                # No custom bitmaps for the pane close button
                # Change the MAC close bitmap colour
                self._inactive_close_bitmap = aui.DrawMACCloseButton(wx.WHITE, colour)

        elif id == aui.AUI_DOCKART_INACTIVE_CAPTION_GRADIENT_COLOUR:
            self._inactive_caption_gradient_colour = colour
        elif id == aui.AUI_DOCKART_INACTIVE_CAPTION_TEXT_COLOUR:
            self._inactive_caption_text_colour = colour
        elif id == aui.AUI_DOCKART_ACTIVE_CAPTION_COLOUR:
            self._active_caption_colour = colour
            if not self._custom_pane_bitmaps and wx.Platform == "__WXMAC__":
                # No custom bitmaps for the pane close button
                # Change the MAC close bitmap colour
                self._active_close_bitmap = aui.DrawMACCloseButton(wx.WHITE, colour)

        elif id == aui.AUI_DOCKART_ACTIVE_CAPTION_GRADIENT_COLOUR:
            self._active_caption_gradient_colour = colour
        elif id == aui.AUI_DOCKART_ACTIVE_CAPTION_TEXT_COLOUR:
            self._active_caption_text_colour = colour
        elif id == aui.AUI_DOCKART_BORDER_COLOUR:
            self._border_pen.SetColour(colour)
        elif id == aui.AUI_DOCKART_GRIPPER_COLOUR:
            self._gripper_brush.SetColour(colour)
            self._gripper_pen1.SetColour(aui.StepColour(colour, 40))
            self._gripper_pen2.SetColour(aui.StepColour(colour, 60))
        elif id == aui.AUI_DOCKART_HINT_WINDOW_COLOUR:
            self._hint_background_colour = colour
        elif id == aui.AUI_DOCKART_HINT_WINDOW_BORDER_COLOUR:
            self._hint_border_colour = colour
        else:
            raise Exception("Invalid Colour Ordinal.")


    GetColour = GetColor
    SetColour = SetColor

    def SetFont(self, id, font):
        """
        Sets a font setting.

        :param integer `id`: must be ``AUI_DOCKART_CAPTION_FONT``;
        :param `font`: an instance of :class:`wx.Font`.
        """

        if id == aui.AUI_DOCKART_CAPTION_FONT:
            self._caption_font = font


    def GetFont(self, id):
        """
        Gets a font setting.

        :param integer `id`: must be ``AUI_DOCKART_CAPTION_FONT``, otherwise :class:`NullFont` is returned.
        """

        if id == aui.AUI_DOCKART_CAPTION_FONT:
            return self._caption_font

        return wx.NullFont


    def DrawSash(self, dc, window, orient, rect):
        """
        Draws a sash between two windows.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param integer `orient`: the sash orientation;
        :param wx.Rect `rect`: the sash rectangle.
        """

        # AG: How do we make this work?!?
        # RendererNative does not use the sash_brush chosen by the user
        # and the rect.GetSize() is ignored as the sash is always drawn
        # 3 pixel wide
        # wx.RendererNative.Get().DrawSplitterSash(window, dc, rect.GetSize(), pos, orient)

        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.SetBrush(self._sash_brush)
        dc.DrawRectangle(rect.x, rect.y, rect.width, rect.height)

        draw_sash = self.GetMetric(aui.AUI_DOCKART_DRAW_SASH_GRIP)
        if draw_sash:
            self.DrawSashGripper(dc, orient, rect)


    def DrawBackground(self, dc, window, orient, rect):
        """
        Draws a background.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param integer `orient`: the gradient (if any) orientation;
        :param wx.Rect `rect`: the background rectangle.
        """

        dc.SetPen(wx.TRANSPARENT_PEN)
        if wx.Platform == "__WXMAC__":
            # we have to clear first, otherwise we are drawing a light striped pattern
            # over an already darker striped background
            dc.SetBrush(wx.WHITE_BRUSH)
            dc.DrawRoundedRectangle(rect.x, rect.y, rect.width, rect.height, 8)

        # Panel backdrop
        dc.SetBrush(wx.Brush(wx.Colour("#232323")))
        dc.DrawRectangle(rect.x, rect.y, rect.width, rect.height)


    def DrawBorder(self, dc, window, rect, pane):
        """
        Draws the pane border.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param wx.Rect `rect`: the border rectangle;
        :param `pane`: the pane for which the border is drawn.
        """

        drect = wx.Rect(*rect)

        dc.SetPen(self._border_pen)
        dc.SetBrush(wx.TRANSPARENT_BRUSH)

        border_width = self.GetMetric(aui.AUI_DOCKART_PANE_BORDER_SIZE)

        if pane.IsToolbar():

            for ii in range(0, border_width):

                dc.SetPen(wx.WHITE_PEN)
                dc.DrawLine(drect.x, drect.y, drect.x+drect.width, drect.y)
                dc.DrawLine(drect.x, drect.y, drect.x, drect.y+drect.height)
                dc.SetPen(self._border_pen)
                dc.DrawLine(drect.x, drect.y+drect.height-1,
                            drect.x+drect.width, drect.y+drect.height-1)
                dc.DrawLine(drect.x+drect.width-1, drect.y,
                            drect.x+drect.width-1, drect.y+drect.height)
                drect.Deflate(1, 1)

        else:

            for ii in range(0, border_width):
                dc.DrawRectangle(drect.x, drect.y, drect.width, drect.height)
                drect.Deflate(1, 1)


    def DrawCaptionBackground(self, dc, rect, pane):
        """
        Draws the text caption background in the pane.

        :param `dc`: a :class:`wx.DC` device context;
        :param wx.Rect `rect`: the text caption rectangle;
        :param `pane`: the pane for which the text background is drawn.
        """

        active = pane.state & optionActive

        if self._gradient_type == aui.AUI_GRADIENT_NONE:
            if active:
                dc.SetBrush(wx.Brush(self._active_caption_colour))
            else:
                dc.SetBrush(wx.Brush(self._inactive_caption_colour))

            dc.DrawRectangle(rect.x, rect.y, rect.width, rect.height)

        else:

            switch_gradient = pane.HasCaptionLeft()
            gradient_type = self._gradient_type
            if switch_gradient:
                gradient_type = (self._gradient_type == aui.AUI_GRADIENT_HORIZONTAL and [aui.AUI_GRADIENT_VERTICAL] or \
                                 [aui.AUI_GRADIENT_HORIZONTAL])[0]

            if active:
                if wx.Platform == "__WXMAC__":
                    aui.DrawGradientRectangle(dc, rect, self._active_caption_colour,
                                          self._active_caption_gradient_colour,
                                          gradient_type)
                else:
                    aui.DrawGradientRectangle(dc, rect, self._active_caption_gradient_colour,
                                          self._active_caption_colour,
                                          gradient_type)
            else:
                if wx.Platform == "__WXMAC__":
                    aui.DrawGradientRectangle(dc, rect, self._inactive_caption_gradient_colour,
                                          self._inactive_caption_colour,
                                          gradient_type)
                else:
                    aui.DrawGradientRectangle(dc, rect, self._inactive_caption_colour,
                                          self._inactive_caption_gradient_colour,
                                          gradient_type)


    def DrawIcon(self, dc, rect, pane):
        """
        Draws the icon in the pane caption area.

        :param `dc`: a :class:`wx.DC` device context;
        :param wx.Rect `rect`: the pane caption rectangle;
        :param `pane`: the pane for which the icon is drawn.
        """

        # Draw the icon centered vertically
        if pane.icon.IsOk():
            if pane.HasCaptionLeft():
                bmp = wx.Bitmap(pane.icon).ConvertToImage().Rotate90(clockwise=False)
                dc.DrawBitmap(bmp.ConvertToBitmap(), rect.x+(rect.width-pane.icon.GetWidth())//2, rect.y+rect.height-2-pane.icon.GetHeight(), True)
            else:
                dc.DrawBitmap(pane.icon, rect.x+2, rect.y+(rect.height-pane.icon.GetHeight())//2, True)


    def DrawCaption(self, dc, window, text, rect, pane):
        """
        Draws the text in the pane caption.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param string `text`: the text to be displayed;
        :param wx.Rect `rect`: the pane caption rectangle;
        :param `pane`: the pane for which the text is drawn.
        """

        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.SetFont(self._caption_font)

        self.DrawCaptionBackground(dc, rect, pane)

        if pane.state & optionActive:
            dc.SetTextForeground(self._active_caption_text_colour)
        else:
            dc.SetTextForeground(self._inactive_caption_text_colour)

        w, h = dc.GetTextExtent("ABCDEFHXfgkj")

        clip_rect = wx.Rect(*rect)
        btns = pane.CountButtons()

        captionLeft = pane.HasCaptionLeft()
        variable = (captionLeft and [rect.height] or [rect.width])[0]

        variable -= 3      # text offset
        variable -= 2      # button padding

        caption_offset = 0
        if pane.icon:
            if captionLeft:
                caption_offset += pane.icon.GetHeight() + 3
            else:
                caption_offset += pane.icon.GetWidth() + 3

            self.DrawIcon(dc, wx.Rect(rect.x+10, rect.y, rect.width, rect.height), pane)

        variable -= caption_offset
        variable -= btns*(self._button_size + self._border_size)
        draw_text = aui.ChopText(dc, text, variable)

        if captionLeft:
            dc.DrawRotatedText(draw_text, rect.x+(rect.width/2)-(h/2)-1, rect.y+rect.height-3-caption_offset, 90)
        else:
            dc.DrawText(draw_text, (rect.x+3+caption_offset)+10, rect.y+(rect.height//2)-(h//2)-1)


    def RequestUserAttention(self, dc, window, text, rect, pane):
        """
        Requests the user attention by intermittently highlighting the pane caption.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param string `text`: the text to be displayed;
        :param wx.Rect `rect`: the pane caption rectangle;
        :param `pane`: the pane for which we want to attract the user attention.
        """

        state = pane.state
        pane.state &= ~optionActive

        for indx in range(6):
            active = (indx%2 == 0 and [True] or [False])[0]
            if active:
                pane.state |= optionActive
            else:
                pane.state &= ~optionActive

            self.DrawCaptionBackground(dc, rect, pane)
            self.DrawCaption(dc, window, text, rect, pane)
            wx.SafeYield()
            wx.MilliSleep(350)

        pane.state = state


    def DrawGripper(self, dc, window, rect, pane):
        """
        Draws a gripper on the pane.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param wx.Rect `rect`: the pane caption rectangle;
        :param `pane`: the pane for which the gripper is drawn.
        """

        dc.SetPen(wx.TRANSPARENT_PEN)
        dc.SetBrush(self._gripper_brush)

        dc.DrawRectangle(rect.x, rect.y, rect.width, rect.height)

        if not pane.HasGripperTop():
            y = 4
            while 1:
                dc.SetPen(self._gripper_pen1)
                dc.DrawPoint(rect.x+3, rect.y+y)
                dc.SetPen(self._gripper_pen2)
                dc.DrawPoint(rect.x+3, rect.y+y+1)
                dc.DrawPoint(rect.x+4, rect.y+y)
                dc.SetPen(self._gripper_pen3)
                dc.DrawPoint(rect.x+5, rect.y+y+1)
                dc.DrawPoint(rect.x+5, rect.y+y+2)
                dc.DrawPoint(rect.x+4, rect.y+y+2)
                y = y + 4
                if y > rect.GetHeight() - 4:
                    break
        else:
            x = 4
            while 1:
                dc.SetPen(self._gripper_pen1)
                dc.DrawPoint(rect.x+x, rect.y+3)
                dc.SetPen(self._gripper_pen2)
                dc.DrawPoint(rect.x+x+1, rect.y+3)
                dc.DrawPoint(rect.x+x, rect.y+4)
                dc.SetPen(self._gripper_pen3)
                dc.DrawPoint(rect.x+x+1, rect.y+5)
                dc.DrawPoint(rect.x+x+2, rect.y+5)
                dc.DrawPoint(rect.x+x+2, rect.y+4)
                x = x + 4
                if x > rect.GetWidth() - 4:
                    break


    def DrawPaneButton(self, dc, window, button, button_state, _rect, pane):
        """
        Draws a pane button in the pane caption area.

        :param `dc`: a :class:`wx.DC` device context;
        :param `window`: an instance of :class:`wx.Window`;
        :param integer `button`: the button to be drawn;
        :param integer `button_state`: the pane button state;
        :param wx.Rect `_rect`: the pane caption rectangle;
        :param `pane`: the pane for which the button is drawn.
        """

        if not pane:
            return

        if button == aui.AUI_BUTTON_CLOSE:
            if pane.state & optionActive:
                bmp = self._active_close_bitmap
            else:
                bmp = self._inactive_close_bitmap

        elif button == aui.AUI_BUTTON_PIN:
            if pane.state & optionActive:
                bmp = self._active_pin_bitmap
            else:
                bmp = self._inactive_pin_bitmap

        elif button == aui.AUI_BUTTON_MAXIMIZE_RESTORE:
            if pane.IsMaximized():
                if pane.state & optionActive:
                    bmp = self._active_restore_bitmap
                else:
                    bmp = self._inactive_restore_bitmap
            else:
                if pane.state & optionActive:
                    bmp = self._active_maximize_bitmap
                else:
                    bmp = self._inactive_maximize_bitmap

        elif button == aui.AUI_BUTTON_MINIMIZE:
            if pane.state & optionActive:
                bmp = self._active_minimize_bitmap
            else:
                bmp = self._inactive_minimize_bitmap

        isVertical = pane.HasCaptionLeft()

        rect = wx.Rect(*_rect)

        if isVertical:
            old_x = rect.x
            rect.x = rect.x + (rect.width//2) - (bmp.GetWidth()//2)
            rect.width = old_x + rect.width - rect.x - 1
        else:
            rect.y = rect.y + (rect.height//2) - (bmp.GetHeight()//2)

        if button_state == aui.AUI_BUTTON_STATE_PRESSED:
            rect.x += 1
            rect.y += 1

        if button_state in [aui.AUI_BUTTON_STATE_HOVER, aui.AUI_BUTTON_STATE_PRESSED]:

            if pane.state & optionActive:

                dc.SetBrush(wx.Brush(aui.StepColour(self._active_caption_colour, 120)))
                dc.SetPen(wx.Pen(aui.StepColour(self._active_caption_colour, 70)))

            else:

                dc.SetBrush(wx.Brush(aui.StepColour(self._inactive_caption_colour, 120)))
                dc.SetPen(wx.Pen(aui.StepColour(self._inactive_caption_colour, 70)))

            if wx.Platform != "__WXMAC__":
                # draw the background behind the button
                dc.DrawRectangle(rect.x, rect.y, 15, 15)
            else:
                # Darker the bitmap a bit
                bmp = aui.DarkenBitmap(bmp, self._active_caption_colour, aui.StepColour(self._active_caption_colour, 110))

        if isVertical:
             bmp = wx.Bitmap(bmp).ConvertToImage().Rotate90(clockwise=False).ConvertToBitmap()

        # draw the button itself
        dc.DrawBitmap(bmp, rect.x, rect.y, True)


    def DrawSashGripper(self, dc, orient, rect):
        """
        Draws a sash gripper on a sash between two windows.

        :param `dc`: a :class:`wx.DC` device context;
        :param integer `orient`: the sash orientation;
        :param wx.Rect `rect`: the sash rectangle.
        """

        dc.SetBrush(self._gripper_brush)

        if orient == wx.HORIZONTAL:  # horizontal sash

            x = rect.x + int((1.0/4.0)*rect.width)
            xend = rect.x + int((3.0/4.0)*rect.width)
            y = rect.y + (rect.height//2) - 1

            while 1:
                dc.SetPen(self._gripper_pen3)
                dc.DrawRectangle(x, y, 2, 2)
                dc.SetPen(self._gripper_pen2)
                dc.DrawPoint(x+1, y+1)
                x = x + 5

                if x >= xend:
                    break

        else:

            y = rect.y + int((1.0/4.0)*rect.height)
            yend = rect.y + int((3.0/4.0)*rect.height)
            x = rect.x + (rect.width//2) - 1

            while 1:
                dc.SetPen(self._gripper_pen3)
                dc.DrawRectangle(x, y, 2, 2)
                dc.SetPen(self._gripper_pen2)
                dc.DrawPoint(x+1, y+1)
                y = y + 5

                if y >= yend:
                    break


    def SetDefaultPaneBitmaps(self, isMac):
        """
        Assigns the default pane bitmaps.

        :param bool `isMac`: whether we are on wxMAC or not.
        """

        if isMac:
            self._inactive_close_bitmap = aui.DrawMACCloseButton(wx.WHITE, self._inactive_caption_colour)
            self._active_close_bitmap = aui.DrawMACCloseButton(wx.WHITE, self._active_caption_colour)
        else:
            self._inactive_close_bitmap = aui.BitmapFromBits(aui.close_bits, 16, 16, self._inactive_caption_text_colour)
            self._active_close_bitmap = aui.BitmapFromBits(aui.close_bits, 16, 16, self._active_caption_text_colour)

        if isMac:
            self._inactive_maximize_bitmap = aui.BitmapFromBits(aui.max_bits, 16, 16, wx.WHITE)
            self._active_maximize_bitmap = aui.BitmapFromBits(aui.max_bits, 16, 16, wx.WHITE)
        else:
            self._inactive_maximize_bitmap = aui.BitmapFromBits(aui.max_bits, 16, 16, self._inactive_caption_text_colour)
            self._active_maximize_bitmap = aui.BitmapFromBits(aui.max_bits, 16, 16, self._active_caption_text_colour)

        if isMac:
            self._inactive_restore_bitmap = aui.BitmapFromBits(aui.restore_bits, 16, 16, wx.WHITE)
            self._active_restore_bitmap = aui.BitmapFromBits(aui.restore_bits, 16, 16, wx.WHITE)
        else:
            self._inactive_restore_bitmap = aui.BitmapFromBits(aui.restore_bits, 16, 16, self._inactive_caption_text_colour)
            self._active_restore_bitmap = aui.BitmapFromBits(aui.restore_bits, 16, 16, self._active_caption_text_colour)

        if isMac:
            self._inactive_minimize_bitmap = aui.BitmapFromBits(aui.minimize_bits, 16, 16, wx.WHITE)
            self._active_minimize_bitmap = aui.BitmapFromBits(aui.minimize_bits, 16, 16, wx.WHITE)
        else:
            self._inactive_minimize_bitmap = aui.BitmapFromBits(aui.minimize_bits, 16, 16, self._inactive_caption_text_colour)
            self._active_minimize_bitmap = aui.BitmapFromBits(aui.minimize_bits, 16, 16, self._active_caption_text_colour)

        self._inactive_pin_bitmap = aui.BitmapFromBits(aui.pin_bits, 16, 16, self._inactive_caption_text_colour)
        self._active_pin_bitmap = aui.BitmapFromBits(aui.pin_bits, 16, 16, self._active_caption_text_colour)

        self._custom_pane_bitmaps = False


    def SetCustomPaneBitmap(self, bmp, button, active, maximize=False):
        """
        Sets a custom button bitmap for the pane button.

        :param wx.Bitmap `bmp`: the actual bitmap to set;
        :param integer `button`: the button identifier;
        :param bool `active`: whether it is the bitmap for the active button or not;
        :param bool `maximize`: used to distinguish between the maximize and restore bitmaps.
        """

        if bmp.GetWidth() > 16 or bmp.GetHeight() > 16:
            raise Exception("The input bitmap is too big")

        if button == aui.AUI_BUTTON_CLOSE:
            if active:
                self._active_close_bitmap = bmp
            else:
                self._inactive_close_bitmap = bmp

            if wx.Platform == "__WXMAC__":
                self._custom_pane_bitmaps = True

        elif button == aui.AUI_BUTTON_PIN:
            if active:
                self._active_pin_bitmap = bmp
            else:
                self._inactive_pin_bitmap = bmp

        elif button == aui.AUI_BUTTON_MAXIMIZE_RESTORE:
            if maximize:
                if active:
                    self._active_maximize_bitmap = bmp
                else:
                    self._inactive_maximize_bitmap = bmp
            else:
                if active:
                    self._active_restore_bitmap = bmp
                else:
                    self._inactive_restore_bitmap = bmp

        elif button == aui.AUI_BUTTON_MINIMIZE:
            if active:
                self._active_minimize_bitmap = bmp
            else:
                self._inactive_minimize_bitmap = bmp
