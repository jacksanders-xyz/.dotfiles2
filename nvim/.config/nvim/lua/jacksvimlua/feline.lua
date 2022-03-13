-- FELINE STATUS BAR
--[[
  __      _ _                         _
 / _| ___| (_)_ __   ___   _ ____   _(_)_ __ ___
| |_ / _ \ | | '_ \ / _ \ | '_ \ \ / / | '_ ` _ \
|  _|  __/ | | | | |  __/_| | | \ V /| | | | | | |
|_|  \___|_|_|_| |_|\___(_)_| |_|\_/ |_|_| |_| |_|

	/* IMPORTS */
--]]

-- local highlight = require('highlite').highlight

--[[/* CONSTANTS */]]
local vi_mode_utils = require("feline.providers.vi_mode")
local feline = require("feline")
local _BUF_ICON =
{ -- {{{
	dbui     = '  ',
	diff     = ' 繁',
	help     = '  ',
	NvimTree = ' פּ ',
	packer   = '  ',
	qf       = '  ',
	undotree = '  ',
	vista    = '  ',
	vista_kind = '  ',
	vista_markdown = '  ',
} -- }}}

-- Defined in https://github.com/Iron-E/nvim-highlite
local _BLACK       = {'#202020', 235, 'black'}
local _GRAY        = {'#808080', 244, 'gray'}
local _GRAY_DARK   = {'#353535', 236, 'darkgrey'}
--local _GRAY_DARKER = {'#505050', 239, 'gray'}
local _GRAY_LIGHT  = {'#c0c0c0', 250, 'gray'}
local _WHITE       = {'#ffffff', 231, 'white'}

local _TAN = {'#f4c069', 221, 'yellow'}

local _RED       = {'#ee4a59', 203, 'red'}
local _RED_DARK  = {'#a80000', 124, 'darkred'}
local _RED_LIGHT = {'#ff4090', 205, 'red'}

local _ORANGE       = {'#ff8900', 208, 'darkyellow'}
local _ORANGE_LIGHT = {'#f0af00', 214, 'darkyellow'}

local _YELLOW = {'#f0df33', 227, 'yellow'}

local _GREEN_DARK  = {'#70d533', 113, 'darkgreen'}
local _GREEN       = {'#22ff22', 46,  'green'}
local _GREEN_LIGHT = {'#99ff99', 120, 'green'}
local _TURQOISE    = {'#2bff99', 48,  'green'}
local _BLUE = {'#7766ff', 63,  'darkblue'}
local _CYAN = {'#33dbc3', 80,  'cyan'}
local _ICE  = {'#95c5ff', 111, 'cyan'}
local _TEAL = {'#60afff', 75,  'blue'}

local _MAGENTA      = {'#d5508f', 168, 'magenta'}
local _MAGENTA_DARK = {'#bb0099', 126, 'darkmagenta'}
local _PINK         = {'#ffa6ff', 219, 'magenta'}
local _PINK_LIGHT   = {'#ffb7b7', 217, 'white'}
local _PURPLE       = {'#cf55f0', 171, 'magenta'}
local _PURPLE_LIGHT = {'#af60af', 133, 'darkmagenta'}


local _SIDEBAR = _BLACK
local _MIDBAR = _GRAY_DARK
local _TEXT = _GRAY_LIGHT

local vi_mode_colors = {
    ['COMMAND-LINE'] =       '#ee4a59',
    ['NORMAL EX'] =          '#a80000',
    ['EX'] =                 '#ff4090',
    ['INSERT'] =             '#22ff22',
    ['INS-COMPLETE'] =       '#99ff99',
    ['NORMAL'] =             '#af60af',
    ['OPERATOR-PENDING'] =   '#cf55f0',
    ['HIT-ENTER'] =          '#33dbc3',
    [':CONFIRM'] =           '#33dbc3',
    ['--MORE'] =             '#95c5ff',
    ['REPLACE'] =            '#ffa6ff',
    ['VIRTUAL'] =            '#ffb7b7',
    ['SELECT'] =             '#2bff99',
    ['TERMINAL'] =           '#ff8900',
    ['VISUAL'] =             '#7766ff',
    ['VISUAL LINE'] =        '#7766ff',
    ['VISUAL BLOCK'] =       '#7766ff',
    ['SHELL'] =              '#f0df33',
	-- libmodal
	['STAFF'] = '#f0df33',
	['SCORE'] = '#ee4a59',
}


local _MODES =
{ -- {{{
	['c']  = {'COMMAND-LINE',      _RED},
	['ce'] = {'NORMAL EX',         _RED_DARK},
	['cv'] = {'EX',                _RED_LIGHT},
	['i']  = {'INSERT',            _GREEN},
	['ic'] = {'INS-COMPLETE',      _GREEN_LIGHT},
	['n']  = {'NORMAL',            _PURPLE_LIGHT},
	['no'] = {'OPERATOR-PENDING',  _PURPLE},
	['r']  = {'HIT-ENTER',         _CYAN},
	['r?'] = {':CONFIRM',          _CYAN},
	['rm'] = {'--MORE',            _ICE},
	['R']  = {'REPLACE',           _PINK},
	['Rv'] = {'VIRTUAL',           _PINK_LIGHT},
    ['s']  = {'SELECT',            _TURQOISE},
	['S']  = {'SELECT',            _TURQOISE},
	[''] = {'SELECT',            _TURQOISE},
	['t']  = {'TERMINAL',          _ORANGE},
	['v']  = {'VISUAL',            _BLUE},
	['V']  = {'VISUAL LINE',       _BLUE},
	[''] = {'VISUAL BLOCK',      _BLUE},
	['!']  = {'SHELL',             _YELLOW},

	-- libmodal
	['STAFF'] = _YELLOW,
	['SCORE'] = _RED,
} -- }}}

-- local vi_mode_colors = {
--     ['COMMAND-LINE'] =       _RED,
--     ['NORMAL EX'] =          _RED_DARK,
--     ['EX'] =                 _RED_LIGHT,
--     ['INSERT'] =             _GREEN,
--     ['INS-COMPLETE'] =       _GREEN_LIGHT,
--     -- ['NORMAL'] =             _PURPLE_LIGHT,
--     ['NORMAL'] =             'violet',
--     ['OPERATOR-PENDING'] =   _PURPLE,
--     ['HIT-ENTER'] =          _CYAN,
--     [':CONFIRM'] =           _CYAN,
--     ['--MORE'] =             _ICE,
--     ['REPLACE'] =            _PINK,
--     ['VIRTUAL'] =            _PINK_LIGHT,
--     ['SELECT'] =             _TURQOISE,
--     ['TERMINAL'] =           _ORANGE,
--     ['VISUAL'] =             _BLUE,
--     ['VISUAL LINE'] =        _BLUE,
--     ['VISUAL BLOCK'] =       _BLUE,
--     ['SHELL'] =              _YELLOW,
-- 	-- libmodal
-- 	['STAFF'] = _YELLOW,
-- 	['SCORE'] = _RED,
-- }

local _LEFT_SEPARATOR = ''
local _RIGHT_SEPARATOR = ''

--[[/* HELPERS */]]

--- @return boolean is_not_empty
local function buffer_not_empty()
	return vim.api.nvim_buf_line_count(0) > 1 or #vim.api.nvim_buf_get_lines(0, 0, 1, true) > 0
end

--- @return boolean wide_enough
local function checkwidth()
	return (vim.api.nvim_win_get_width(0) / 2) > 40
end

--- Set buffer variables for file icon and color.
-- local function set_devicons()
-- 	local icon, color = require('nvim-web-devicons').get_icon(vim.fn.expand '%:t', vim.fn.expand '%:e', {default = true})
-- 	vim.b.file_icon = icon
-- 	vim.b.file_color = string.format('#%06x', vim.api.nvim_get_hl_by_name(color, true).foreground)
-- end

--- @return string color
local function file_color()
	-- if not vim.b.file_color then set_devicons() end

	return vim.b.file_color
end

--- @return string icon
local function file_icon()
	-- if not vim.b.file_icon then set_devicons() end

	return vim.b.file_icon
end

-- vim.cmd 'hi clear FelineViMode'

--[[/* FELINE CONFIG */]]

require('feline').setup(
{
	colors = {bg = _MIDBAR[1]},
	components =
	{ -- {{{
		active =
		{
			{ -- Left {{{
				{
					-- icon = '▊ ',
					icon = '▊ ',
                    provider = function() -- auto change color according the vim mode
						-- local mode_color
						local mode_name

                        if vim.g.libmodalActiveModeName then
							mode_name = vim.g.libmodalActiveModeName
							-- mode_color = _MODES[mode_name]
							-- mode_color = vi_mode_colors[mode_name]
						elseif vim.g.libmodalLayerActive == 1 then
							mode_name = "SCORE"
							-- mode_color = vi_mode_colors[mode_name]
							-- mode_color = _MODES[mode_name]
						else
							local current_mode = _MODES[vim.api.nvim_get_mode().mode]
							if not current_mode then
                                current_mode = "error"
                        end
                        mode_name = current_mode[1]
                        -- mode_color = current_mode[2]
                    end
                        return mode_name..' '
                    end,
                    hl = function()
						local mode_color = _MODES[vim.api.nvim_get_mode().mode][2][1]
                        return {
                            fg = "black",
                            bg = mode_color,
                            style = "bold"
                        }

                    end,
                    right_sep = function() return
                        {
                            hl = {fg = _SIDEBAR[1], bg = file_color()},
                            str = _RIGHT_SEPARATOR,
                        }
                    end,
                },

                {
                    hl = function() return {fg = _SIDEBAR[1], bg = file_color()} end,
                    -- provider  = function() return ' '..file_icon()..' ' end,
                    provider  = function() return ' '..' ' end,
                    right_sep = function() return
                            {
                                hl = {fg = _SIDEBAR[1], bg = file_color()},
                                str = _LEFT_SEPARATOR,
                            }
                        end,
                    },

                    {
                        colored_icon = false,
                        enabled = buffer_not_empty,
                        file_modified_icon = '',
					hl = {fg = _TEXT[1], bg = _SIDEBAR[1], style = 'bold'},
					icon = '',
					provider  = 'file_info',
					right_sep =
					{
						hl = {bg = _SIDEBAR[1]},
						str = ' ',
					},
					type = 'relative-short',
				},

				{
					enabled = buffer_not_empty,
					hl = {fg = _TEXT[1], bg = _SIDEBAR[1], style = 'bold'},
					provider  = 'file_size',
					right_sep =
					{
						hl = {bg = _SIDEBAR[1]},
						str = ' ',
					},
				},

				{
					hl = {fg = _SIDEBAR[1], bg = _GREEN_DARK[1], style = 'bold'},
					icon = '  ',
					left_sep =
					{
						always_visible = true,
						hl = {fg = _SIDEBAR[1], bg = _GREEN_DARK[1]},
						str = _RIGHT_SEPARATOR,
					},
					provider = 'git_branch',
				},

				{
					hl = {bg = _MIDBAR[1]},
					left_sep =
					{
						always_visible = true,
						hl = {fg = _MIDBAR[1], bg = _GREEN_DARK[1]},
						str = ' '.._LEFT_SEPARATOR,
					},
					provider = '',
				},

				{
					enabled = checkwidth,
					hl = {fg = _GREEN_LIGHT[1], bg = _MIDBAR[1]},
					icon = '+',
					provider = 'git_diff_added',
				},

				{
					enabled = checkwidth,
					hl = {fg = _ORANGE_LIGHT[1], bg = _MIDBAR[1]},
					icon = '~',
					provider = 'git_diff_changed',
				},

				{
					enabled = checkwidth,
					hl = {fg = _RED_LIGHT[1], bg = _MIDBAR[1]},
					icon = '-',
					provider = 'git_diff_removed',
				},

				{
					hl = {fg = _RED[1], bg = _MIDBAR[1]},
					icon = ' Ⓧ ',
					provider = 'diagnostic_errors',
				},

				{
					hl = {fg = _YELLOW[1], bg = _MIDBAR[1]},
					icon = ' ⚠️ ',
					provider = 'diagnostic_warnings',
				},

				{
					hl = {fg = _MAGENTA[1], bg = _MIDBAR[1]},
					icon = ' 💡',
					provider = 'diagnostic_hints',
				},

				{
					hl = {fg = _WHITE[1], bg = _MIDBAR[1]},
					icon = ' ⓘ ',
					provider = 'diagnostic_info',
				},
			}, -- }}}

			{{ -- Middle {{{
				enabled = function() return checkwidth() and vim.lsp.buf.server_ready() end,
				hl = {fg = _ICE[1], bg = _MIDBAR[1]},
				icon = ' ',
				provider = function() return vim.b.vista_nearest_method_or_function or '' end,
			}}, -- }}}

			{ -- Right {{{
				{
					hl = {fg = _TEXT[1], bg = _SIDEBAR[1]},
					left_sep =
					{
						hl = {fg = _MIDBAR[1], bg = _SIDEBAR[1]},
						str = _RIGHT_SEPARATOR..' ',
					},
					provider = 'file_encoding',
					right_sep =
					{
						hl = {bg = _SIDEBAR[1]},
						str = ' ',
					},
				},

				{
					hl = function() return {fg = _BLACK[1], bg = file_color(), style = 'bold'} end,
					left_sep = function() return
						{
							hl = {fg = file_color(), bg = _SIDEBAR[1]},
							str = _LEFT_SEPARATOR,
						}
					end,
					provider = 'file_type',
					right_sep = function() return
						{
							hl = {fg = file_color(), bg = _SIDEBAR[1]},
							str = _RIGHT_SEPARATOR..' ',
						}
					end,
				},

				{
					enabled = buffer_not_empty,
					hl = {fg = _TEXT[1], bg = _SIDEBAR[1]},
					provider = function()
						return ' '..(vim.api.nvim_win_get_cursor(0)[2] + 1)
					end,
				},

				{
					hl = {fg = _WHITE[1], bg = _MAGENTA_DARK[1]},
					left_sep =
					{
						hl = {fg = _MAGENTA_DARK[1], bg = _SIDEBAR[1]},
						str = ' '.._LEFT_SEPARATOR,
					},
					provider = 'line_percentage',
					right_sep =
					{
						hl = {bg = _MAGENTA_DARK[1]},
						str = ' ',
					},
				},

				{
					hl = {fg = _GRAY[1], bg = _MAGENTA_DARK[1]},
					provider = 'scroll_bar',
				},
			}, -- }}}
		},

		inactive =
		{
			{ -- Left {{{
				{
					hl = {fg = _BLACK[1], bg = _PURPLE[1], style = 'bold'},
					left_sep =
					{
						hl = {bg = _PURPLE[1]},
						str = ' ',
					},
					provider = 'file_type',
				},
				{
					hl = {bg = _PURPLE[1]},
					provider = ' ',
					right_sep =
					{
						hl = {fg = _PURPLE[1], bg = _MIDBAR[1]},
						str = _RIGHT_SEPARATOR,
					},
				},
			}, -- }}}

			{{ -- Right {{{
				hl = {fg = _BLACK[1], bg = _PURPLE[1], style = 'bold'},
				left_sep =
				{
					hl = {fg = _PURPLE[1], bg = _MIDBAR[1]},
					str = _LEFT_SEPARATOR,
				},
				provider = function(_, win_id) return _BUF_ICON[vim.bo[vim.api.nvim_win_get_buf(win_id or 0)].filetype] or '' end,
			}}, -- }}}
		},
	}, -- }}}

	force_inactive =
	{ -- {{{
		bufnames = {},
		buftypes = {'help', 'prompt', 'terminal'},
		filetypes =
		{
			'dbui',
			'diff',
			'help',
			'NvimTree',
			'packer',
			'qf',
			'undotree',
			'vista',
			'vista_kind',
			'vista_markdown',
		},
	}, -- }}}
})



-- OLD CONFIG:
-- local feline = require("feline")

-- -- Initialize the components table
-- local components = {
-- active = {},
-- inactive = {}
-- }
-- require('feline').setup()
-- local gruvbuddy = {
-- 	fg = "#ebdbb2",
-- 	bg = "#32302f",
-- 	black = "#32302f",
--     white = '#f2e5bc',
--     red = '#cc6666',
--     pink = '#fef601',
--     green = '#99cc99',
--     yellow = '#f8fe7a',
--     blue = '#81a2be',
--     aqua = '#8ec07c',
--     cyan = '#8abeb7',
--     purple = '#8e6fbd',
--     violet = '#b294bb',
--     orange = '#de935f',
--     brown = '#a3685a',
--     seagreen = '#698b69',
--     turquoise = '#698b69',
-- }


-- feline.use_theme(gruvbuddy)

-- local colorbuddy = {
--     NORMAL = Color.green,
--     INSERT = Color.red,
--     VISUAL = Color.magenta,
--     OP = Color.green,
--     BLOCK = Color.blue,
--     REPLACE = Color.violet,
--     ['V-REPLACE'] = Color.violet,
--     ENTER = Color.cyan,
--     MORE = Color.cyan,
--     SELECT = Color.orange,
--     COMMAND = Color.green,
--     SHELL = Color.green,
--     TERM = Color.green,
--     NONE = Color.yellow
-- }

-- local colorbuddy = {
--     green = Color.green,
--     red = Color.red,
--     magenta = Color.magenta,
--     blue = Color.blue,
--     violet = Color.violet,
--     cyan = Color.cyan,
--     orange = Color.orange,
--     yellow = Color.yellow
-- }

-- local feline_gruvbox = {
-- 	fg = "#ebdbb2",
-- 	bg = "#32302f",
-- 	black = "#32302f",
-- 	skyblue = "#83a598",
-- 	cyan = "#a89984",
-- 	green = "#98971a",
-- 	oceanblue = "#458588",
-- 	magenta = "#fb4934",
-- 	orange = "#d65d0e",
-- 	red = "#fb4934",
-- 	violet = "#b16286",
-- 	white = "#ebdbb2",
-- 	yellow = "#d79921",
-- }
-- feline.use_theme(feline_gruvbox)
