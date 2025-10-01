local wezterm = require "wezterm"
local util = require "util.util"

color_config = {}

function select_random_scheme(all_color_schemes)
    local keys = {}
    local n = 0
    for k, _ in pairs(all_color_schemes) do
        n = n + 1
        keys[n] = k
    end
    local index = math.random(0, #(keys))
    return keys[index]
end

function get_color_scheme(profile_name, scheme_name, randomize_color_scheme)
    if profile_name == nil or (profile_name ~= "iterm2" and profile_name ~= "kitty") then
        profile_name = "kitty"
    end
    wezterm.log_info(profile_name)

    local color_scheme_map = {}
    local default_color_scheme = {
        background   = "#dfdbc3",
        cursor_bg    = "#73635a",
        cursor_fg    = "#000000",
        foreground   = "#3b2322",
        selection_bg = "#000000",
        selection_fg = "#a4a390",
        ansi         = {"#000000", "#cc0000", "#009600", "#d06b00", "#0000cc", "#cc00cc", "#0087cc", "#cccccc"},
        brights      = {"#7f7f7f", "#cc0000", "#009600", "#d06b00", "#0000cc", "#cc00cc", "#0086cb", "#ffffff"},
    }

    local schemes_filename = util.path_join({wezterm.config_dir, "color-schemes-" .. profile_name .. ".json"})
    local all_color_schemes = util.json_parse(schemes_filename)
    if all_color_schemes ~= nil then
        if randomize_color_scheme then
            scheme_name = select_random_scheme(all_color_schemes)
        end

        if all_color_schemes[scheme_name] ~= nil then
            scheme = all_color_schemes[scheme_name]
            color_scheme_map = {
                ansi         = scheme["ansi"],
                background   = scheme["background"],
                brights      = scheme["brights"],
                cursor_bg    = scheme["cursor_bg"],
                cursor_fg    = scheme["cursor_fg"],
                foreground   = scheme["foreground"],
                selection_bg = scheme["selection_fg"],
                selection_fg = scheme["selection_bg"],
            }
        else
            color_scheme_map = default_color_scheme
        end
    else
        color_scheme_map = default_color_scheme
    end
    return color_scheme_map
end

color_config.get_color_scheme = get_color_scheme

return color_config
