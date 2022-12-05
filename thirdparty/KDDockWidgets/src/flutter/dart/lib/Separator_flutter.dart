/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'PositionedWidget.dart';
import 'View_flutter.dart';
import 'package:KDDockWidgetsBindings/Bindings.dart' as KDDockWidgetBindings;

class Separator_flutter extends View_flutter {
  late final KDDockWidgetBindings.Separator m_controller;
  late final KDDockWidgetBindings.View_flutter m_parent;

  Separator_flutter(KDDockWidgetBindings.Separator? separator,
      {required KDDockWidgetBindings.View? parent})
      : super(separator, KDDockWidgetBindings.KDDockWidgets_Type.Separator,
            parent) {
    m_controller = separator!;
    m_color = Colors.blueGrey;
    debugName = "Separator";
    print("Separator_flutter CTOR");

    m_parent = KDDockWidgetBindings.View_flutter.fromCache(parent!.thisCpp);
    m_parent.onChildAdded(this);
  }

  Widget createFlutterWidget() {
    return SeparatorWidget(kddwView, this, key: widgetKey);
  }
}

class SeparatorWidget extends PositionedWidget {
  final Separator_flutter separatorView;
  SeparatorWidget(var kddwView, this.separatorView, {Key? key})
      : super(kddwView, key: key);

  @override
  State<PositionedWidget> createState() {
    return SeparatorPositionedWidgetState(kddwView, separatorView);
  }
}

class SeparatorPositionedWidgetState extends PositionedWidgetState {
  final Separator_flutter separatorView;

  SeparatorPositionedWidgetState(var kddwView, this.separatorView)
      : super(kddwView);

  @override
  Widget buildContents() {
    // This simply wraps the default widget into a MouseRegion, so we can
    // react to mouse events
    final defaultContainer = super.buildContents();
    return Listener(
      onPointerDown: (event) {
        separatorView.m_controller.onMousePress();
      },
      onPointerUp: (event) {
        separatorView.m_controller.onMouseReleased();
      },
      onPointerMove: (event) {
        if (event.buttons != kPrimaryButton) return;

        final renderBox = (separatorView.m_parent as View_flutter)
            .widgetKey
            .currentContext
            ?.findRenderObject() as RenderBox;

        // The event is in coord space of the Separator. KDDW needs the position in
        // the coord space of the DropArea (m_parent) instead:

        var trans = renderBox.getTransformTo(null); // local to global
        trans.invert(); // global to local
        final localPos = event.transformed(trans).localPosition;

        separatorView.m_controller.onMouseMove(
            KDDockWidgetBindings.QPoint.ctor2(
                localPos.dx.toInt(), localPos.dy.toInt()));
      },
      child: MouseRegion(
          child: defaultContainer,
          cursor: separatorView.m_controller.isVertical()
              ? SystemMouseCursors.resizeDown
              : SystemMouseCursors.resizeLeft),
    );
  }
}
