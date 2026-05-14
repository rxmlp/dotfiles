-- XDG Environment
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SCALE", "1")


-- Wayland / Display Configuration
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")

-- Qt Settings
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Cursor/GTK Configuration
hl.env("HYPRCURSOR_THEME", ("cursor"))
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", ("cursor"))
hl.env("XCURSOR_SIZE", "18")
hl.env("GTK_THEME", "Matugen")

-- Set ssh agent
hl.env("SSH_AUTH_SOCK", os.getenv("XDG_RUNTIME_DIR") .. "/ssh-agent.socket")

-- Wallpaper will be applied to hyprlock when set on primary monitor (does not include animated)
hl.env("hyprlockwall", "on")

-- Just some links
HL = os.getenv("HOME") .. "/.config/hypr/hyprland"
HLS     = HL .. "/scripts"

-- For scripts
hl.env("HL",  HL)
hl.env("HLS", HLS)
hl.env("HLC", HL .. "/conf")
