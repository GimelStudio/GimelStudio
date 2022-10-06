import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    GSFlickable {
        anchors.fill: parent
        contentWidth: mainLayout.width
        contentHeight: mainLayout.height 

        Column {
            id: mainLayout
            spacing: 32

            width: root.width

            Column {
                spacing: 16

                Row {
                    spacing: 16
                    GSLabel {
                        font: UiTheme.headerFont
                        text: qsTr("Labels")
                    }

                    GSLabel {
                        anchors.verticalCenter: parent.verticalCenter
                        font: UiTheme.bodyFont
                        text: qsTr("(GSLabel)")
                    }
                }

                Column {
                    spacing: 8

                    GSLabel {
                        font: UiTheme.titleFont
                        text: qsTr("Label Using Title Font")
                    }

                    GSLabel {
                        font: UiTheme.headerFont
                        text: qsTr("Label Using Header Font")
                    }

                    GSLabel {
                        font: UiTheme.bodyBoldFont
                        text: qsTr("Label using body bold font")
                    }

                    GSLabel {
                        text: qsTr("Label using body font")
                    }
                }
            }

            Column {
                spacing: 16

                Row {
                    spacing: 16
                    GSLabel {
                        font: UiTheme.headerFont
                        text: qsTr("Buttons")
                    }

                    GSLabel {
                        anchors.verticalCenter: parent.verticalCenter
                        font: UiTheme.bodyFont
                        text: qsTr("(GSButton)")
                    }
                }

                Column {
                    spacing: 8

                    Column {
                        spacing: 8
                        GSButton {
                            text: qsTr("Button")
                        }

                        GSButton {
                            iconPos: GSButton.IconPos.Right
                            text: qsTr("Button")
                        }

                        GSButton {
                            iconPos: GSButton.IconPos.Top
                            text: qsTr("Button")
                        }

                        GSButton {
                            iconPos: GSButton.IconPos.Bottom
                            text: qsTr("Button")
                        }
                    }
                }
            }

            Column {
                spacing: 16

                Row {
                    spacing: 16
                    GSLabel {
                        font: UiTheme.headerFont
                        text: qsTr("Text Inputs")
                    }

                    GSLabel {
                        anchors.verticalCenter: parent.verticalCenter
                        font: UiTheme.bodyFont
                        text: qsTr("(GSTextInput)")
                    }
                }

                Column {
                    spacing: 8

                    GSTextInput {}
                }
            }
        }
    }
}
