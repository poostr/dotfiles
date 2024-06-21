-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.animation_fps = 60
config.max_fps = 60

config.macos_window_background_blur = 5
config.background = {
	{
    source = {Color="#222130"},
		width = "100%",
		height = "100%",
		opacity = 0.9,
	},
}

config.color_scheme = "rose-pine-moon"
config.font = wezterm.font("JetBrains Mono", { italic = false, bold = true })
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.font_size = 20
config.line_height = 1.2
-- config.window_decorations = "NONE"
config.hide_tab_bar_if_only_one_tab = true

config.hyperlink_rules = {
	-- Matches: a URL in parens: (URL)
	{
		regex = "\\((\\w+://\\S+)\\)",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in brackets: [URL]
	{
		regex = "\\[(\\w+://\\S+)\\]",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in curly braces: {URL}
	{
		regex = "\\{(\\w+://\\S+)\\}",
		format = "$1",
		highlight = 1,
	},
	-- Matches: a URL in angle brackets: <URL>
	{
		regex = "<(\\w+://\\S+)>",
		format = "$1",
		highlight = 1,
	},
	-- Then handle URLs not wrapped in brackets
	{
		regex = "\\b\\w+://\\S+[)/a-zA-Z0-9-]+",
		format = "$0",
	},
	-- implicit mailto link
	{
		regex = "\\b\\w+@[\\w-]+(\\.[\\w-]+)+\\b",
		format = "mailto:$0",
	},
}

config.mouse_bindings = {
	-- Disable the default click behavior
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = wezterm.action.DisableDefaultAssignment,
	},
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
	-- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.Nop,
	},
}

config.keys = {
	-- Open url by keys
	{
		key = "b",
		mods = "CMD",
		action = wezterm.action.OpenLinkAtMouseCursor,
	}
}

-- and finally, return the configuration to wezterm
return config
