-- Input configuration

hl.config({
    input = {
        -- sensitivity = -0.25,
        accel_profile = "flat",
        kb_layout = "tr",
        -- From the old KooL setup: faster key repeat
        repeat_rate = 50,
        repeat_delay = 300,
        -- macOS-like touchpad
        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
            clickfinger_behavior = true, -- two-finger click = right click
            scroll_factor = 0.5,
        },
    },
    -- Uncomment the section below to enable software cursors; this can help with cursor display or behavior issues
    -- cursor = {
    --     no_hardware_cursors = 1,
    -- },
})

-- macOS-like: three fingers sideways switch workspaces; window actions move to four fingers
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "down",       action = "close" })
hl.gesture({ fingers = 4, direction = "up",         action = "fullscreen" })
hl.gesture({ fingers = 4, direction = "left",       action = "float" })
