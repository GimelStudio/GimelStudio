import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    GSFlickable {
        anchors.fill: parent
        contentWidth: mainLayout.width
        contentHeight: mainLayout.height 

        Column {
            id: mainLayout
            spacing: 32

            width: root.width

            GSLabel {
                text: qsTr("Labels (GSLabel)")
            }

            GSLabel {
                text: qsTr("Label")
            }

            GSLabel {
                text: qsTr("Buttons (GSButton)")
            }

            Column {
                spacing: 8
                GSButton {
                    text: qsTr("Button")
                }

                GSButton {
                    iconPos: GSButton.IconPos.Right
                    text: qsTr("Button")
                }

                GSButton {
                    iconPos: GSButton.IconPos.Top
                    text: qsTr("Button")
                }

                GSButton {
                    iconPos: GSButton.IconPos.Bottom
                    text: qsTr("Button")
                }
            }
        }
    }
}
