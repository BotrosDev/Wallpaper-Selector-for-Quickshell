# Wallpaper Selector for QuickShell

A beautiful wallpaper selector popup for your Hyprland QuickShell bar!

## 📦 Files Included

1. **WallpaperButton.qml** - Button component that appears next to the clock
2. **WallpaperSelector.qml** - Popup window with wallpaper grid
3. **Bar.qml** - Updated bar with the wallpaper button integrated

## 🚀 Installation

### Step 1: Place the files

Copy the new files to your QuickShell modules directory:

```bash
# Assuming your structure is similar to:
# ~/.config/quickshell/
#   ├── shell.qml
#   └── modules/
#       └── bar/
#           ├── Bar.qml
#           ├── Clock.qml
#           ├── Battery.qml
#           ├── Workspace.qml
#           ├── WallpaperButton.qml      ← NEW
#           └── WallpaperSelector.qml    ← NEW

# Copy the new files
cp WallpaperButton.qml ~/.config/quickshell/modules/bar/
cp WallpaperSelector.qml ~/.config/quickshell/modules/bar/

# Replace your old Bar.qml (backup first!)
cp ~/.config/quickshell/modules/bar/Bar.qml ~/.config/quickshell/modules/bar/Bar.qml.backup
cp Bar.qml ~/.config/quickshell/modules/bar/
```

### Step 2: Configure wallpaper directory

Edit `WallpaperSelector.qml` and update line 16 with your wallpaper directory:

```qml
property string wallpaperDir: "/home/YOUR_USERNAME/Pictures/wallpapers"
```

Or use the default which auto-detects your username:
```qml
property string wallpaperDir: "/home/" + Process.env["USER"] + "/Pictures/wallpapers"
```

### Step 3: Configure wallpaper backend

The selector supports both **swww** and **hyprpaper**. 

#### For swww (default, recommended):
The default configuration uses swww. Make sure you have it installed and running:

```bash
# Install swww
yay -S swww  # or your package manager

# Initialize swww daemon
swww init
```

#### For hyprpaper:
If you prefer hyprpaper, edit `WallpaperSelector.qml` around line 44-50:

**Comment out swww line:**
```qml
// setWallpaperProc.command = ["swww", "img", path, "--transition-type", "fade", "--transition-fps", "60"]
```

**Uncomment hyprpaper line:**
```qml
hyprpaperProc.command = ["hyprctl", "hyprpaper", "wallpaper", "," + path]
```

### Step 4: Restart QuickShell

```bash
# Kill and restart quickshell
killall quickshell && quickshell
```

## 🎨 Usage

1. Click the **🖼️ Wallpaper** button next to the clock
2. A popup window will appear showing all wallpapers in your directory
3. Click any wallpaper to apply it
4. Click the X or outside the window to close

## ⚙️ Customization

### Change wallpaper directory
Edit line 16 in `WallpaperSelector.qml`:
```qml
property string wallpaperDir: "/your/custom/path"
```

### Supported formats
- JPG/JPEG
- PNG
- WEBP

### Adjust popup size
Edit in `WallpaperSelector.qml`:
```qml
width: 900   // Change width
height: 600  // Change height
```

### Adjust thumbnail size
Edit in `WallpaperSelector.qml` around line 123:
```qml
Rectangle {
    width: 250   // Thumbnail width
    height: 180  // Thumbnail height
    // ...
}
```

### Change colors
The selector uses Tokyo Night theme colors. To customize:
- Background: `#1a1b26`
- Borders: `#414868`
- Accent: `#7aa2f7`
- Text: `#c0caf5`

## 🔧 Troubleshooting

### No wallpapers showing?
1. Check if your wallpaper directory exists
2. Verify the path in `WallpaperSelector.qml`
3. Check console output: `journalctl -f -u quickshell` or run quickshell from terminal

### Wallpaper not changing?
1. Make sure swww daemon is running: `pgrep swww`
2. Test manually: `swww img /path/to/wallpaper.jpg`
3. Check if you're using the correct backend (swww vs hyprpaper)

### Button not appearing?
1. Make sure all files are in the correct directory
2. Check for QML syntax errors in the console
3. Restart QuickShell completely

## 🎯 Features

- ✅ Beautiful grid layout with image previews
- ✅ Smooth fade transitions
- ✅ Hover effects
- ✅ Tokyo Night theme integration
- ✅ Auto-detects wallpapers (jpg, png, webp)
- ✅ Scrollable for large collections
- ✅ Click outside to close
- ✅ Works with swww and hyprpaper

## 📝 Notes

- The selector only scans the immediate directory (not subdirectories)
- Images are loaded asynchronously for smooth performance
- The first time you open it, there might be a brief delay while loading thumbnails
- Only supported for Arch Linux, customize it yourself if using Nixos or any other distros

Made with by @BotrosDe , @MumbleGameZ and @SatellaCatGirl

