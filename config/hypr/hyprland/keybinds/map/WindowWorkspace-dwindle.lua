-- keybinds/map/WindowWorkspace-dwindle.lua

require("hyprland.keybinds.map.default")

hl.config({ general = { layout = "dwindle" } })

movewindowLeft  = hl.dsp.window.move({ direction = "left" })
movewindowRight = hl.dsp.window.move({ direction = "right" })
movewindowUp    = hl.dsp.window.move({ direction = "up" })
movewindowDown  = hl.dsp.window.move({ direction = "down" })

movetoworkspace = function(ws) return hl.dsp.window.move({ workspace = ws }) end

movetoworkspace_1  = movetoworkspace(1)
movetoworkspace_2  = movetoworkspace(2)
movetoworkspace_3  = movetoworkspace(3)
movetoworkspace_4  = movetoworkspace(4)
movetoworkspace_5  = movetoworkspace(5)
movetoworkspace_6  = movetoworkspace(6)
movetoworkspace_7  = movetoworkspace(7)
movetoworkspace_8  = movetoworkspace(8)
movetoworkspace_9  = movetoworkspace(9)
movetoworkspace_10 = movetoworkspace(10)
movetoworkspace_11 = movetoworkspace(11)
movetoworkspace_12 = movetoworkspace(12)

movetoworkspaceDown = hl.dsp.window.move({ workspace = "r+1" })
movetoworkspaceUp   = hl.dsp.window.move({ workspace = "r-1" })

require("hyprland.keybinds.binds.WindowWorkspace")
