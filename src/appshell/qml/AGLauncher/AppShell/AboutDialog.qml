import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.UiComponents 0.1

GSDialog {
    id: root
    width: 400
    height: 150
    title: qsTr("About")

    contentItem: GSDialogBackground {
        ColumnLayout {
            anchors.fill: parent

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: root.width - (anchors.margins * 2)
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                font.family: "Inter"
                text: qsTr("GS Launcher")
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: root.width - (anchors.margins * 2)
                horizontalAlignment: Text.AlignHCenter
                font.family: "Inter"
                text: qsTr("A minimalistic app and game launcher targetting arcade machine controls.")
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                Layout.maximumWidth: root.width - (anchors.margins * 2)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.family: "Inter"
                text: qsTr("GS Launcher is released under the GNU General Public License version 3.")
            }
        }
    }
}
