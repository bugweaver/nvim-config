return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({
				options = {
					globalstatus = true
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff',
						{
							'diagnostics',
							sources = { 'nvim_diagnostic' },
							sections = { 'error', 'warn', 'info', 'hint' },
							diagnostics_color = {
								error = 'DiagnosticError',
								warn  = 'DiagnosticWarn',
								info  = 'DiagnosticInfo',
								hint  = 'DiagnosticHint',
							},
							symbols = {
								error = ' ',
								warn = ' ',
								info = ' ',
								hint = ' ',
							},
							colored = true,
							update_in_insert = false,
							always_visible = false,
						}
					},
					lualine_c = { 'filename' },
					lualine_x = { 'encoding', 'fileformat', 'filetype' },
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				}
			})
		end
	}
}
