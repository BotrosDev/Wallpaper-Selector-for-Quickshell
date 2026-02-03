import Quickshell
import QtQuick
import Quickshell.Io

Item {
    id: wallpaperButton
    width: buttonRow.width + 16
    height: buttonRow.height
    
    signal clicked()
    
    Row {
        id: buttonRow
        spacing: 6
        anchors.centerIn: parent
        
        Text {
            text: "🖼️"
            color: '#7aa2f7'
            font.pixelSize: 18
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Text {
            text: "Wallpaper"
            color: '#c0caf5'
            font.pixelSize: 16
            font.family: "monospace"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    Rectangle {
        anchors.fill: parent
        color: mouseArea.containsMouse ? "#2a2b36" : "transparent"
        radius: 4
        z: -1
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: wallpaperButton.clicked()
    }
}
