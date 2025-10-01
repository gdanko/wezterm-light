local wezterm = require "wezterm"
local environment = {}

function get_kde_appearance()
    local success, stdout = wezterm.run_child_process{
        'kreadconfig5', '--file', 'kdeglobals', 
        '--group', 'General', '--key', 'ColorScheme'
    }
    if success and stdout:match("[Dd]ark") then
        return "dark"
    end
    return "light"
end

function get_appearance()
    if wezterm.gui then
        local xdg_current_desktop = os.getenv("XDG_CURRENT_DESKTOP"):lower()
        if xdg_current_desktop:match('kde') then
            return get_kde_appearance():lower()
        else
            return wezterm.gui.get_appearance():lower()
        end
    end
    return "dark"
end

environment.get_appearance = get_appearance

return environment
