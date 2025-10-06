local wezterm = require "wezterm"
local util = require "util.util"

local config_parser = {}

-- Recursive function to convert table into "namedtuple-like" table
local function make_namedtuple(t)
    if type(t) ~= "table" then return t end
    local nt = {}
    for k, v in pairs(t) do
        nt[k] = make_namedtuple(v)
    end
    return nt
end

function config_parser.get_config()
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

    -- OS-specific defaults
    if wezterm.target_triple:find("apple") then
        config.keymod = "SUPER"
        config.os_name = "darwin"
    elseif wezterm.target_triple:find("linux") then
        config.keymod = "SHIFT|CTRL"
        config.os_name = "linux"
    end

    -- Apply overrides if present
    if util.file_exists(util.path_join({wezterm.config_dir, "overrides.lua"})) then
        local overrides = require "overrides"
        config = overrides.override_config(config)
    end

    -- Convert to "namedtuple-like" table
    return make_namedtuple(config)
end

return config_parser
