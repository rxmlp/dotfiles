-- rules/Application-Spawn.lua

-- Special workspaces
hl.window_rule({ name = "WindowSpawnMagic", workspace = "special:magic", match = { class = "(kitty)" } })
hl.window_rule({ name = "WindowSpawnIDK",   workspace = "special:shh",   match = { class = "(org.qbittorrent.qBittorrent)|(Mullvad VPN)|(PrusaSlicer)" } })
hl.window_rule({ name = "WindowSpawnEdit",  workspace = "special:edit",  match = { class = "(com.github.PintaProject.Pinta)|(gimp)|(org.gimp.GIMP)|(libreoffice-)(.*)" } })
hl.window_rule({ name = "WindowSpawnGamesClass", workspace = "special:games", match = { class = "(steam_app_)(.*)|(gamescope)" } })
hl.window_rule({ name = "WindowSpawnGamesTitle", workspace = "special:games", match = { title = "(Minecraft)(.*)" } })

-- Numbered workspaces
local spawns = {
    { ws = "1",        class = "(chromium)|(io.github.ungoogled_software.ungoogled_chromium)|(zen)|(librewolf)|(helium)" },
    { ws = "2",        class = "(codium)|(dev.zed.Zed)" },
    { ws = "3",        class = "(pcmanfm-qt)|(localsend)" },
    { ws = "4",        class = "(org.gnome.DiskUtility)" },
    { ws = "5",        class = "(obsidian)|(@joplin/app-desktop)" },
    { ws = "6",        class = "(Timeshift-gtk)|(Bitwarden)" },
    { ws = "7",        class = "(rustdesk)|(Rustdesk)" },
    { ws = "8",        class = "(eu.betterbird.Betterbird)|(org.mozilla.Thunderbird)" },
    { ws = "9 silent", class = "(net.lutris.Lutris)|(org.prismlauncher.PrismLauncher)|(steam)" },
    { ws = "10 silent",class = "(signal)|(fluffychat)|(org.gnome.Fractal)" },
    { ws = "11 silent",class = "(Spotify)|(spotify)|(spotify-qt)" },
    { ws = "12 silent",class = "(FreeTube)|(io.freetubeapp.FreeTube)|(org.jellyfin.JellyfinDesktop)" },
}

for i, s in ipairs(spawns) do
    local match = { class = s.class }
    if s.initial_title then match.initial_title = s.initial_title end
    hl.window_rule({
        name      = "WindowSpawn" .. i,
        workspace = s.ws,
        match     = match,
    })
end
