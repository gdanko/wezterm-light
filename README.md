# wezterm-light
 This is a lighter, less complicated version of my [WezTerm](https://wezterm.org) configuration [repo](https://github.com/bananazon/wezterm). While the other one does work, it does a lot and has many moving parts. Not everyone will want all of its features.

 ## Requirements
 * wezterm on either Darwin or Linux. I don't have a Windows computer to test on.

## Features
There really aren't many. I've made it modular, though. Inside of `wezterm.lua` you will see
```
config_appearance_enabled   = true
config_color_scheme_enabled = true
config_environment_enabled  = true
config_fonts_enabled        = true
config_general_enabled      = true
config_keys_enabled         = true
config_status_bar_enabled   = true
config_tabs_enabled         = true
```
If you set any of these to `false`, their section won't be loaded at runtime.

 ## Installation
 ### Clone the repo in ~/.config
```
cd ~/.config
git clone https://github.com/gdanko/wezterm-light wezterm
```

### Create an `overrides.lua` File
1. `cp overrides.SAMPLE.lua overrides.lua`
2. `vim overrides.lua` (Yeah I'm a [vim](https://www.vim.org) fan)
