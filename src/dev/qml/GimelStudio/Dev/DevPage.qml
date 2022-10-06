import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

import "internal"

Item {
    id: root

    Row {
        id: tabRow

        anchors.horizontalCenter: root.horizontalCenter

        y: 16
        spacing: 8

        GSButton {
            text: qsTr("Component Demos")
            showIcon: false
            onClicked: tabContent.switchItem("Component Demos")
        }

        GSButton {
            text: qsTr("Interactive")
            showIcon: false
            onClicked: tabContent.switchItem("Interactive")
        }
    }

    GSStackLayout {
        id: tabContent

        anchors {
            fill: root
            leftMargin: 16
            rightMargin: 16
            topMargin: tabRow.y + tabRow.height + 16
            bottomMargin: 16
        }

        itemNames: ["Component Demos", "Interactive"]

        ComponentsPage {}

        InteractivePage {}
    }    
}
