import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    enum IconPos {
        Top,
        Bottom,
        Left,
        Right
    }

    property int paddingX: 32
    property int paddingY: 6
    property int spacingX: 8
    property int spacingY: 4

    property int iconPos: GSButton.IconPos.Left
    property bool isHorizontal: root.iconPos === GSButton.IconPos.Left || root.iconPos === GSButton.IconPos.Right
    property bool isVertical: root.iconPos === GSButton.IconPos.Top || root.iconPos === GSButton.IconPos.Bottom

    property int iconCode: IconCode.None
    property bool showText: true

    // TODO: Should these properties be prefixed with "is"?
    property bool flat: false
    property bool accented: false

    property string text: ""

    signal clicked

    // Minimum width: 102
    implicitWidth: content.width + (root.paddingX * 2)
    // Minimum height: 30
    implicitHeight: content.height + (root.paddingY * 2)

    Rectangle {
        id: background

        anchors.fill: root
        color: {
            if (root.accented) {
                return UiTheme.accentColor
            } else if (root.flat) {
                return UiTheme.buttonColor
            } else {
                return UiTheme.buttonColor
            }
        }

        opacity: {
            if (root.flat) {
                return 0
            } else {
                return 1
            }
        }

        radius: 4

        states: [
            State {
                name: "HOVERED"
                when: mouseArea.containsMouse && !mouseArea.pressed

                // TODO: May want to chagne the color as well
                PropertyChanges {
                    target: background
                    opacity: {
                        if (root.flat) {
                            return 0.2
                        } else {
                            return 0.8
                        }
                    }
                }
            },

            State {
                name: "PRESSED"
                when: mouseArea.pressed

                // TODO: May want to chagne the color as well
                PropertyChanges {
                    target: background
                    opacity: {
                        if (root.flat) {
                            return 0.4
                        } else {
                            return 0.6
                        }
                    }
                }
            }
        ]
    }

    Loader {
        id: content
        anchors.centerIn: root

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
            id: rowContentLayout

            spacing: root.spacingX

            Loader {
                active: root.iconPos === GSButton.IconPos.Left && root.iconCode !== IconCode.None
                anchors.verticalCenter: rowContentLayout.verticalCenter
                sourceComponent: iconComponent
            }

            Loader {
                anchors.verticalCenter: rowContentLayout.verticalCenter
                sourceComponent: labelComponent
            }

            Loader {
                active: root.iconPos === GSButton.IconPos.Right && root.iconCode !== IconCode.None
                anchors.verticalCenter: rowContentLayout.verticalCenter
                sourceComponent: iconComponent
            }
        }
    }

    Component {
        id: columnContentComponent

        Column {
            id: columnContentLayout

            spacing: root.spacingY

            Loader {
                active: root.iconPos === GSButton.IconPos.Top && root.iconCode !== IconCode.None
                anchors.horizontalCenter: columnContentLayout.horizontalCenter
                sourceComponent: iconComponent
            }

            Loader {
                anchors.horizontalCenter: columnContentLayout.horizontalCenter
                sourceComponent: labelComponent
            }

            Loader {
                active: root.iconPos === GSButton.IconPos.Bottom && root.iconCode !== IconCode.None
                anchors.horizontalCenter: columnContentLayout.horizontalCenter
                sourceComponent: iconComponent
            }
        }
    }

    Component {
        id: iconComponent

        GSIconLabel {
            iconCode: root.iconCode
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
                implicitHeight: UiTheme.defaultButtonSize.y
            } 
        },

        State {
            name: "VERTICAL"
            when: root.isVertical

            PropertyChanges {
                target: root
                implicitWidth: UiTheme.defaultButtonSize.x
            }
        }
    ]

    MouseArea {
        id: mouseArea
        anchors.fill: root

        hoverEnabled: true
        onClicked: root.clicked()
    }
}
