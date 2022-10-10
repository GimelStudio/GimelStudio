import QtQuick 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0

StackLayout {
    id: root

    property var itemNames: []

    function switchItemByIndex(itemIndex) {
        root.currentIndex = itemIndex
    }

    function switchItemByName(itemName) {
        // TODO: Add a check to see if itemName exists in the itemNames array
        root.currentIndex = root.itemNames.indexOf(itemName)
    }

    function currentItem() {
        return root.itemNames[root.currentIndex]
    }
}
