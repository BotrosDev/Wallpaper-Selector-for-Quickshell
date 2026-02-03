import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Layouts

PanelWindow {
    anchors {
        bottom: true
        left: true
        right: true
    }
    implicitHeight: 50
    color: "#1a1b26"

    // Wallpaper Selector Window
    WallpaperSelector {
        id: wallpaperSelector
    }

    // Workspace switcher (left side)
    Workspace {
        anchors.verticalCenter: parent.verticalCenter
    }

    // Center row with Clock and Wallpaper Button
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20
        
        Clock {
            anchors.verticalCenter: parent.verticalCenter
        }
        
        WallpaperButton {
            anchors.verticalCenter: parent.verticalCenter
            onClicked: wallpaperSelector.toggle()
        }
    }

    // Spacer
    Item {
        Layout.fillWidth: true
    }

    // Battery (right side)
    Battery {
        id: battery
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
    }

}
