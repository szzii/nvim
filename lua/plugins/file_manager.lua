return {
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
	{
		'nvim-telescope/telescope.nvim',
		--version = '0.1.x',
		lazy = false,
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{
				'<leader>F',
				':lua require("functions/telescope-config").find_files_from_project_git_root()<CR>',
				mode = 'n',
				silent = true,
				desc = 'Find Files',
			},
			{
				'<leader>f',
				':lua require("functions/telescope-config").live_grep_from_project_git_root()<CR>',
				mode = 'n',
				silent = true,
				desc = 'Live Grep',
			},
			{
				'<leader>;',
				':Telescope command_history<CR>',
				mode = 'n',
				silent = true,
				desc = 'Cmd History',
			},
			{
				'<leader>s',
				':Telescope noice<CR>',
				mode = 'n',
				silent = true,
				desc = 'Show Noice',
			}
		},
		config = function()
			require('telescope').setup {
				defaults = {
					layout_strategy = 'vertical',
					layout_config = {
						vertical = {
							height = 0.9,
							preview_cutoff = 40,
							prompt_position = "bottom",
							width = 0.85
						}
					},
					mappings = {
						i = {
							["<tab>"] = require('telescope.actions').move_selection_previous,
							["<s-tab>"] = require('telescope.actions').move_selection_next,
							["<C-u>"] = require('telescope.actions').preview_scrolling_up,
							["<C-e>"] = require('telescope.actions').preview_scrolling_down,
							["<C-s>"] = require('telescope.actions').file_split,
							["<C-v>"] = require('telescope.actions').file_vsplit,
							["<C-t>"] = require('telescope.actions').file_tab,
						},
						n = {
							["<tab>"] = require('telescope.actions').move_selection_previous,
							["<s-tab>"] = require('telescope.actions').move_selection_next,
							["<C-u>"] = require('telescope.actions').preview_scrolling_up,
							["<C-e>"] = require('telescope.actions').preview_scrolling_down,
							["u"] = require('telescope.actions').move_selection_previous,
							["e"] = require('telescope.actions').move_selection_next,
							["s"] = require('telescope.actions').file_split,
							["v"] = require('telescope.actions').file_vsplit,
							["t"] = require('telescope.actions').file_tab,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--trim" },
					}
				},
			}
			require("telescope").load_extension("noice")
		end
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = true,
		--version = "2.69",
		keys = {
			{ "<leader>t", ":Neotree toggle <cwd><cr>", desc = "NeoTree", silent = true },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				-- only needed if you want to use the commands with "_with_window_picker" suffix
				's1n7ax/nvim-window-picker',
				version = "v1.*",
				config = function()
					require 'window-picker'.setup({
						autoselect_one = true,
						include_current = false,
						filter_rules = {
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { 'neo-tree', "neo-tree-popup", "notify" },

								-- if the buffer type is one of following, the window will be ignored
								buftype = { 'terminal', "quickfix" },
							},
						},
						other_win_hl_color = '#e35e4f',
					})
				end,
			},

		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				enable_git_status = true,
				enable_diagnostics = true,
				source_selector = {
					winbar = true,
					statusline = false,
					sources = {
						{ source = "filesystem", display_name = " 󰉓 Files " },
						{ source = "buffers", display_name = " 󰉓 Buffers " },
						{ source = "git_status", display_name = " 󰊢 Git " },
					},
				},
				default_component_configs = {
					icon = {
						folder_empty = "󰜌",
						folder_empty_open = "󰜌",
					},
					git_status = {
						symbols = {
							renamed  = "󰁕",
							unstaged = "󰄱",
						},
					},
				},
				document_symbols = {
					kinds = {
						File = { icon = "󰈙", hl = "Tag" },
						Namespace = { icon = "󰌗", hl = "Include" },
						Package = { icon = "󰏖", hl = "Label" },
						Class = { icon = "󰌗", hl = "Include" },
						Property = { icon = "󰆧", hl = "@property" },
						Enum = { icon = "󰒻", hl = "@number" },
						Function = { icon = "󰊕", hl = "Function" },
						String = { icon = "󰀬", hl = "String" },
						Number = { icon = "󰎠", hl = "Number" },
						Array = { icon = "󰅪", hl = "Type" },
						Object = { icon = "󰅩", hl = "Type" },
						Key = { icon = "󰌋", hl = "" },
						Struct = { icon = "󰌗", hl = "Type" },
						Operator = { icon = "󰆕", hl = "Operator" },
						TypeParameter = { icon = "󰊄", hl = "Type" },
						StaticMethod = { icon = '󰠄 ', hl = 'Function' },
					}
				},
				open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
				-- Add this section only if you've configured source selector.
				commands = {
					-- Trash the target
					trash = function(state)
						local tree = state.tree
						local node = tree:get_node()
						if node.type == "message" then
							return
						end
						local _, name = require("neo-tree.utils").split_path(node.path)
						local msg = string.format("Are you sure you want to trash '%s'?", name)
						require("neo-tree.ui.inputs").confirm(msg, function(confirmed)
							if not confirmed then
								return
							end
							vim.api.nvim_command("silent !trash -F " .. node.path)
							require("neo-tree.sources.manager").refresh(state)
						end)
					end,
					-- Trash the selections (visual mode)
					trash_visual = function(state, selected_nodes)
						local paths_to_trash = {}
						for _, node in ipairs(selected_nodes) do
							if node.type ~= 'message' then
								table.insert(paths_to_trash, node.path)
							end
						end
						local msg = "Are you sure you want to trash " .. #paths_to_trash .. " items?"
						require("neo-tree.ui.inputs").confirm(msg, function(confirmed)
							if not confirmed then
								return
							end
							for _, path in ipairs(paths_to_trash) do
								vim.api.nvim_command("silent !trash -F " .. path)
							end
							require("neo-tree.sources.manager").refresh(state)
						end)
					end,

				},
				window = {
					position = "left",
					width = 40,
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					mappings = {
						["i"] = "open",
						["<space>t"] = "close_window",
						["n"] = "close_node",
						["z"] = "close_all_nodes",
						["c"] = nil,
						["cw"] = "rename",
						["e"] = "noop",
						["v"] = "open_vsplit",

						['N'] = "prev_source",
						['I'] = "next_source",
						["d"] = "trash",
					},
				},
				filesystem = {
					follow_current_file = true,
					group_empty_dirs = true,
					window = {
						mappings = {
							["h"] = "toggle_hidden",
						},
						fuzzy_finder_mappings = {
							["<C-e>"] = "move_cursor_down",
							["<C-u>"] = "move_cursor_up",
						},
					},
				},
			})

			vim.cmd([[
				hi NeoTreeGitUntracked gui=NONE guifg=#ff8700
				hi NeoTreeGitConflict gui=bold guifg=#ff8700
			]])
		end
	},

	{
		"theniceboy/joshuto.nvim",
		lazy = true,
		cmd = "Joshuto",
		keys = {
			{ "<leader>2", ":Joshuto<CR>", mode = "n", noremap = true, silent = true, desc = 'Jushuto' },
		},
		config = function()
			-- let g:joshuto_floating_window_winblend = 0
			-- let g:joshuto_floating_window_scaling_factor = 1.0
			-- let g:joshuto_use_neovim_remote = 1 " for neovim-remote support
			vim.g.joshuto_floating_window_scaling_factor = 0.8
			vim.g.joshuto_use_neovim_remote = 1
			vim.g.joshuto_floating_window_winblend = 0
		end
	},
}
