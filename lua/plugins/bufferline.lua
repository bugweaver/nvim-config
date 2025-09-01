return {
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('bufferline').setup {
				options = {
					mode = "buffers",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local s = ""
						for e, n in pairs(diagnostics_dict) do
							local sym = ({ error = "  ", warning = "  ", info = "  ", hint = "  " })[e] or ""
							s = s .. sym .. n
						end
						return s
					end,
					offsets = {
						{
							filetype = "neo-tree",
							text = "File Explorer",
							highlight = "Directory",
							separator = true
						}
					},
					-- separator_style = "slant",
					show_buffer_close_icons = true,
					show_close_icon = true,
					show_tab_indicators = true,
					persist_buffer_sort = true,
					always_show_bufferline = true,

					--close_command = function(bufnr)
					--if bufnr == vim.api.nvim_get_current_buf() then
					--	vim.cmd('bp | bd #')
					--else
					--	vim.cmd('bd ' .. bufnr)
					--end
					--end,
				}
			}
		end
	}
}
