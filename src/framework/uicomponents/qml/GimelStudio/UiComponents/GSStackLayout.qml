import QtQuick 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0

StackLayout {
    id: root

    property var pageNames: []

    function switchPage(pageName) {
        // TODO: Add a check to see if the page exists in the pageNames array
        root.currentIndex = root.pageNames.indexOf(pageName)
    }
}
