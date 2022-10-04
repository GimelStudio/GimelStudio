import QtQuick 2.15
import QtQuick.Controls 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Flickable {
    id: root

    clip: true
    boundsBehavior: Flickable.StopAtBounds

    ScrollBar.horizontal: GSScrollBar {}
    ScrollBar.vertical: GSScrollBar {}
}
