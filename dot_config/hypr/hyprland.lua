-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Keep rounded corners even when an Omarchy toggle changes decoration defaults.
hl.config({
  general = {
    gaps_in = 2,
    gaps_out = 4,
    -- Keep a subtle outline around windows so the focused one is obvious.
    border_size = 3,
  },

  decoration = {
    rounding = 8,
    -- Slightly subdue unfocused windows to make the active one easier to spot.
    dim_inactive = true,
    dim_strength = 0.18,
  },
})

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })
