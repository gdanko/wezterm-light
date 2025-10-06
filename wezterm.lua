local wezterm = require "wezterm"
local color_config = require "color-config"
local config_parser = require "parse-config"
local util = require "util.util"
local act = wezterm.action
local username = os.getenv('USER')
local hostname = wezterm.hostname()
local user_config = config_parser.get_config()

-- Enable/disable config blocks at the top level
config_appearance_enabled   = true
config_color_scheme_enabled = true
config_environment_enabled  = true
config_fonts_enabled        = true
config_general_enabled      = true
config_keys_enabled         = true
config_status_bar_enabled   = true
config_tabs_enabled         = true

-- Define the configuration object
full_config = wezterm.config_builder()

-- General Appearance
local config_appearance = {
    enabled = config_appearance_enabled,
    bold_brightens_ansi_colors = true,
    enable_scroll_bar = true,
    enable_wayland = true,
    front_end = "OpenGL",
    initial_cols = user_config.display.initial_cols,
    initial_rows = user_config.display.initial_rows,
    line_height = 1.0,
    native_macos_fullscreen_mode = false,
    use_resize_increments = true,
    window_background_opacity = user_config.display.window_background_opacity,
    window_padding = user_config.display.window_padding
}

-- Color Scheme
local config_color_scheme = {}
if user_config.display.color_scheme.enable_gradient then
    config_color_scheme = {
        enabled = config_color_scheme_enabled,
        window_background_gradient = {
            orientation   = "Vertical",
            interpolation = "Linear",
            blend         = "Rgb",
            colors        = {"#0f0c29", "#302b63", "#24243e"},
            -- colors        = {"#283b3c", "#26484a", "#215e61"},
        }
    }
else
    config_color_scheme = {
        enabled = config_color_scheme_enabled,
        colors  = color_config.get_color_scheme(
            user_config.display.color_scheme.scheme_name,
            user_config.display.color_scheme.randomize_color_scheme
        )
    }
end

-- Environment
local config_environment = {
    enabled                     = config_environment_enabled,
    audible_bell                = "Disabled",
    automatically_reload_config = true,
    pane_focus_follows_mouse    = true, -- Doesn't seem to work??
    prefer_egl                  = true,
    scroll_to_bottom_on_input   = true,
    scrollback_lines            = 100000,
    term                        = "xterm-256color",
}

-- Fonts
local config_fonts = {
    enabled = config_fonts_enabled,
    window_frame = {
        font = wezterm.font {
            family  = user_config.display.tab_bar_font.family,
            weight  = user_config.display.tab_bar_font.weight,
            stretch = user_config.display.tab_bar_font.stretch,
        },
        font_size = user_config.display.tab_bar_font.size,
    },
    adjust_window_size_when_changing_font_size = false,
    font_size = user_config.display.terminal_font.size,
    font_rasterizer = "FreeType",
    font_shaper = "Harfbuzz",
    font = wezterm.font_with_fallback{
        {
            family  = user_config.display.terminal_font.family,
            weight  = user_config.display.terminal_font.weight,
            stretch = user_config.display.terminal_font.stretch,
        }
    },
    -- https://wezfurlong.org/wezterm/config/lua/config/font_rules.html
    font_rules = {
        {
            italic        = true,
            intensity     = "Normal",
            underline     = "None",
            blink         = "Slow",
            reverse       = true,
            strikethrough = true,
            invisible     = false,
            font          = wezterm.font_with_fallback{
                {
                    family  = user_config.display.terminal_font.family,
                    weight  = user_config.display.terminal_font.weight,
                    stretch = user_config.display.terminal_font.stretch,
                }
            }
        }
    }
}

-- General
local config_general = {
    enabled = config_general_enabled,
    check_for_updates = true,
    check_for_updates_interval_seconds = 86400,
    clean_exit_codes = { 0 },
    default_cwd = wezterm.home_dir,
    exit_behavior = "CloseOnCleanExit",
    exit_behavior_messaging = "Verbose",
    hide_mouse_cursor_when_typing = true,
    notification_handling = "AlwaysShow",
    skip_close_confirmation_for_processes_named = {
        "ash",
        "bash",
        "csh",
        "fish",
        "ksh",
        "sh",
        "tcsh",
        "tmux",
        "zsh",
    },
    window_close_confirmation = "AlwaysPrompt",
}

-- Keys
local config_keys = {
    enabled = config_keys_enabled,
    keys = {
        {
            key = "r",
            mods = user_config.keymod,
            action = wezterm.action.ReloadConfiguration,
        },
        -- Copy all to clipboard #1
        {
            key = "a",
            mods = user_config.keymod,
            action = wezterm.action_callback(function(window, pane)
                local dims = pane:get_dimensions()
                local txt = pane:get_text_from_region(0, dims.scrollback_top, 0, dims.scrollback_top + dims.scrollback_rows)
                window:copy_to_clipboard(txt:match("^%s*(.-)%s*$")) -- trim leading and trailing whitespace
            end)
        },
        -- Copy all to clipboard #2
        -- {
        --     key =  "a",
        --     mods = user_config.keymod,
        --     action = wezterm.action_callback(function(window, pane)
        --         local selected = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)
        --         window:copy_to_clipboard(selected, "Clipboard")
        --     end)
        -- },
        {
            key = "k",
            mods = user_config.keymod,
            action = act.Multiple {
                act.ClearScrollback "ScrollbackAndViewport",
                act.SendKey { key = "L", mods = "CTRL" },
            },
        },
        {
            key = "Enter",
            mods = user_config.keymod,
            action = "ToggleFullScreen"
        },
        {
            key = "t",
            mods = user_config.keymod,
            action=wezterm.action {
                SpawnCommandInNewTab = {
                    cwd = wezterm.home_dir
                }
            }
        },
        {
            key = "n",
            mods = user_config.keymod,
            action = wezterm.action {
                SpawnCommandInNewWindow = {
                    cwd = wezterm.home_dir
                }
            }
        },
        {
            key = "w",
            mods = user_config.keymod,
            action = wezterm.action {
                CloseCurrentTab = {
                    confirm = true
                }
            }
        },
        {
            key = "p",
            mods = user_config.keymod,
            action = wezterm.action.ActivateCommandPalette,
        },

    },
    swap_backspace_and_delete = false,
}

-- Tabs
local config_tabs = {
    enabled = config_tabs_enabled,
    enable_tab_bar = true,
    hide_tab_bar_if_only_one_tab = false,
    show_tab_index_in_tab_bar = true,
    tab_bar_at_bottom = false,
    tab_max_width = 8,
    use_fancy_tab_bar = true,
}

-- Manage the status bar colorization and content
local config_status_bar = {
    wezterm.on('update-right-status', function(window, pane)
        -- This does nothing, but serves as a placeholder
        -- for putting things in the status bar.
    end)
}

-- Tab title
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = util.basename(pane.foreground_process_name)
    local cwd = nil

    if user_config.tabs.title_is_cwd then
        local cwd_uri = pane.current_working_dir
        if cwd_uri then
            cwd = cwd_uri.file_path
            cwd = string.gsub(cwd, wezterm.home_dir, "~")
            if cwd ~= nil then
                title = cwd
            end
        end
    end

    local color = "#41337c"
    if tab.is_active then
        color = "#301f7c"
    elseif hover then
        color = "green"
    end

    return {
        { Background = { Color = color } },
        { Text = util.pad_string(2, 2, title)},
    }
end)

-- Define the different configuration blocks (sections)
configs = {
    config_appearance,
    config_color_scheme,
    config_environment,
    config_fonts,
    config_general,
    config_keys,
    config_status_bar,
    config_tabs,
}

-- Iterate the configuration blocks and if they're enabled, parse them
for index, block in ipairs(configs) do
    if block.enabled ~= nil then
        if block.enabled == true then
            for key, value in pairs(block) do
                -- The key "enabled" is not valid so ignore it
                if key ~= "enabled" then
                    full_config[key] = value
                end
            end
        end
    end
end

return full_config
