import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

import "internal"

Item {
    id: root

    GSTabLayout {
        anchors.fill: root
        anchors.margins: 16

        tabs: [
            {
                "Name": "Components",
                "Icon Code": IconCode.MenuButtonWide,
                "Is Current": true,
                "Item": componentsPage
            }, {
                "Name": "Interactive",
                "Icon Code": IconCode.WindowStack,
                "Item": interactivePage
            }
        ]
    }

    ComponentsPage {
        id: componentsPage
    }

    InteractivePage {
        id: interactivePage
    }
}
