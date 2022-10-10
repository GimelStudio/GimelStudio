import QtQuick 2.15
import QtQuick.Controls 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0


// TODO:
//     - Code cleanup
//     - Update design for flat tabs
//     - Create design for non-flat tabs
//     - Fix the label font sizes
Item {
    id: root

    signal clicked

    implicitWidth: {
        var w = contentRow.width + (root.paddingX * 2)
        if (w <= UiTheme.defaultButtonSize.x) {
            return UiTheme.defaultButtonSize.x
        } else {
            return w
        }
    }
    implicitHeight: UiTheme.defaultButtonSize.y

    // Read only as a design for non-flat tabs has been done yet
    readonly property bool flat: true
    property bool isCurrent: false
    property alias iconCode: iconLabel.iconCode
    property int paddingX: 16
    property alias text: label.text

    Rectangle {
        id: background
        anchors.fill: root
        color: {
            if (root.isCurrent) {
                return UiTheme.backgroundSecondaryColor
            } else {
                return UiTheme.backgroundPrimaryColor
            }
        }

        opacity: {
            if (root.flat) {
                return 0
            } else {
                return 1
            }
        }
    }

    Rectangle {
        id: accentLine
        anchors.bottom: root.bottom
        visible: root.flat && root.isCurrent
        
        width: root.width
        height: 2
        
        radius: height / 2
        
        color: UiTheme.accentColor
    }

    Row {
        id: contentRow
        anchors.centerIn: root

        spacing: 8
    
        GSIconLabel {
            id: iconLabel
        }

        GSLabel {
            id: label

            font.bold: root.isCurrent
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: root

        hoverEnabled: true
        onClicked: root.clicked()
    }
}
