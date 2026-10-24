-- Monitor wiki https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Example: output can be found with hyprctl monitors. Edit variables.lua for the monitor outputs instead of here directly
-- Layout (left to right, bottom aligned): Laptop | KTC | LG

-- Laptop (BOE)
hl.monitor({
    output    = MONITOR1,
    mode      = "1920x1080@144",
    position  = "0x0",
    scale     = "1",
})

-- KTC H24V27
hl.monitor({
    output    = MONITOR2,
    mode      = "1920x1080@100",
    position  = "1920x0",
    scale     = "1",
})

-- LG L177WSB (portrait, 900x1440 rotated; 1080 - 1440 = -360 for bottom alignment)
hl.monitor({
    output    = MONITOR3,
    mode      = "1440x900@75",
    position  = "3840x-360",
    scale     = "1",
    transform = 3,
})

-- Fallback for any other monitor that gets plugged in
hl.monitor({
    output    = "",
    mode      = "preferred",
    position  = "auto",
    scale     = "auto",
})
