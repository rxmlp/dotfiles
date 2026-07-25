-- keybinds/binds/WindowWorkspace.lua

-- Window actions
hl.bind(mainMod .. " + C",       hl.dsp.window.close())

---------------
--  Windows
---------------
hl.bind("ALT + SHIFT + a",        movewindowLeft)
hl.bind("ALT + SHIFT + d",        movewindowRight)
hl.bind("ALT + SHIFT + w",        movewindowUp)
hl.bind("ALT + SHIFT + s",        movewindowDown)
hl.bind(mainMod .. " + SHIFT + left",  movewindowLeft)
hl.bind(mainMod .. " + SHIFT + right", movewindowRight)
hl.bind(mainMod .. " + SHIFT + up",    movewindowUp)
hl.bind(mainMod .. " + SHIFT + down",  movewindowDown)

-- Move focus
hl.bind("ALT + a",     hl.dsp.focus({ direction = "left"  }))
hl.bind("ALT + d",     hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + w",     hl.dsp.focus({ direction = "up"    }))
hl.bind("ALT + s",     hl.dsp.focus({ direction = "down"  }))
hl.bind("ALT + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind("ALT + right", hl.dsp.focus({ direction = "right" }))
hl.bind("ALT + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind("ALT + down",  hl.dsp.focus({ direction = "down"  }))

---------------
--  Workspaces
---------------
-- Navigate
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mainMod .. " + D",          hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + A",          hl.dsp.focus({ workspace = "m-1" }))
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end

-- Toggle special
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + T", hl.dsp.workspace.toggle_special("shh"))
hl.bind(mainMod .. " + P", hl.dsp.workspace.toggle_special("edit"))
hl.bind(mainMod .. " + G", hl.dsp.workspace.toggle_special("games"))

-- Move app to workspace
hl.bind(mainMod .. " + SHIFT + mouse_down", movetoworkspaceDown)
hl.bind(mainMod .. " + SHIFT + mouse_up",   movetoworkspaceUp)
hl.bind(mainMod .. " + SHIFT + D",          movetoworkspaceDown)
hl.bind(mainMod .. " + SHIFT + A",          movetoworkspaceUp)
hl.bind(mainMod .. " + SHIFT + 1", movetoworkspace_1)
hl.bind(mainMod .. " + SHIFT + 2", movetoworkspace_2)
hl.bind(mainMod .. " + SHIFT + 3", movetoworkspace_3)
hl.bind(mainMod .. " + SHIFT + 4", movetoworkspace_4)
hl.bind(mainMod .. " + SHIFT + 5", movetoworkspace_5)
hl.bind(mainMod .. " + SHIFT + 6", movetoworkspace_6)
hl.bind(mainMod .. " + SHIFT + 7", movetoworkspace_7)
hl.bind(mainMod .. " + SHIFT + 8", movetoworkspace_8)
hl.bind(mainMod .. " + SHIFT + 9", movetoworkspace_9)
hl.bind("CTRL + SHIFT + 1", movetoworkspace_10)
hl.bind("CTRL + SHIFT + 2", movetoworkspace_11)
hl.bind("CTRL + SHIFT + 3", movetoworkspace_12)

-- Move to special
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + SHIFT + T", hl.dsp.window.move({ workspace = "special:shh"   }))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.move({ workspace = "special:edit"  }))
hl.bind(mainMod .. " + SHIFT + G", hl.dsp.window.move({ workspace = "special:games" }))


-- keybinds/binds/WindowWorkspace.lua
-- ... rest of file, with the original SUPER+F / SUPER+V / mouse:272 / mouse:273 / CTRL+1/2/3 lines REMOVED ...

---------------
--  Conditional binds (disabled while focused window is in special:games)
---------------
local gamesSensitiveBound = false

local function bindGamesSensitive()
    if gamesSensitiveBound then return end
    hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = 0 }))
    hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = 1 }))
    hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    hl.bind("CTRL + 1", hl.dsp.focus({ workspace = 10 }))
    hl.bind("CTRL + 2", hl.dsp.focus({ workspace = 11 }))
    hl.bind("CTRL + 3", hl.dsp.focus({ workspace = 12 }))
    gamesSensitiveBound = true
end

local function unbindGamesSensitive()
    if not gamesSensitiveBound then return end
    hl.unbind(mainMod .. " + F")
    hl.unbind(mainMod .. " + SHIFT + F")
    hl.unbind(mainMod .. " + V")
    hl.unbind(mainMod .. " + mouse:272")
    hl.unbind(mainMod .. " + mouse:273")
    hl.unbind("CTRL + 1")
    hl.unbind("CTRL + 2")
    hl.unbind("CTRL + 3")
    gamesSensitiveBound = false
end

hl.on("window.active", function(w)
    if w ~= nil and w.workspace ~= nil and w.workspace.name == "special:games" then
        unbindGamesSensitive()
    else
        bindGamesSensitive()
    end
end)

bindGamesSensitive() -- register them at startup
