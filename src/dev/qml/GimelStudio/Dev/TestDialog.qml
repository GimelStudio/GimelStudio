import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

GSDialog {
    id: root
    title: qsTr("Test Dialog")
    width: 400
    height: 300

    GSButton {
        anchors.centerIn: parent
        iconCode: IconCode.XOctagon
        text: qsTr("Close")
        onClicked: root.close()
    }
}
