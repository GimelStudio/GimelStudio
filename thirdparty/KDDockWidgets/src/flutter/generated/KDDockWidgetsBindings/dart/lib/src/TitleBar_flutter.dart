/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/
import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'TypeHelpers.dart';
import '../Bindings.dart';
import '../FinalizerHelpers.dart';

var _dylib = Library.instance().dylib;

class TitleBar_flutter extends View_flutter {
  TitleBar_flutter.fromCppPointer(var cppPointer, [var needsAutoDelete = false])
      : super.fromCppPointer(cppPointer, needsAutoDelete) {}
  TitleBar_flutter.init() : super.init() {}
  factory TitleBar_flutter.fromCache(var cppPointer,
      [needsAutoDelete = false]) {
    if (View.isCached(cppPointer)) {
      var instance = View.s_dartInstanceByCppPtr[cppPointer.address];
      if (instance != null) return instance as TitleBar_flutter;
    }
    return TitleBar_flutter.fromCppPointer(cppPointer, needsAutoDelete);
  } //TitleBar_flutter(KDDockWidgets::Controllers::TitleBar * controller, KDDockWidgets::View * parent)
  TitleBar_flutter(TitleBar? controller, {required View? parent})
      : super.init() {
    final voidstar_Func_voidstar_voidstar func = _dylib
        .lookup<ffi.NativeFunction<voidstar_Func_voidstar_voidstar_FFI>>(
            'c_KDDockWidgets__Views__TitleBar_flutter__constructor_TitleBar_View')
        .asFunction();
    thisCpp = func(controller == null ? ffi.nullptr : controller.thisCpp,
        parent == null ? ffi.nullptr : parent.thisCpp);
    View.s_dartInstanceByCppPtr[thisCpp.address] = this;
    registerCallbacks();
  }
  static void activateWindow_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::activateWindow()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.activateWindow();
  }

  static int close_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::close()! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.close();
    return result ? 1 : 0;
  }

  static void createPlatformWindow_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::createPlatformWindow()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.createPlatformWindow();
  }

  static int flags_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::flags() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.flags();
    return result;
  }

  static void free_impl_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::free_impl()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.free_impl();
  }

  static ffi.Pointer<void> geometry_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::geometry() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.geometry();
    return result.thisCpp;
  }

  static void grabMouse_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::grabMouse()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.grabMouse();
  }

  static int hasFocus_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::hasFocus() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.hasFocus();
    return result ? 1 : 0;
  }

  static void hide_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::hide()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.hide();
  }

  static void init_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::init()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.init();
  }

  static int isActiveWindow_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isActiveWindow() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isActiveWindow();
    return result ? 1 : 0;
  } // isCloseButtonEnabled() const

  bool isCloseButtonEnabled() {
    final bool_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<bool_Func_voidstar_FFI>>(
            cFunctionSymbolName(1041))
        .asFunction();
    return func(thisCpp) != 0;
  }

  static int isCloseButtonEnabled_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isCloseButtonEnabled() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isCloseButtonEnabled();
    return result ? 1 : 0;
  } // isCloseButtonVisible() const

  bool isCloseButtonVisible() {
    final bool_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<bool_Func_voidstar_FFI>>(
            cFunctionSymbolName(1042))
        .asFunction();
    return func(thisCpp) != 0;
  }

  static int isCloseButtonVisible_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isCloseButtonVisible() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isCloseButtonVisible();
    return result ? 1 : 0;
  } // isFloatButtonVisible() const

  bool isFloatButtonVisible() {
    final bool_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<bool_Func_voidstar_FFI>>(
            cFunctionSymbolName(1043))
        .asFunction();
    return func(thisCpp) != 0;
  }

  static int isFloatButtonVisible_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isFloatButtonVisible() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isFloatButtonVisible();
    return result ? 1 : 0;
  }

  static int isMaximized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isMaximized() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isMaximized();
    return result ? 1 : 0;
  }

  static int isMinimized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isMinimized() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isMinimized();
    return result ? 1 : 0;
  }

  static int isNull_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isNull() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isNull();
    return result ? 1 : 0;
  }

  static int isRootView_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isRootView() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isRootView();
    return result ? 1 : 0;
  }

  static int isVisible_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::isVisible() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.isVisible();
    return result ? 1 : 0;
  }

  static ffi.Pointer<void> mapFromGlobal_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> globalPt) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::mapFromGlobal(QPoint globalPt) const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.mapFromGlobal(QPoint.fromCppPointer(globalPt));
    return result.thisCpp;
  }

  static ffi.Pointer<void> mapTo_calledFromC(ffi.Pointer<void> thisCpp,
      ffi.Pointer<void>? parent, ffi.Pointer<void> pos) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::mapTo(KDDockWidgets::View * parent, QPoint pos) const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.mapTo(
        View.fromCppPointer(parent), QPoint.fromCppPointer(pos));
    return result.thisCpp;
  }

  static ffi.Pointer<void> mapToGlobal_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> localPt) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::mapToGlobal(QPoint localPt) const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.mapToGlobal(QPoint.fromCppPointer(localPt));
    return result.thisCpp;
  }

  static ffi.Pointer<void> maxSizeHint_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::maxSizeHint() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.maxSizeHint();
    return result.thisCpp;
  }

  static ffi.Pointer<void> minSize_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::minSize() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.minSize();
    return result.thisCpp;
  }

  static int minimumHeight_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::minimumHeight() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.minimumHeight();
    return result;
  }

  static int minimumWidth_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::minimumWidth() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.minimumWidth();
    return result;
  }

  static void move_2_calledFromC(ffi.Pointer<void> thisCpp, int x, int y) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::move(int x, int y)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.move_2(x, y);
  }

  static ffi.Pointer<void> normalGeometry_calledFromC(
      ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::normalGeometry() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.normalGeometry();
    return result.thisCpp;
  }

  static ffi.Pointer<void> objectName_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::objectName() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.objectName();
    return result.thisCpp;
  }

  static void onChildAdded_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? childView) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::onChildAdded(KDDockWidgets::View * childView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onChildAdded(View.fromCppPointer(childView));
  }

  static void onChildRemoved_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? childView) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::onChildRemoved(KDDockWidgets::View * childView)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.onChildRemoved(View.fromCppPointer(childView));
  }

  static int onResize_2_calledFromC(ffi.Pointer<void> thisCpp, int w, int h) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::onResize(int w, int h)! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.onResize_2(w, h);
    return result ? 1 : 0;
  }

  static void raise_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::raise()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.raise();
  }

  static void raiseAndActivate_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::raiseAndActivate()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.raiseAndActivate();
  }

  static void releaseKeyboard_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::releaseKeyboard()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.releaseKeyboard();
  }

  static void releaseMouse_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::releaseMouse()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.releaseMouse();
  }

  static void setCursor_calledFromC(ffi.Pointer<void> thisCpp, int shape) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setCursor(Qt::CursorShape shape)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setCursor(shape);
  }

  static void setFixedHeight_calledFromC(ffi.Pointer<void> thisCpp, int h) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setFixedHeight(int h)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setFixedHeight(h);
  }

  static void setFixedWidth_calledFromC(ffi.Pointer<void> thisCpp, int w) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setFixedWidth(int w)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setFixedWidth(w);
  }

  static void setGeometry_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> geometry) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setGeometry(QRect geometry)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setGeometry(QRect.fromCppPointer(geometry));
  }

  static void setHeight_calledFromC(ffi.Pointer<void> thisCpp, int h) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setHeight(int h)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setHeight(h);
  }

  static void setMaximumSize_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> sz) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setMaximumSize(QSize sz)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setMaximumSize(QSize.fromCppPointer(sz));
  }

  static void setMinimumSize_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void> sz) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setMinimumSize(QSize sz)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setMinimumSize(QSize.fromCppPointer(sz));
  }

  static void setMouseTracking_calledFromC(
      ffi.Pointer<void> thisCpp, int enable) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setMouseTracking(bool enable)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setMouseTracking(enable != 0);
  }

  static void setObjectName_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? name) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setObjectName(const QString & name)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setObjectName(QString.fromCppPointer(name).toDartString());
  }

  static void setParent_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? parent) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setParent(KDDockWidgets::View * parent)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setParent(View.fromCppPointer(parent));
  }

  static void setSize_2_calledFromC(ffi.Pointer<void> thisCpp, int w, int h) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setSize(int w, int h)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setSize_2(w, h);
  }

  static void setVisible_calledFromC(ffi.Pointer<void> thisCpp, int visible) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setVisible(bool visible)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setVisible(visible != 0);
  }

  static void setWidth_calledFromC(ffi.Pointer<void> thisCpp, int w) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setWidth(int w)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setWidth(w);
  }

  static void setWindowOpacity_calledFromC(
      ffi.Pointer<void> thisCpp, double v) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setWindowOpacity(double v)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setWindowOpacity(v);
  }

  static void setWindowTitle_calledFromC(
      ffi.Pointer<void> thisCpp, ffi.Pointer<void>? title) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setWindowTitle(const QString & title)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setWindowTitle(QString.fromCppPointer(title).toDartString());
  }

  static void setZOrder_calledFromC(ffi.Pointer<void> thisCpp, int z) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::setZOrder(int z)! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.setZOrder(z);
  }

  static void show_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::show()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.show();
  }

  static void showMaximized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::showMaximized()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.showMaximized();
  }

  static void showMinimized_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::showMinimized()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.showMinimized();
  }

  static void showNormal_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::showNormal()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.showNormal();
  }

  static ffi.Pointer<void> sizeHint_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::sizeHint() const! (${thisCpp.address})");
      throw Error();
    }
    final result = dartInstance.sizeHint();
    return result.thisCpp;
  }

  static void update_calledFromC(ffi.Pointer<void> thisCpp) {
    var dartInstance =
        View.s_dartInstanceByCppPtr[thisCpp.address] as TitleBar_flutter;
    if (dartInstance == null) {
      print(
          "Dart instance not found for TitleBar_flutter::update()! (${thisCpp.address})");
      throw Error();
    }
    dartInstance.update();
  }

  void release() {
    final void_Func_voidstar func = _dylib
        .lookup<ffi.NativeFunction<void_Func_voidstar_FFI>>(
            'c_KDDockWidgets__Views__TitleBar_flutter__destructor')
        .asFunction();
    func(thisCpp);
  }

  String cFunctionSymbolName(int methodId) {
    switch (methodId) {
      case 906:
        return "c_KDDockWidgets__Views__TitleBar_flutter__activateWindow";
      case 917:
        return "c_KDDockWidgets__Views__TitleBar_flutter__close";
      case 920:
        return "c_KDDockWidgets__Views__TitleBar_flutter__createPlatformWindow";
      case 925:
        return "c_KDDockWidgets__Views__TitleBar_flutter__flags";
      case 927:
        return "c_KDDockWidgets__Views__TitleBar_flutter__free_impl";
      case 929:
        return "c_KDDockWidgets__Views__TitleBar_flutter__geometry";
      case 931:
        return "c_KDDockWidgets__Views__TitleBar_flutter__grabMouse";
      case 934:
        return "c_KDDockWidgets__Views__TitleBar_flutter__hasFocus";
      case 936:
        return "c_KDDockWidgets__Views__TitleBar_flutter__hide";
      case 939:
        return "c_KDDockWidgets__Views__TitleBar_flutter__init";
      case 941:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isActiveWindow";
      case 1041:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isCloseButtonEnabled";
      case 1042:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isCloseButtonVisible";
      case 1043:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isFloatButtonVisible";
      case 942:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isMaximized";
      case 943:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isMinimized";
      case 944:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isNull";
      case 945:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isRootView";
      case 946:
        return "c_KDDockWidgets__Views__TitleBar_flutter__isVisible";
      case 947:
        return "c_KDDockWidgets__Views__TitleBar_flutter__mapFromGlobal_QPoint";
      case 948:
        return "c_KDDockWidgets__Views__TitleBar_flutter__mapTo_View_QPoint";
      case 949:
        return "c_KDDockWidgets__Views__TitleBar_flutter__mapToGlobal_QPoint";
      case 950:
        return "c_KDDockWidgets__Views__TitleBar_flutter__maxSizeHint";
      case 951:
        return "c_KDDockWidgets__Views__TitleBar_flutter__minSize";
      case 952:
        return "c_KDDockWidgets__Views__TitleBar_flutter__minimumHeight";
      case 953:
        return "c_KDDockWidgets__Views__TitleBar_flutter__minimumWidth";
      case 955:
        return "c_KDDockWidgets__Views__TitleBar_flutter__move_int_int";
      case 956:
        return "c_KDDockWidgets__Views__TitleBar_flutter__normalGeometry";
      case 957:
        return "c_KDDockWidgets__Views__TitleBar_flutter__objectName";
      case 1024:
        return "c_KDDockWidgets__Views__TitleBar_flutter__onChildAdded_View";
      case 1025:
        return "c_KDDockWidgets__Views__TitleBar_flutter__onChildRemoved_View";
      case 959:
        return "c_KDDockWidgets__Views__TitleBar_flutter__onResize_int_int";
      case 962:
        return "c_KDDockWidgets__Views__TitleBar_flutter__raise";
      case 963:
        return "c_KDDockWidgets__Views__TitleBar_flutter__raiseAndActivate";
      case 965:
        return "c_KDDockWidgets__Views__TitleBar_flutter__releaseKeyboard";
      case 966:
        return "c_KDDockWidgets__Views__TitleBar_flutter__releaseMouse";
      case 970:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setCursor_CursorShape";
      case 971:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setFixedHeight_int";
      case 972:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setFixedWidth_int";
      case 973:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setGeometry_QRect";
      case 974:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setHeight_int";
      case 975:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setMaximumSize_QSize";
      case 976:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setMinimumSize_QSize";
      case 977:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setMouseTracking_bool";
      case 978:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setObjectName_QString";
      case 979:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setParent_View";
      case 981:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setSize_int_int";
      case 982:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setVisible_bool";
      case 983:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setWidth_int";
      case 984:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setWindowOpacity_double";
      case 985:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setWindowTitle_QString";
      case 986:
        return "c_KDDockWidgets__Views__TitleBar_flutter__setZOrder_int";
      case 987:
        return "c_KDDockWidgets__Views__TitleBar_flutter__show";
      case 988:
        return "c_KDDockWidgets__Views__TitleBar_flutter__showMaximized";
      case 989:
        return "c_KDDockWidgets__Views__TitleBar_flutter__showMinimized";
      case 990:
        return "c_KDDockWidgets__Views__TitleBar_flutter__showNormal";
      case 992:
        return "c_KDDockWidgets__Views__TitleBar_flutter__sizeHint";
      case 994:
        return "c_KDDockWidgets__Views__TitleBar_flutter__update";
    }
    return super.cFunctionSymbolName(methodId);
  }

  static String methodNameFromId(int methodId) {
    switch (methodId) {
      case 906:
        return "activateWindow";
      case 917:
        return "close";
      case 920:
        return "createPlatformWindow";
      case 925:
        return "flags";
      case 927:
        return "free_impl";
      case 929:
        return "geometry";
      case 931:
        return "grabMouse";
      case 934:
        return "hasFocus";
      case 936:
        return "hide";
      case 939:
        return "init";
      case 941:
        return "isActiveWindow";
      case 1041:
        return "isCloseButtonEnabled";
      case 1042:
        return "isCloseButtonVisible";
      case 1043:
        return "isFloatButtonVisible";
      case 942:
        return "isMaximized";
      case 943:
        return "isMinimized";
      case 944:
        return "isNull";
      case 945:
        return "isRootView";
      case 946:
        return "isVisible";
      case 947:
        return "mapFromGlobal";
      case 948:
        return "mapTo";
      case 949:
        return "mapToGlobal";
      case 950:
        return "maxSizeHint";
      case 951:
        return "minSize";
      case 952:
        return "minimumHeight";
      case 953:
        return "minimumWidth";
      case 955:
        return "move_2";
      case 956:
        return "normalGeometry";
      case 957:
        return "objectName";
      case 1024:
        return "onChildAdded";
      case 1025:
        return "onChildRemoved";
      case 959:
        return "onResize_2";
      case 962:
        return "raise";
      case 963:
        return "raiseAndActivate";
      case 965:
        return "releaseKeyboard";
      case 966:
        return "releaseMouse";
      case 970:
        return "setCursor";
      case 971:
        return "setFixedHeight";
      case 972:
        return "setFixedWidth";
      case 973:
        return "setGeometry";
      case 974:
        return "setHeight";
      case 975:
        return "setMaximumSize";
      case 976:
        return "setMinimumSize";
      case 977:
        return "setMouseTracking";
      case 978:
        return "setObjectName";
      case 979:
        return "setParent";
      case 981:
        return "setSize_2";
      case 982:
        return "setVisible";
      case 983:
        return "setWidth";
      case 984:
        return "setWindowOpacity";
      case 985:
        return "setWindowTitle";
      case 986:
        return "setZOrder";
      case 987:
        return "show";
      case 988:
        return "showMaximized";
      case 989:
        return "showMinimized";
      case 990:
        return "showNormal";
      case 992:
        return "sizeHint";
      case 994:
        return "update";
    }
    throw Error();
  }

  void registerCallbacks() {
    assert(thisCpp != null);
    final RegisterMethodIsReimplementedCallback registerCallback = _dylib
        .lookup<ffi.NativeFunction<RegisterMethodIsReimplementedCallback_FFI>>(
            'c_KDDockWidgets__Views__TitleBar_flutter__registerVirtualMethodCallback')
        .asFunction();
    final callback906 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.activateWindow_calledFromC);
    registerCallback(thisCpp, callback906, 906);
    const callbackExcept917 = 0;
    final callback917 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.close_calledFromC, callbackExcept917);
    registerCallback(thisCpp, callback917, 917);
    final callback920 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View.createPlatformWindow_calledFromC);
    registerCallback(thisCpp, callback920, 920);
    const callbackExcept925 = 0;
    final callback925 = ffi.Pointer.fromFunction<int_Func_voidstar_FFI>(
        View_flutter.flags_calledFromC, callbackExcept925);
    registerCallback(thisCpp, callback925, 925);
    final callback927 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.free_impl_calledFromC);
    registerCallback(thisCpp, callback927, 927);
    final callback929 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        View_flutter.geometry_calledFromC);
    registerCallback(thisCpp, callback929, 929);
    final callback931 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.grabMouse_calledFromC);
    registerCallback(thisCpp, callback931, 931);
    const callbackExcept934 = 0;
    final callback934 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.hasFocus_calledFromC, callbackExcept934);
    registerCallback(thisCpp, callback934, 934);
    final callback936 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.hide_calledFromC);
    registerCallback(thisCpp, callback936, 936);
    final callback939 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        TitleBar_flutter.init_calledFromC);
    registerCallback(thisCpp, callback939, 939);
    const callbackExcept941 = 0;
    final callback941 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.isActiveWindow_calledFromC, callbackExcept941);
    registerCallback(thisCpp, callback941, 941);
    const callbackExcept1041 = 0;
    final callback1041 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        TitleBar_flutter.isCloseButtonEnabled_calledFromC, callbackExcept1041);
    registerCallback(thisCpp, callback1041, 1041);
    const callbackExcept1042 = 0;
    final callback1042 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        TitleBar_flutter.isCloseButtonVisible_calledFromC, callbackExcept1042);
    registerCallback(thisCpp, callback1042, 1042);
    const callbackExcept1043 = 0;
    final callback1043 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        TitleBar_flutter.isFloatButtonVisible_calledFromC, callbackExcept1043);
    registerCallback(thisCpp, callback1043, 1043);
    const callbackExcept942 = 0;
    final callback942 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.isMaximized_calledFromC, callbackExcept942);
    registerCallback(thisCpp, callback942, 942);
    const callbackExcept943 = 0;
    final callback943 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.isMinimized_calledFromC, callbackExcept943);
    registerCallback(thisCpp, callback943, 943);
    const callbackExcept944 = 0;
    final callback944 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View.isNull_calledFromC, callbackExcept944);
    registerCallback(thisCpp, callback944, 944);
    const callbackExcept945 = 0;
    final callback945 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.isRootView_calledFromC, callbackExcept945);
    registerCallback(thisCpp, callback945, 945);
    const callbackExcept946 = 0;
    final callback946 = ffi.Pointer.fromFunction<bool_Func_voidstar_FFI>(
        View_flutter.isVisible_calledFromC, callbackExcept946);
    registerCallback(thisCpp, callback946, 946);
    final callback947 =
        ffi.Pointer.fromFunction<voidstar_Func_voidstar_voidstar_FFI>(
            View_flutter.mapFromGlobal_calledFromC);
    registerCallback(thisCpp, callback947, 947);
    final callback948 =
        ffi.Pointer.fromFunction<voidstar_Func_voidstar_voidstar_voidstar_FFI>(
            View_flutter.mapTo_calledFromC);
    registerCallback(thisCpp, callback948, 948);
    final callback949 =
        ffi.Pointer.fromFunction<voidstar_Func_voidstar_voidstar_FFI>(
            View_flutter.mapToGlobal_calledFromC);
    registerCallback(thisCpp, callback949, 949);
    final callback950 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        View_flutter.maxSizeHint_calledFromC);
    registerCallback(thisCpp, callback950, 950);
    final callback951 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        View_flutter.minSize_calledFromC);
    registerCallback(thisCpp, callback951, 951);
    const callbackExcept952 = 0;
    final callback952 = ffi.Pointer.fromFunction<int_Func_voidstar_FFI>(
        View.minimumHeight_calledFromC, callbackExcept952);
    registerCallback(thisCpp, callback952, 952);
    const callbackExcept953 = 0;
    final callback953 = ffi.Pointer.fromFunction<int_Func_voidstar_FFI>(
        View.minimumWidth_calledFromC, callbackExcept953);
    registerCallback(thisCpp, callback953, 953);
    final callback955 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_ffi_Int32_FFI>(
            View_flutter.move_2_calledFromC);
    registerCallback(thisCpp, callback955, 955);
    final callback956 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        View_flutter.normalGeometry_calledFromC);
    registerCallback(thisCpp, callback956, 956);
    final callback957 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        View_flutter.objectName_calledFromC);
    registerCallback(thisCpp, callback957, 957);
    final callback1024 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.onChildAdded_calledFromC);
    registerCallback(thisCpp, callback1024, 1024);
    final callback1025 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.onChildRemoved_calledFromC);
    registerCallback(thisCpp, callback1025, 1025);
    const callbackExcept959 = 0;
    final callback959 =
        ffi.Pointer.fromFunction<bool_Func_voidstar_ffi_Int32_ffi_Int32_FFI>(
            View_flutter.onResize_2_calledFromC, callbackExcept959);
    registerCallback(thisCpp, callback959, 959);
    final callback962 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.raise_calledFromC);
    registerCallback(thisCpp, callback962, 962);
    final callback963 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.raiseAndActivate_calledFromC);
    registerCallback(thisCpp, callback963, 963);
    final callback965 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.releaseKeyboard_calledFromC);
    registerCallback(thisCpp, callback965, 965);
    final callback966 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.releaseMouse_calledFromC);
    registerCallback(thisCpp, callback966, 966);
    final callback970 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            View_flutter.setCursor_calledFromC);
    registerCallback(thisCpp, callback970, 970);
    final callback971 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            View_flutter.setFixedHeight_calledFromC);
    registerCallback(thisCpp, callback971, 971);
    final callback972 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            View_flutter.setFixedWidth_calledFromC);
    registerCallback(thisCpp, callback972, 972);
    final callback973 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.setGeometry_calledFromC);
    registerCallback(thisCpp, callback973, 973);
    final callback974 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            View_flutter.setHeight_calledFromC);
    registerCallback(thisCpp, callback974, 974);
    final callback975 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.setMaximumSize_calledFromC);
    registerCallback(thisCpp, callback975, 975);
    final callback976 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.setMinimumSize_calledFromC);
    registerCallback(thisCpp, callback976, 976);
    final callback977 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int8_FFI>(
            View_flutter.setMouseTracking_calledFromC);
    registerCallback(thisCpp, callback977, 977);
    final callback978 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.setObjectName_calledFromC);
    registerCallback(thisCpp, callback978, 978);
    final callback979 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.setParent_calledFromC);
    registerCallback(thisCpp, callback979, 979);
    final callback981 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_ffi_Int32_FFI>(
            View_flutter.setSize_2_calledFromC);
    registerCallback(thisCpp, callback981, 981);
    final callback982 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int8_FFI>(
            View_flutter.setVisible_calledFromC);
    registerCallback(thisCpp, callback982, 982);
    final callback983 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            View_flutter.setWidth_calledFromC);
    registerCallback(thisCpp, callback983, 983);
    final callback984 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Double_FFI>(
            View_flutter.setWindowOpacity_calledFromC);
    registerCallback(thisCpp, callback984, 984);
    final callback985 =
        ffi.Pointer.fromFunction<void_Func_voidstar_voidstar_FFI>(
            View_flutter.setWindowTitle_calledFromC);
    registerCallback(thisCpp, callback985, 985);
    final callback986 =
        ffi.Pointer.fromFunction<void_Func_voidstar_ffi_Int32_FFI>(
            View_flutter.setZOrder_calledFromC);
    registerCallback(thisCpp, callback986, 986);
    final callback987 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.show_calledFromC);
    registerCallback(thisCpp, callback987, 987);
    final callback988 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.showMaximized_calledFromC);
    registerCallback(thisCpp, callback988, 988);
    final callback989 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.showMinimized_calledFromC);
    registerCallback(thisCpp, callback989, 989);
    final callback990 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.showNormal_calledFromC);
    registerCallback(thisCpp, callback990, 990);
    final callback992 = ffi.Pointer.fromFunction<voidstar_Func_voidstar_FFI>(
        View_flutter.sizeHint_calledFromC);
    registerCallback(thisCpp, callback992, 992);
    final callback994 = ffi.Pointer.fromFunction<void_Func_voidstar_FFI>(
        View_flutter.update_calledFromC);
    registerCallback(thisCpp, callback994, 994);
  }
}
