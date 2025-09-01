return {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			input        = { enabled = true },
			animate      = { fps = 60 },
			scroll       = {
				enabled = true,
				animate = {
					duration = { step = 20, total = 420 },
					easing = "inOutQuad",
				},
				animate_repeat = {
					delay = 150,
					duration = { step = 12, total = 240 },
					easing = "inOutQuad",
				},
				filter = function(buf)
					return vim.g.snacks_scroll ~= false
						and vim.b[buf].snacks_scroll ~= false
						and vim.bo[buf].buftype ~= "terminal"
				end,
			},
			indent       = {
				enabled = true
			},

			explorer     = { enabled = false },
			picker       = { enabled = false },
			dashboard    = { enabled = false },
			notifier     = { enabled = false },
			statuscolumn = { enabled = false },
			words        = { enabled = false },
			bigfile      = { enabled = false },
		},
	}
}
