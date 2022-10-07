import QtQuick 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    implicitWidth: UiTheme.defaultComponentSize.x
    implicitHeight: UiTheme.defaultComponentSize.y

    property string placeholderText: ""
    property alias text: textInput.text
    property int iconCode: IconCode.None

    Rectangle {
        id: background
        
        anchors.fill: parent
        
        border.width: 0
        color: UiTheme.componentColor
        
        radius: 4

        states: [
            State {
                name: "FOCUSED"
                when: textInput.activeFocus

                PropertyChanges {
                    target: background
                    border {
                        width: 2
                        color: UiTheme.focusColor
                    }
                }
            }
        ]
    }

    Row {
        spacing: 8

        anchors {
            fill: parent
            leftMargin: 16
            rightMargin: 16
            verticalCenter: parent.verticalCenter
        }

        GSIconLabel {
            id: iconLabel
            anchors.verticalCenter: parent.verticalCenter
            iconCode: root.iconCode
        }

        GSLabel {
            anchors.verticalCenter: parent.verticalCenter
            color: UiTheme.fontSecondaryColor
            elide: Text.ElideRight
            text: root.placeholderText
            visible: root.placeholderText != "" && root.text.length === 0
        }
    }

    TextInput {
        id: textInput

        anchors.fill: parent
        
        leftPadding: root.iconCode === IconCode.None ? 16 : iconLabel.x + iconLabel.width + 24
        rightPadding: 16
        topPadding: 6
        bottomPadding: 6

        horizontalAlignment: TextInput.AlignLeft
        verticalAlignment: TextInput.AlignVCenter

        font: UiTheme.bodyFont
    }
}
