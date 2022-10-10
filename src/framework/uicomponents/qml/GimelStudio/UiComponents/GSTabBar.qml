import QtQuick 2.15
import QtQuick.Controls 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

import "internal"

Item {
    id: root

    implicitHeight: UiTheme.defaultButtonSize.y

    property var tabs: []
    property var tabItems: []
    // TODO: Add orientation setting
    property var stackLayout

    function finishTabCreation(component, tab, tabData) {
        if (component.status == Component.Ready) {
            var tabIndex = root.tabs.indexOf(tabData)
            root.stackLayout.children.push(tabData["Item"])
            if (tabData["Is Current"]) {
                root.stackLayout.currentIndex = tabIndex
            }

            tab = component.createObject(contentRow, {
                iconCode: tabData["Icon Code"],
                isCurrent: tabData["Is Current"],
                text: tabData["Name"],
            })

            tab.clicked.connect(function() {
                tabItems.forEach((tabItem, index) => {
                    tabItem.isCurrent = false
                })

                root.stackLayout.switchItemByIndex(tabIndex)
                tab.isCurrent = true
            })

            root.tabItems.push(tab)
            root.implicitWidth += tab.width

            if (tab == null) {
                console.log("Error creating GSTab: ", component.errorString())
            }
        } else if (component.status == Component.Error) {
            console.log("Error loading GSTab: ", component.errorString())
        }
    }

    Row {
        id: contentRow
        anchors.fill: parent
        spacing: 8
    }

    Component.onCompleted: {
        var component
        var tab

        tabs.forEach((tabData, index) => {
            if (!tabData["Name"]) {
                tabData["Name"] = ""
            }

            if (!tabData["Icon Code"]) {
                tabData["Icon Code"] = IconCode.None
            }

            if (!tabData["Is Current"]) {
                tabData["Is Current"] = false
            }

            if (!tabData["Item"]) {
                tabData["Item"] = Qt.createComponent("internal/ItemTemplate.qml").createObject(root.stackLayout)
            }

            component = Qt.createComponent("GSTab.qml")
            if (component.status == Component.Ready) {
                finishTabCreation(component, tab, tabData)
            } else {
                component.statusChanged.connect(function(component, tab, tabData) {finishTabCreation(component, tab, tabData)})
            }
        })
    }
}
