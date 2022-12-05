import QtQuick 2.15

import GimelStudio.Shortcuts 1.0

QtObject {
    id: root

    property var shortcuts: []
    property ShortcutsModel shortcutsModel: ShortcutsModel {
        Component.onCompleted: {
            for (var i = 0; i < shortcutsModel.shortcuts.length; i++) {
                var shortcut = shortcutsModel.shortcuts[i]
                var shortcutObject = shortcutCreator.createObject(root, {sequence: shortcut["seq"]})
                root.shortcuts.push(shortcutObject)
            }
        }
    }

    property Component shortcutCreator: Component {
        Shortcut {
            onActivated: shortcutsModel.activate(sequence)
        }
    }
}
