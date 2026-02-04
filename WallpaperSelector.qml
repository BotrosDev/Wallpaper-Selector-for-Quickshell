import Quickshell
import QtQuick
import QtQuick.Controls
import Qt.labs.folderlistmodel
import QtCore
import Quickshell.Io
import Quickshell.Hyprland

PanelWindow {
    id: wallpaperSelector
    visible: false
    
    implicitWidth: 860
    implicitHeight: 600
    color: "transparent"
    
    property string wallpaperDir: StandardPaths.writableLocation(StandardPaths.PicturesLocation) + "/Wallpapers"
    
    mask: Region { item: mainContainer }
    
    function toggle() {
        visible = !visible
    }
    
    function setWallpaper(path) {

        setWallpaperProc.command = ["swww", "img", path, "--transition-type", "fade", "--transition-fps", "60"]
        
        setWallpaperProc.running = true
        wallpaperSelector.visible = false
    }
    
    // FolderListModel 
    FolderListModel {
        id: folderModel
        folder: wallpaperDir  
        nameFilters: ["*.jpg", "*.jpeg", "*.png", "*.webp", "*.JPG", "*.JPEG", "*.PNG", "*.WEBP"]
        showDirs: false
        sortField: FolderListModel.Name
        
        onCountChanged: {
            console.log("FolderListModel count changed:", count)
            console.log("Looking in folder:", folder)
        }
        
        Component.onCompleted: {
            console.log("FolderListModel initialized")
            console.log("Folder path:", folder)
            console.log("Wallpaper dir:", wallpaperDir)
            console.log("StandardPaths Pictures location:", StandardPaths.writableLocation(StandardPaths.PicturesLocation))
        }
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
                
                GridView {
                    id: gridView
                    anchors.fill: parent
                    anchors.margins: 10
                    
                    cellWidth: 265  // 250 + 15 spacing
                    cellHeight: 195  // 180 + 15 spacing
                    
                    model: folderModel
                    clip: true
                    
                    // This is key - only keep a small cache of items outside visible area
                    cacheBuffer: 400  // Only keep ~2 rows outside visible area
                    
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                    }
                    
                    delegate: Rectangle {
                        id: rect
                        required property string filePath
                        required property string fileName
                        
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
                                    source: "file://" + rect.filePath
                                    fillMode: Image.PreserveAspectCrop
                                    asynchronous: true
                                    smooth: true
                                    cache: false  // Don't cache to avoid memory issues with many images
                                    
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
                                text: rect.fileName
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
                                wallpaperSelector.setWallpaper(rect.filePath)
                            }
                        }
                    }
                }
                
                // Empty state
                Text {
                    visible: folderModel.count === 0
                    anchors.centerIn: parent
                    text: "No wallpapers found in:\n" + folderModel.folder + "\n\n" +
                          "Looking for: *.jpg, *.jpeg, *.png, *.webp\n\n" +
                          "Make sure the folder exists and contains image files"
                    color: '#565f89'
                    font.pixelSize: 14
                    font.family: "monospace"
                    horizontalAlignment: Text.AlignHCenter
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
