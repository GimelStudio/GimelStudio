/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sergio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

import QtQuick 2.6
import QtQuick.Controls 2.12
import com.kdab.dockwidgets 2.0 as KDDW

ApplicationWindow {
    visible: true
    width: 1000
    height: 1200

    KDDW.MDIDockingArea {
        id: dockingArea
        anchors.fill: parent
        uniqueName: "MyMainLayout"
    }

    KDDW.DockWidget {
        id: greenDock
        uniqueName: "greenDock"
        Rectangle {
            color: "green"
            anchors.fill: parent
        }
    }

    Component.onCompleted: {
        dockingArea.addDockWidget(greenDock, Qt.point(200, 200));
    }
}
