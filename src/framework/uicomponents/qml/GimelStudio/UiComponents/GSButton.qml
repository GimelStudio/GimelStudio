import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    signal clicked

    // Minimum width: 102
    implicitWidth: content.width + (root.paddingX * 2)
    // Minimum height: 30
    implicitHeight: content.height + (root.paddingY * 2)

    enum IconPos {
        Top,
        Left,
        Right
    }

    property int paddingX: 32
    property int paddingY: 6
    property int spacingX: 8
    property int spacingY: 8

    property int iconPos: GSButton.IconPos.Left
    property bool showIcon: false
    property bool showText: true

    property string text: ""

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 4
        color: UiTheme.buttonColor
    }

    Loader {
        id: content
        anchors.centerIn: parent

        sourceComponent: {
            if (root.iconPos === GSButton.IconPos.Left || root.iconPos === GSButton.IconPos.Right) {
                return rowContentComponent
            } else if (root.iconPos === GSButton.IconPos.Top) {
                return columnContentComponent
            } else {
                return rowContentComponent
            }
        }
    }

    Component {
        id: rowContentComponent

        Row {
            spacing: root.spacingX

            Loader {
                active: root.iconPos === GSButton.IconPos.Left
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: iconComponent
            }

            Loader {
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: labelComponent
            }

            Loader {
                active: root.iconPos === GSButton.IconPos.Right
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: iconComponent
            }
        }
    }

    Component {
        id: columnContentComponent

        Column {
            spacing: root.spacingY

            Loader {
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: iconComponent
            }

            Loader {
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: labelComponent
            }
        }
    }

    Component {
        id: iconComponent

        GSIconLabel {
            text: "+"
        }
    }

    Component {
        id: labelComponent

        GSLabel {
            text: root.text
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        onClicked: root.clicked()
    }
}
