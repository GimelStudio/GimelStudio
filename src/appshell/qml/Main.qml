import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import GimelStudio.Dev 1.0
import GimelStudio.UiComponents 1.0

ApplicationWindow {
    id: root
    width: 800
    height: 600
    title: qsTr("Gimel Studio")
    visible: true

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: UiTheme.backgroundPrimaryColor
    }

    DevPage {
        id: devPage
        anchors.fill: parent
    }
}
