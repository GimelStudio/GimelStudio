import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

import "internal"

Item {
    id: root

    GSTabBar {
        // id: tabBar
        id: tabRow
        anchors.horizontalCenter: root.horizontalCenter

        y: 16

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

        stackLayout: tabContent
    }

    GSStackLayout {
        id: tabContent

        anchors {
            fill: root
            leftMargin: 16
            rightMargin: 16
            topMargin: tabRow.y + tabRow.height + 16
            bottomMargin: 16
        }

        itemNames: ["Components", "Interactive"]

        // ComponentsPage {
        //     id: componentsPage
        // }

        // InteractivePage {
        //     id: interactivePage
        // }
    }

    ComponentsPage {
        id: componentsPage
    }

    InteractivePage {
        id: interactivePage
    }
}
