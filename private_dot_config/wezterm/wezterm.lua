local wezterm = require("wezterm")
local act = wezterm.action
--local utf8 = require("utf8")


-- local VIM_ICON = utf8.char(0xe62b)

local mykeys = {
  {
    key = "t",
    mods = "ALT",
    action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }),
  },
  {
    key = "w",
    mods = "ALT",
    action = wezterm.action({ CloseCurrentTab = { confirm = false } }),
  },
  { key = "UpArrow", mods = "SHIFT", action = wezterm.action({ ScrollByLine = -5 }) },
  { key = "DownArrow", mods = "SHIFT", action = wezterm.action({ ScrollByLine = 5 }) },
  { key = "=", mods = "CTRL", action = "IncreaseFontSize" },
  { key = "-", mods = "CTRL", action = "DecreaseFontSize" },
  { key = "0", mods = "CTRL", action = "ResetFontSize" },
  {
    key = "C",
    mods = "CTRL|SHIFT",
    action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }),
  },
  {
    key = "V",
    mods = "CTRL|SHIFT",
    action = wezterm.action({ PasteFrom = "Clipboard" }),
  },
  { key = "Z", mods = "CTRL", action = "TogglePaneZoomState" },
  {
    key = ",",
    mods = "ALT",
    action = wezterm.action({ ActivateTabRelative = -1 }),
  },
  {
    key = ".",
    mods = "ALT",
    action = wezterm.action({ ActivateTabRelative = 1 }),
  },
  { key = "l", mods = "ALT", action = "ShowLauncher" },
  { key = "X", mods = "SHIFT|ALT", action = "ActivateCopyMode" },
  { key = " ", mods = "SHIFT|ALT", action = "QuickSelect" },
  { key = "r", mods = "ALT", action = "ReloadConfiguration" },
  { key = "q", mods = "ALT", action = "QuitApplication" },
}
for i = 1, 8 do
  table.insert(mykeys, {
    key = tostring(i),
    mods = "ALT",
    action = wezterm.action({ ActivateTab = i - 1 }),
  })
end

-- ssh
local ssh_launch_menu = {}
--local ssh_cmd = {"ssh"}
local ssh_config_file = wezterm.home_dir .. "/.ssh/config"
local f = io.open(ssh_config_file)
if f then
  local line = f:read("*l")
  while line do
    if line:find("Host ") == 1 then
      local host = line:gsub("Host ", "")
      table.insert(ssh_launch_menu, {
        label = "SSH " .. host,
        args = { "ssh", host },
      })
    end
    line = f:read("*l")
  end
  f:close()
end


return {
  use_ime = true,
  default_prog = { "/usr/bin/zsh", "-l" },
  set_environment_variables = {
    --		LANG = "zh_CN.UTF-8",
    PATH = wezterm.executable_dir .. ";" .. os.getenv("PATH"),
  },
  launch_menu = {
    {
      label = "Bottom",
      args = { "btm" },
    },
    {
      label = "htop",
      args = { "htop" },
    },
  },
  exit_behavior = "Close",
  --font = wezterm.font("InconsolataLGC Nerd Font Mono", {weight="Bold", italic=false}),
  font = wezterm.font_with_fallback({
    { family = "InconsolataLGC Nerd Font Mono", weight = "Medium" },
    { family = "FiraCode Nerd Font Mono" },
    "Noto Sans SC",
    "MiSans",
    "Noto Sans Symbols",
  }),
  front_end = "OpenGL",
  font_size = 20,
  color_scheme = "Catppuccin Macchiato",

  -- Tab bar
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  show_tabs_in_tab_bar = true,
  show_new_tab_button_in_tab_bar = true,
  tab_max_width = 20,
  --tab_bar_at_bottom = true,
  hide_tab_bar_if_only_one_tab = true,
  enable_scroll_bar = true,

  window_padding = {
    left = 4,
    right = 4,
    top = 0,
    bottom = 2,
  },

  initial_cols = 96,
  initial_rows = 32,
  colors = {
    tab_bar = {
      background = "#2e3440",
      active_tab = {
        bg_color = "#5e81ac",
        fg_color = "#eceff4",
        intensity = "Bold",
        italic = true,
      },
      inactive_tab = { bg_color = "#4c566a", fg_color = "#d8dee9" },
      inactive_tab_hover = {
        bg_color = "#d8dee9",
        fg_color = "#3b4252",
        italic = false,
      },
      new_tab = { bg_color = "#3b4252", fg_color = "#a3be8c" },
      new_tab_hover = {
        bg_color = "#3b4252",
        fg_color = "#8fbcbb",
        italic = false,
      },
    },
  },
  enable_wayland = true,
  text_background_opacity = 1.0,
  scrollback_lines = 1000,
  default_cursor_style = "BlinkingBlock",
  cursor_blink_rate = 750,
  automatically_reload_config = true,

  disable_default_key_bindings = true,

  mouse_bindings = {
    -- Right click sends "woot" to the terminal
    {
      event = { Down = { streak = 1, button = 'Right' } },
      mods = 'NONE',
      action = act.PasteFrom("PrimarySelection"),
    },

    -- Change the default click behavior so that it only selects
    -- text and doesn't open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.CompleteSelection 'PrimarySelection',
    },

    -- and make CTRL-Click open hyperlinks
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
    },
    -- NOTE that binding only the 'Up' event can give unexpected behaviors.
    -- Read more below on the gotcha of binding an 'Up' event only.
  },

  keys = mykeys,
  window_background_opacity = 0.96,
  -- window_background_image = "/home/ayamir/Pictures/wezterm/nord.jpg",
  -- window_background_image_hsb = {
  --     brightness = 2.0,
  --     hue = 1.0,
  --     saturation = 1.0
  -- }
}
