-- rules/workspace.lua

local no_border = { no_rounding = true, gaps_in = 0, gaps_out = 0, no_shadow = true }

-- General fullscreen
hl.workspace_rule({ workspace = "f[0]", no_rounding = true, decorate = false, gaps_in = 0, gaps_out = 0, no_border = true, no_shadow = true })
hl.workspace_rule({ workspace = "f[1]", no_rounding = true, decorate = false, gaps_in = 0, gaps_out = 0, no_border = true, no_shadow = true })

-- Special
hl.workspace_rule({ workspace = "special:edit",  no_rounding = true, decorate = false, gaps_in = 0, gaps_out = 0, no_border = true, no_shadow = true })
hl.workspace_rule({ workspace = "special:games", no_rounding = true, decorate = false, gaps_in = 0, gaps_out = 0, no_border = true, no_shadow = true })

-- Primary monitor workspaces 1-9
hl.workspace_rule({ workspace = "1", monitor = monitor_primary, default = true })

-- Secondary monitor workspaces 10-12
hl.workspace_rule({ workspace = "10", monitor = monitor_secondary, default = true })
