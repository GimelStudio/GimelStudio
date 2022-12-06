import QtQuick 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

import "qrc:/kddockwidgets/qtquick/views/qml/" as KDDW

KDDW.TabBarBase {
    id: root

    implicitHeight: 30
    currentTabIndex: 0

    function getTabAtIndex(index) {
        return tabBarRow.children[index];
    }

    function getTabIndexAtPosition(globalPoint) {
        for (var i = 0; i < tabBarRow.children.length; ++i) {
            var tab = tabBarRow.children[i];
            var localPt = tab.mapFromGlobal(globalPoint.x, globalPoint.y);
            if (tab.contains(localPt)) {
                return i;
            }
        }

        return -1;
    }

    Row {
        id: tabBarRow

        anchors.fill: parent
        spacing: 2

        property int hoveredIndex: -1;

        Repeater {
            model: root.groupCpp ? root.groupCpp.tabBar.dockWidgetModel : 0
            Rectangle {
                id: tab
                height: parent.height
                width: 100
                color: (tabBarRow.hoveredIndex == index) ? UiTheme.componentColor : UiTheme.backgroundSecondaryColor
                border.color: UiTheme.strokeColor

                border.width: 1

                readonly property int tabIndex: index

                GSLabel {
                    anchors.centerIn: parent
                    text: title
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.currentTabIndex = index;
                    }
                }
            }
        }

        Connections {
            target: tabBarCpp

            function onHoveredTabIndexChanged(index) {
                tabBarRow.hoveredIndex = index;
            }
        }
    }
}