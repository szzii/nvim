return {
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.x',
		lazy = true,
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{
				'<leader>F',
				':lua require("functions/telescope-config").find_files_from_project_git_root()<CR>',
				mode = 'n',
				silent = true,
			},
			{
				'<leader>f',
				':lua require("functions/telescope-config").live_grep_from_project_git_root()<CR>',
				mode = 'n',
				silent = true,
			},
			{
				'<leader>h',
				':Telescope help_tags<CR>',
				mode = 'n',
				silent = true,
			},
		},
		opts = {
			defaults = {
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--trim" },
				}
			},
			extensions = {
			}

		}
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		lazy = true,
		branch = "v2.x",
		keys = {
			{ "<leader>t", ":Neotree toggle<cr>", desc = "NeoTree" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			{
				-- only needed if you want to use the commands with "_with_window_picker" suffix
				's1n7ax/nvim-window-picker',
				tag = "v1.*",
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
		config = function ()
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
							renamed   = "󰁕",
							unstaged  = "󰄱",
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
						["e"] = "move_cursor_down",
						["u"] = "move_cursor_up",
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
		end
	},
}
