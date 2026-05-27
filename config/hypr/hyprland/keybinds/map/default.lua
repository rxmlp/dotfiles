-- keybinds/map/default.lua

--------------
-- Sys & Apps
--------------
mainMod     = "SUPER"
altMod      = "CTRL"
terminal    = "kitty"
fileManager = "pcmanfm-qt"
menu        = "fuzzel"

-------------------
-- Menu/Appearance
-------------------
lock       = "[size 200 200; float; center; workspace w] " .. terminal .. " " .. HLS .. "/kitty-tui/powermenu.sh"
bar        = "pkill -SIGUSR1 waybar"
hub        = "[size 750 500; float; center; workspace w] " .. terminal .. " " .. HLS .. "/kitty-tui/hub.sh"
wallpapers = "[size 750 500; float; center; workspace w] " .. terminal .. " " .. HLS .. "/wall/wallpaper.sh"
matugenApps = "" .. HOME .. "/.config/matugen/scripts/signal-matugen.sh"

-------------
-- Clipboard
-------------
clipboard         = "pkill fuzzel || clipman pick --tool=CUSTOM --tool-args=\"fuzzel -d\" --histpath=\"/tmp/clipman.json\""

--------------
-- Screenshot
--------------
ScreenshotMenu    = "[size 200 200; float; center; workspace w] " .. terminal .. " " .. HLS .. "/kitty-tui/capture.sh"
ScreenshotMonitor = "/usr/bin/grimblast --notify save output"
ScreenshotArea    = "/usr/bin/grimblast --freeze save area - | swappy -f -"

---------
-- Audio
---------
PlayerPlayPause = "playerctl play-pause"
PlayerNext      = "playerctl next"
PlayerPrevious  = "playerctl previous"
AudioUp         = "" .. HLS .. "/volume/mako-volume.sh up"
AudioDown       = "" .. HLS .. "/volume/mako-volume.sh down"
AudioMute       = "" .. HLS .. "/volume/mako-volume.sh mute"
MicUp           = "" .. HLS .. "/volume/mako-mic.sh up"
MicDown         = "" .. HLS .. "/volume/mako-mic.sh down"
MicMute         = "" .. HLS .. "/volume/mako-mic.sh mute"

--------------
-- Brightness
--------------
ddcutilUp       = "" .. HLS .. "/brightness.sh up 10"
ddcutilDown     = "" .. HLS .. "/brightness.sh down 10"

require("hyprland.keybinds.binds.default")
