# Wallpaper Selector for QuickShell

A beautiful wallpaper selector popup for your Hyprland QuickShell bar.

A small QuickShell module that shows a scrollable grid of wallpapers and lets you apply them using swww or hyprpaper with smooth transitions.

## Table of contents
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Development & Contributing](#development--contributing)
- [License](#license)
- [Authors](#authors)

## Requirements
- QuickShell configured with modules support
- Hyprland (compositor)
- Either:
  - swww (recommended) OR
  - hyprpaper
- A recent Qt/QML runtime used by QuickShell (use the runtime QuickShell provides)

## Installation

1. Place files in your QuickShell modules directory (example layout):

```bash
# Example structure:
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
```

2. Copy files (keep a backup of your Bar.qml):

```bash
mkdir -p ~/.config/quickshell/modules/bar
cp WallpaperButton.qml WallpaperSelector.qml ~/.config/quickshell/modules/bar/
cp ~/.config/quickshell/modules/bar/Bar.qml ~/.config/quickshell/modules/bar/Bar.qml.backup
cp Bar.qml ~/.config/quickshell/modules/bar/
```

Tip: Use an atomic replace if you automate installs (move to a temp file then rename).

## Configuration

Open `WallpaperSelector.qml` and set your wallpaper directory (line ~16):

```qml
// Recommended: use QDir.homePath() inside QML where available
property string wallpaperDir: "/home/YOUR_USERNAME/Pictures/wallpapers"
// or
property string wallpaperDir: "/home/" + Process.env["USER"] + "/Pictures/wallpapers"
```

Backend selection:
- Default uses swww.
- To use hyprpaper, edit the commands near the backend section (~line 44-50):
  - Comment out the `swww` command
  - Uncomment or add the `hyprctl hyprpaper wallpaper ,<path>` command

Example:
```qml
// swww (example)
setWallpaperProc.command = ["swww", "img", path, "--transition-type", "fade", "--transition-fps", "60"]

// hyprpaper (example)
hyprpaperProc.command = ["hyprctl", "hyprpaper", "wallpaper", "," + path]
```

## Usage

1. Click the 🖼️ Wallpaper button next to the clock.
2. The popup displays thumbnails of files in `wallpaperDir`.
3. Click a thumbnail to apply it.
4. Click the X or outside to close.

Supported formats: JPG/JPEG, PNG, WEBP.

## Customization

- Popup size: edit `width` / `height` in `WallpaperSelector.qml`.
- Thumbnail size: change the Rectangle `width`/`height` used for thumbnails (around line ~123).
- Colors: theme uses Tokyo Night palette — update hex values in the file.
- Recursive scanning: currently only scans immediate directory — consider enabling recursion if you store nested folders.

Recommended code change for a more robust home path:
```qml
// if available in your QML environment
property string wallpaperDir: Qt.resolvedUrl("") === "" ? QDir.homePath() + "/Pictures/wallpapers" : "/home/" + Process.env["USER"] + "/Pictures/wallpapers"
```

## Troubleshooting

No wallpapers shown?
- Verify `wallpaperDir` exists and contains supported images.
- Run quickshell from a terminal to view QML errors:
  journalctl -f -u quickshell
  or
  quickshell

Wallpaper not changing?
- If using swww: ensure the swww daemon is running (`pgrep swww`).
- Test manually:
  swww img /path/to/wallpaper.jpg
- If using hyprpaper: test the hyprctl command:
  hyprctl hyprpaper wallpaper ,/path/to/wallpaper.jpg

Button not appearing?
- Confirm files are located in `~/.config/quickshell/modules/bar/`.
- Look for QML syntax errors in terminal output.

Performance / large collections:
- Thumbnails are loaded asynchronously; there may be a delay on first open.
- If you have thousands of images, consider pre-generating thumbnails or enabling lazy loading / pagination.

Edge cases:
- Filenames with spaces or special characters should be handled by the command array (QML should pass them correctly). If issues appear, print the constructed command for debugging.

## Development & Contributing

- Run quickshell from a terminal to iterate and see QML errors:
  quickshell
- If you add features, write tests if your workflow supports them or provide reproducible run instructions.
- Suggested enhancements:
  - Recursive directory scanning
  - Thumbnail cache to speed up subsequent opens
  - Keyboard navigation (arrow keys + Enter)
  - Option to set per-monitor wallpapers

Pull requests and issues welcome.

## License
MIT License

## Authors
Made by [BotrosDev](https://github.com/BotrosDev), [MumbleGameZ](https://github.com/MumbleGamez) and @SatellaCatGirl
