import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick.Controls

PanelWindow {
    id: wallpaperSelector
    visible: false
    
    implicitWidth: 860
    implicitHeight: 600
    color: "transparent"
    
    property string wallpaperDir: "../../../../home/Your User Name/Pictures/Wallpapers"

    property var wallpaperList: []
    
    // FIXED: Proper mask region that covers the entire window to make it interactive
    mask: Region { item: mainContainer }
    
    function toggle() {
        if (visible) {
            visible = false
        } else {
            loadWallpapers()
            visible = true
        }
    }
    
    function loadWallpapers() {
        wallpaperProc.running = true
    }
    
    function setWallpaper(path) {

        setWallpaperProc.command = ["swww", "img", path, "--transition-type", "fade", "--transition-fps", "60"]
        
        setWallpaperProc.running = true
        wallpaperSelector.visible = false
    }
    
    Rectangle {
        id: mainContainer
        anchors.fill: parent
        color: "#1a1b26"
        radius: 12
        border.color: "#414868"
        border.width: 2
        
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15
            
            // Header
            Row {
                width: parent.width
                spacing: 10
                
                Text {
                    text: "🖼️ Select Wallpaper"
                    color: '#c0caf5'
                    font.pixelSize: 20
                    font.family: "monospace"
                    font.bold: true
                }
                
                
                // Close button
                Rectangle {
                    width: 30
                    height: 30
                    color: closeMouseArea.containsMouse ? "#f7768e" : "#414868"
                    radius: 4
                    
                    Text {
                        anchors.centerIn: parent
                        text: "×"
                        color: '#c0caf5'
                        font.pixelSize: 20
                        font.bold: true
                    }
                    
                    MouseArea {
                        id: closeMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: wallpaperSelector.visible = false
                    }
                }
            }
            
            // Path display
            Text {
                text: "Directory: " + wallpaperDir
                color: '#565f89'
                font.pixelSize: 12
                font.family: "monospace"
            }
            
            // Scrollable grid view
            Rectangle {
                width: parent.width
                height: parent.height - 80
                color: "#16161e"
                radius: 8
                clip: true
                
                Flickable {
                    id: flickable
                    anchors.fill: parent
                    anchors.margins: 10
                    contentWidth: gridFlow.width
                    contentHeight: gridFlow.height
                    boundsBehavior: Flickable.StopAtBounds
                    
                    // Enable scrolling with mouse wheel
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                    
                    Flow {
                        id: gridFlow
                        width: flickable.width - 20
                        spacing: 15
                        
                        Repeater {
                            model: wallpaperSelector.wallpaperList
                            
                            Rectangle {
                                width: 250
                                height: 180
                                color: "#24283b"
                                radius: 8
                                border.color: itemMouseArea.containsMouse ? "#7aa2f7" : "#414868"
                                border.width: 2
                                
                                Behavior on border.color {
                                    ColorAnimation { duration: 150 }
                                }
                                
                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 8
                                    spacing: 5
                                    
                                    // Image preview
                                    Rectangle {
                                        width: parent.width
                                        height: parent.height - 30
                                        color: "#1a1b26"
                                        radius: 4
                                        clip: true
                                        
                                        Image {
                                            anchors.fill: parent
                                            source: "file://" + modelData
                                            fillMode: Image.PreserveAspectCrop
                                            asynchronous: true
                                            smooth: true
                                            
                                            // Show loading indicator
                                            Text {
                                                anchors.centerIn: parent
                                                text: "Loading..."
                                                color: '#565f89'
                                                visible: parent.status === Image.Loading
                                            }
                                            
                                            // Show error if image fails to load
                                            Text {
                                                anchors.centerIn: parent
                                                text: "Failed to load"
                                                color: '#f7768e'
                                                visible: parent.status === Image.Error
                                            }
                                            
                                            Rectangle {
                                                anchors.fill: parent
                                                color: "transparent"
                                                border.color: "#414868"
                                                border.width: 1
                                                radius: 4
                                            }
                                        }
                                    }
                                    
                                    // Filename
                                    Text {
                                        width: parent.width
                                        text: modelData.split('/').pop()
                                        color: '#c0caf5'
                                        font.pixelSize: 11
                                        font.family: "monospace"
                                        elide: Text.ElideMiddle
                                        horizontalAlignment: Text.AlignHCenter
                                    }
                                }
                                
                                MouseArea {
                                    id: itemMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    
                                    onClicked: {
                                        wallpaperSelector.setWallpaper(modelData)
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Empty state
                Text {
                    visible: wallpaperSelector.wallpaperList.length === 0
                    anchors.centerIn: parent
                    text: "No wallpapers found in:\n" + wallpaperDir + "\n\nUpdate the wallpaperDir property"
                    color: '#565f89'
                    font.pixelSize: 14
                    font.family: "monospace"
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }
    }
    
    // Process to list wallpapers - FIXED: Proper find command syntax
    Process {
        id: wallpaperProc
        command: ["sh", "-c", "find '" + wallpaperDir + "' -maxdepth 1 -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \\)"]
        running: false
        
        stdout: StdioCollector {
            onStreamFinished: {
                var paths = this.text.trim().split('\n').filter(function(path) {
                    return path.length > 0
                })
                wallpaperSelector.wallpaperList = paths.sort()
                console.log("Found", paths.length, "wallpapers")
            }
        }
        
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim().length > 0) {
                    console.log("Error loading wallpapers:", this.text)
                }
            }
        }
    }
    
    // Process to set wallpaper
    Process {
        id: setWallpaperProc
        running: false
        
        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim().length > 0) {
                    console.log("Wallpaper set error:", this.text)
                }
            }
        }
    }
}
