-- rules/windowrules.lua

hl.window_rule({
    name        = "ScriptsFocus",
    stay_focused = true,
    match        = { title = "(kitty-tui)" },
})

-- if opacity (from hyprsettings.lua)
if opacity ~= "" then
    hl.window_rule({
        name    = "NonSpecialOpacity",
        opacity = "1.0 override 1.0 override",
        match   = { workspace = "r[1-9] w[t1]" },
    })
    hl.window_rule({
        name    = "NonSpecialOpacityRm",
        opacity = "1.0 override 1.0 override",
        match   = {
            workspace = "r[1-9] w[t1]",
            title     = "(.*)(YouTube)(.*)",
        },
    })
end

-- Communication
hl.window_rule({
    name   = "BirdFloat",
    float  = true,
    center = true,
    match  = { title = "(Password Required - Betterbird)|(About Betterbird)" },
})

-- Browser
hl.window_rule({
    name   = "ChromiumExtensions",
    float  = true,
    size   = "850 670",
    center = true,
    match  = {
        class         = "(chrome-)(.*)",
        initial_title = "(_crx_)(.*)",
    },
})

-- Files
hl.window_rule({
    name   = "FilesFloatClass",
    float  = true,
    center = true,
    match  = { class = "(xdg-desktop-portal-gtk)" },
})

hl.window_rule({
    name   = "FilesFloatTitle",
    size   = "850 670",
    float  = true,
    center = true,
    match  = { title = "(Progress)|(Mount)|(Save File)|(Move Files)|(Open File)(.*)|(Copy Files)(.*)|(Delete Files)(.*)|(Trash Files)(.*)|(Removable medium is inserted)(.*)|(Write:)(.*)|(Select a File)(.*)|(Choose wallpaper)(.*)|(Open Folder)(.*)|(Save As)(.*)|(Library)(.*)|(Execute file)" },
})

-- Thunderbird/Betterbird popups
hl.window_rule({
    name   = "Bird",
    float  = true,
    center = true,
    match  = {
        class         = "(eu.betterbird.Betterbird)|(org.mozilla.Thunderbird)",
        initial_title = "negative:(Betterbird)|(Mozilla Thunderbird)",
    },
})

-- Torrent
hl.window_rule({
    name   = "TorrentFloat",
    float  = true,
    center = true,
    match  = { class = "(Mullvad VPN)" },
})

hl.window_rule({
    name  = "TorrentSize",
    size  = "720 450",
    match = {
        class = "(org.qbittorrent.qBittorrent)",
        title = "(Download from URLs)|(Remove torrent)(.*)",
    },
})

-- Game Launchers
hl.window_rule({
    name   = "GameLaunchersFloat",
    float  = true,
    center = true,
    match  = {
        class = "(steam)",
        title = "negative:(Steam)",
    },
})

hl.window_rule({
    name  = "GameLaunchersUnset",
    group = "unset",
    match = {
        class = "(steam)",
        title = "(notificationtoasts_*_desktop)",
    },
})

-- Games
hl.window_rule({
    name        = "GamemodeWorkspace",
    stay_focused = true,
    fullscreen  = true,
    immediate   = true,
    content     = "game",
    match       = { workspace = "(special:games)" },
})
