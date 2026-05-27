-- keybinds/binds/default.lua



--------------
-- Sys & Apps
--------------
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))

-------------------
-- Menu/Appearance
-------------------
hl.bind(mainMod .. " + Scroll_Lock", hl.dsp.exec_cmd(lock))
hl.bind(mainMod .. " + B",       hl.dsp.exec_cmd(bar))
hl.bind(mainMod .. " + Home",        hl.dsp.exec_cmd(hub))
hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd(wallpapers))
hl.bind(mainMod .. " + SHIFT + W",     hl.dsp.exec_cmd(matugenApps))

-------------
-- Clipboard
-------------
hl.bind(mainMod .. " + Menu", hl.dsp.exec_cmd(clipboard))

--------------
-- Screenshot
--------------
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(ScreenshotMenu))
hl.bind("Print",                hl.dsp.exec_cmd(ScreenshotMonitor))
hl.bind("SHIFT + Print",        hl.dsp.exec_cmd(ScreenshotArea))

---------
-- Audio
---------
hl.bind("XF86AudioPlay",        hl.dsp.exec_cmd(PlayerPlayPause), { locked = true })
hl.bind("XF86AudioNext",        hl.dsp.exec_cmd(PlayerNext),      { locked = true })
hl.bind("XF86AudioPrev",        hl.dsp.exec_cmd(PlayerPrevious),  { locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(AudioUp),         { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(AudioDown),       { locked = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd(AudioMute),       { locked = true })
hl.bind(mainMod .. " + XF86AudioRaiseVolume", hl.dsp.exec_cmd(MicUp),   { locked = true })
hl.bind(mainMod .. " + XF86AudioLowerVolume", hl.dsp.exec_cmd(MicDown), { locked = true })
hl.bind(mainMod .. " + XF86AudioMute",        hl.dsp.exec_cmd(MicMute), { locked = true })

--------------
-- Brightness
--------------
hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(ddcutilUp),   { locked = true })
hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(ddcutilDown), { locked = true })
