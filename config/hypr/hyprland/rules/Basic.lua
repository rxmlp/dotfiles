-- rules/Basic.lua

-- Fix some dragging issues with XWayland
hl.window_rule({
    name     = "XWayland-Fix",
    no_focus = true,
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
})

-- Adds a red border to xwayland windows
hl.window_rule({
    name         = "XWayland-Border",
    border_color = on_error,
    match        = { xwayland = true },
})

-- Polkit agent
hl.window_rule({
    name    = "Polkit",
    opacity = "1.0 override 1.0 override",
    match   = { class = "(hyprpolkitagent)" },
})

-- No blur on all windows
hl.window_rule({
    name    = "No-Blur",
    no_blur = true,
    match   = { title = "(.*)" },
})

-- No idle on fullscreen
hl.window_rule({
    name         = "No-Fullscreen-Idle",
    idle_inhibit = "fullscreen",
    match        = { fullscreen = true },
})

-- Float hyprpwcenter
hl.window_rule({
    name  = "Float",
    float = true,
    match = { class = "(hyprpwcenter)" },
})

-- Screensharing
hl.window_rule({
    name             = "Screensharing",
    opacity          = "1.0 override 1.0 override",
    no_anim          = true,
    no_initial_focus = true,
    max_size         = "1 1",
    no_blur          = true,
    no_focus         = true,
    match            = { class = "^(xwaylandvideobridge)$" },
})

hl.layer_rule({
    name         = "fuzzel-layer",
    ignore_alpha = 0,
    match        = { namespace = "fuzzel" },
})

hl.layer_rule({
    name    = "hyprpicker-layer",
    no_anim = true,
    match   = { namespace = "hyprpicker" },
})

hl.layer_rule({
    name         = "waybar-layer",
    blur         = true,
    ignore_alpha = 0,
    match        = { namespace = "waybar" },
})
