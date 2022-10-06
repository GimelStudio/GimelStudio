import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: interactiveRoot

    GSLabel {
        text: qsTr("Interactive")
        anchors.centerIn: interactiveRoot
    }
}
