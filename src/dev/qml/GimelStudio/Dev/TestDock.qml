import QtQuick 2.15

import GimelStudio.Ui 1.0

import com.kdab.dockwidgets 2.0 as KDDW

KDDW.DockWidget {
    id: root
    uniqueName: "testDock"
    
    Rectangle {
        id: background
        anchors.fill: parent
        color: UiTheme.backgroundSecondaryColor
    }
}
