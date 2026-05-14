-- plugins/hyprexpo/hyprexpo.lua

hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(HL .. "/plugins/hyprexpo/hyprexpo.sh"))

plugin = {
    hyprexpo = {
        columns  = 3,
        gap_size = 5,
        bg_col   = "rgb(000000)",
        workspace_method = "first 1",

        enable_gesture   = false,
        gesture_distance = 10,
        gesture_positive = false,
    },
}
