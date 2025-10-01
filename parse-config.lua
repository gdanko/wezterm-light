local wezterm = require "wezterm"
local util = require "util.util"

local config_parser = {}

function get_config()
    local config = {
        display = {
            tab_bar_font = {
                family  = "Roboto",
                size    = 12,
                stretch = "Normal",
                weight  = "Bold",
            },
            terminal_font = {
                family  = "JetBrains Mono",
                size    = 14,
                stretch = "Normal",
                weight  = "Regular",
            },
            initial_cols = 80,
            initial_rows = 25,
            color_scheme = {
                enable_gradient = false,
                profile = "kitty",
                randomize_color_scheme = false,
                scheme_name = "Novel",
            },
            window_background_opacity = 1,
            window_padding = {
                left   = 10,
                right  = 20,
                top    = 0,
                bottom = 0
            }
        },
        tabs = {
            title_is_cwd = true,
        },
    }

    -- set some OS-specific defaults
    if (wezterm.target_triple == "x86_64-apple-darwin") or (wezterm.target_triple == "aarch64-apple-darwin") then
        config["keymod"] = "SUPER"
        config["os_name"] = "darwin"
    elseif (wezterm.target_triple == "x86_64-unknown-linux-gnu") or (wezterm.target_triple == "aarch64-unknown-linux-gnu") then
        config["keymod"] = "SHIFT|CTRL"
        config["os_name"] = "linux"
    end

    if util.file_exists( util.path_join({wezterm.config_dir, "overrides.lua"})) then
        overrides = require "overrides"
        config = overrides.override_config(config)
    end

    return config
end

config_parser.get_config = get_config

return config_parser