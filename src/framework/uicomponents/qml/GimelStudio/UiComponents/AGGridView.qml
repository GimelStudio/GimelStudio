import QtQuick 2.15
import QtQuick.Controls 2.15

import GimelStudio.Ui 0.1
import GimelStudio.UiComponents 0.1

GridView {
    id: root

    clip: true
    boundsBehavior: Flickable.StopAtBounds

    ScrollBar.horizontal: GSScrollBar {}
    ScrollBar.vertical: GSScrollBar {}
}
