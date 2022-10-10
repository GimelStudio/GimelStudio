import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    property alias tabs: tabBar.tabs

    ColumnLayout {
        id: tabContent
        anchors.fill: root
        spacing: 16
    
        GSTabBar {
            id: tabBar
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            stackLayout: stackLayout
        }

        GSStackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
