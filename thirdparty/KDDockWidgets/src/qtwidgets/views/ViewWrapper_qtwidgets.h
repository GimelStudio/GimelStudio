/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#pragma once

#include "../../qtcommon/ViewWrapper.h"

#include <QWidget>
#include <QPointer>

namespace KDDockWidgets::Views {

/// @brief A View that doesn't own its QWidget
/// Implements a View API around an existing QWidget
/// Useful for widgets that are not created by KDDW.
class DOCKS_EXPORT ViewWrapper_qtwidgets : public ViewWrapper
{
public:
    QRect geometry() const override;
    void setGeometry(QRect) override;
    void move(int x, int y) override;
    QPoint mapToGlobal(QPoint) const override;
    QPoint mapFromGlobal(QPoint) const override;
    bool isRootView() const override;
    bool isVisible() const override;
    void setVisible(bool) override;
    void activateWindow() override;
    bool isMaximized() const override;
    bool isMinimized() const override;
    void setSize(int width, int height) override;
    bool is(Type) const override;
    std::shared_ptr<Window> window() const override;
    std::shared_ptr<View> rootView() const override;
    std::shared_ptr<View> parentView() const override;
    void setParent(View *) override;
    bool close() override;
    std::shared_ptr<View> childViewAt(QPoint localPos) const override;
    QVector<std::shared_ptr<View>> childViews() const override;
    void grabMouse() override;
    void releaseMouse() override;
    void setFocus(Qt::FocusReason) override;
    QString objectName() const override;
    QVariant property(const char *) const override;
    bool isNull() const override;
    void setWindowTitle(const QString &title) override;
    QPoint mapTo(View *, QPoint) const override;
    bool testAttribute(Qt::WidgetAttribute) const override;
    void setCursor(Qt::CursorShape) override;
    QSize minSize() const override;
    Qt::FocusPolicy focusPolicy() const override;
    void setFocusPolicy(Qt::FocusPolicy) override;
    bool hasFocus() const override;
    QSize maxSizeHint() const override;
    SizePolicy horizontalSizePolicy() const override;
    SizePolicy verticalSizePolicy() const override;
    QWidget *widget() const;

    static std::shared_ptr<View> create(QObject *widget);
    static std::shared_ptr<View> create(QWidget *widget);

private:
    explicit ViewWrapper_qtwidgets(QObject *widget);
    explicit ViewWrapper_qtwidgets(QWidget *widget);
    QPointer<QWidget> m_widget;
};

}
