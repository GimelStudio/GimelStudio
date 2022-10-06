import QtQuick 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    implicitWidth: 102
    implicitHeight: 30

    Rectangle {
        id: background
        anchors.fill: parent
        color: UiTheme.componentColor
        radius: 4
    }

    TextInput {
        id: textInput

        anchors.fill: parent

        horizontalAlignment: TextInput.AlignLeft
        verticalAlignment: TextInput.AlignVCenter

        leftPadding: 16
        rightPadding: 8
        topPadding: 6
        bottomPadding: 6
    }
}
