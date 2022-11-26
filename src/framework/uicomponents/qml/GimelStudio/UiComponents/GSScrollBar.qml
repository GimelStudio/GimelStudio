import QtQuick 2.15
import QtQuick.Controls 2.15

import GimelStudio.Ui 1.0

ScrollBar {
    id: root

    property int thickness: 4

    visible: size > 0 && size < 1

    contentItem: Rectangle {
        implicitWidth: root.thickness
        radius: root.width / 2
        color: UiTheme.componentColor
    }
}
