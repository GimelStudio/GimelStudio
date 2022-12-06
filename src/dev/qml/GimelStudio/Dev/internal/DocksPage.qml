import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Dev 1.0
import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

import com.kdab.dockwidgets 2.0 as KDDW

Item {
    id: root

    KDDW.DockingArea {
        anchors.fill: parent
        uniqueName: "docksPageLayout"

        TestDock {
            id: testDock
        }

        TestDock {
            id: testDock2
            uniqueName: "testDock2"
        }

        Component.onCompleted: {
            addDockWidget(testDock, KDDW.KDDockWidgets.Location_OnLeft);
            addDockWidget(testDock2, KDDW.KDDockWidgets.Location_OnLeft);
        }
    }
}
