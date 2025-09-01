return {
	{
		"mfussenegger/nvim-lint",
		event = { "BufEnter", "BufWritePost", "InsertLeave" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				python = { "ruff" },
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}

			-- Настраиваем eslint_d для работы с flat config
			lint.linters.eslint_d = {
				cmd = "eslint_d",
				stdin = true,
				args = {
					"--format",
					"json",
					"--stdin",
					"--stdin-filename",
					function()
						return vim.api.nvim_buf_get_name(0)
					end,
					-- Добавляем явное указание на использование flat config
					"--config",
					function()
						local config_file = vim.fn.findfile("eslint.config.js", ".;")
						if config_file ~= "" then
							return vim.fn.fnamemodify(config_file, ":p")
						end
						return "eslint.config.js"
					end,
				},
				stream = "stdout",
				ignore_exitcode = true,
				parser = require("lint.linters.eslint_d").parser,
			}

			-- Автокоманда для запуска линтера
			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				callback = function()
					lint.try_lint()
				end,
			})

			-- Команда для ручного запуска линтера
			vim.api.nvim_create_user_command("Lint", function()
				lint.try_lint()
			end, {})
		end,
	},
}
