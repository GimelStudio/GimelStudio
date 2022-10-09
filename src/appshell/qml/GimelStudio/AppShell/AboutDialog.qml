import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.UiComponents 1.0

GSDialog {
    id: root
    width: 400
    height: 150
    title: qsTr("About")

    contentItem: GSDialogBackground {
        ColumnLayout {
            anchors.fill: parent

            GSLabel {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: root.width - (anchors.margins * 2)
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                text: qsTr("Gimel Studio")
            }

            GSLabel {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: root.width - (anchors.margins * 2)
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("A fully non-destructive image editor using a vector editor workflow.")
            }

            GSLabel {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: root.width - (anchors.margins * 2)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                text: qsTr("Gimel Studio is released under the GNU General Public License version 3.")
            }
        }
    }
}
