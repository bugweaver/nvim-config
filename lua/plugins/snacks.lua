return {
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			input = { enabled = true },
			animate = { fps = 60 },
			scroll = {
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
			indent = { enabled = true },

			-- Git
			gitbrowse = { enabled = true },
			git = {
				enabled = true,
				blame_line = {
					width = 0.6,
					height = 0.6,
					border = "rounded",
					title = "Git Blame",
					title_pos = "center",
					ft = "git",
				},
			},
			lazygit = { enabled = true },

			-- Notifier / layout
			notifier = { enabled = true },
			layout = {
				width = 0.6,
				height = 0.6,
				border = "rounded",
				zindex = 50,
				fullscreen = false,
			},

			explorer = { enabled = false },
			picker = { enabled = false },
			dashboard = { enabled = false },
			statuscolumn = { enabled = false },
			words = { enabled = false },
			bigfile = { enabled = false },
		},

		keys = {
			{
				"<leader>gb",
				function()
					require("snacks").git.blame_line()
				end,
				desc = "Git Blame (line)",
				mode = "n",
				silent = true,
			},

			{
				"<leader>go",
				function()
					require("snacks").gitbrowse()
				end,
				desc = "Git Browse (open in remote)",
				mode = "n",
				silent = true,
			},

			{
				"<leader>gg",
				function()
					require("snacks").lazygit()
				end,
				desc = "LazyGit",
				mode = "n",
				silent = true,
			},

			-- На будущее
			-- { "<leader>gs", "<cmd>Snacks picker git_status<cr>",   desc = "Git Status",   mode = "n", silent = true },
			-- { "<leader>gc", "<cmd>Snacks picker git_log<cr>",      desc = "Git Commits",  mode = "n", silent = true },
			-- { "<leader>gB", "<cmd>Snacks picker git_branches<cr>", desc = "Git Branches", mode = "n", silent = true },
			-- { "<leader>gS", "<cmd>Snacks picker git_stash<cr>",    desc = "Git Stash",    mode = "n", silent = true },
		},
	},
}
