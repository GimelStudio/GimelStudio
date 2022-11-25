import QtQuick 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

GSLabel {
    id: root

    font: UiTheme.iconFont

    property int iconCode: IconCode.None
    readonly property bool isEmpty: iconCode === IconCode.NONE

    text: !isEmpty ? String.fromCharCode(root.iconCode) : ""
}
