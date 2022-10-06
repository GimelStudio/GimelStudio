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
        Bottom,
        Left,
        Right
    }

    property int defaultSizeX: 102
    property int defaultSizeY: 30

    property int paddingX: 32
    property int paddingY: 6
    property int spacingX: 8
    property int spacingY: 4

    property int iconPos: GSButton.IconPos.Left
    property bool isHorizontal: root.iconPos === GSButton.IconPos.Left || root.iconPos === GSButton.IconPos.Right
    property bool isVertical: root.iconPos === GSButton.IconPos.Top || root.iconPos === GSButton.IconPos.Bottom

    property bool showIcon: false
    property bool showText: true

    // TODO: Should these properties be prefixed with "is"?
    property bool flat: false
    property bool accented: true

    property string text: ""

    Rectangle {
        id: background

        anchors.fill: parent
        color: UiTheme.buttonColor
        opacity: 1
        radius: 4

        states: [
            State {
                name: "HOVERED"
                when: mouseArea.containsMouse && !mouseArea.pressed

                // TODO: May want to chagne the color as well
                PropertyChanges {
                    target: background
                    opacity: 0.8
                }
            },

            State {
                name: "PRESSED"
                when: mouseArea.pressed

                // TODO: May want to chagne the color as well
                PropertyChanges {
                    target: background
                    opacity: 0.5
                }
            }
        ]
    }

    Loader {
        id: content
        anchors.centerIn: parent

        sourceComponent: {
            if (root.isHorizontal) {
                return rowContentComponent
            } else if (root.isVertical) {
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
                active: root.iconPos === GSButton.IconPos.Top
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: iconComponent
            }

            Loader {
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: labelComponent
            }

            Loader {
                active: root.iconPos === GSButton.IconPos.Bottom
                anchors.horizontalCenter: parent.horizontalCenter
                sourceComponent: iconComponent
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

    states: [
        State {
            name: "HORIZONTAL"
            when: root.isHorizontal

            PropertyChanges {
                target: root
                implicitHeight: root.defaultSizeY
            } 
        },

        State {
            name: "VERTICAL"
            when: root.isVertical

            PropertyChanges {
                target: root
                implicitWidth: root.defaultSizeX
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        hoverEnabled: true
        onClicked: root.clicked()
    }
}
