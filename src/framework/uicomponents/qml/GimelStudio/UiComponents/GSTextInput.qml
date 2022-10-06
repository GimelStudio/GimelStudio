import QtQuick 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    implicitWidth: 174
    implicitHeight: 30

    property string placeholderText: ""
    property alias text: textInput.text

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

    GSLabel {
        anchors {
            fill: parent
            leftMargin: 16
            rightMargin: 16
            verticalCenter: parent.verticalCenter
        }

        color: UiTheme.fontSecondaryColor
        elide: Text.ElideRight
        text: root.placeholderText
        visible: root.placeholderText != "" && root.text.length === 0
    }

    TextInput {
        id: textInput

        anchors.fill: parent
        
        leftPadding: 16
        rightPadding: 16
        topPadding: 6
        bottomPadding: 6

        horizontalAlignment: TextInput.AlignLeft
        verticalAlignment: TextInput.AlignVCenter

        font: UiTheme.bodyFont
    }
}
