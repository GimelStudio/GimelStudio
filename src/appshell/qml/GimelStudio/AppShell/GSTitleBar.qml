import QtQuick 2.15

import "qrc:/kddockwidgets/qtquick/views/qml/" as KDDW

KDDW.TitleBarBase {
    id: root
    color:  "black"
    border.color: "orange"
    border.width: 2
    heightWhenVisible: 50

    Text {
        color: isFocused ? "cyan" : "orange"
        font.bold: isFocused
        text: root.title
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: root.verticalCenter
        }
    }

    Rectangle {
        id: closeButton
        enabled: root.closeButtonEnabled
        radius: 5
        color: isFocused ? "cyan" : "green"
        height: root.height - 20
        width: height
        anchors {
            right: root.right
            rightMargin: 10
            verticalCenter: root.verticalCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.closeButtonClicked();
            }
        }
    }
}