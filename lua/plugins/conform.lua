return {
	{
		"stevearc/conform.nvim",
		opts = {},
		config = function()
			local util = require("conform.util")

			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "ruff_organize_imports", "ruff_format" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					yaml = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					markdown = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
				},
				formatters = {
					prettier = {
						command = function()
							-- Путь к Mason prettier
							local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/prettier"
							if vim.fn.executable(mason_bin) == 1 then
								return mason_bin
							end
							-- Fallback на глобальный prettier
							return "prettier"
						end,
						args = { "--stdin-filepath", "$FILENAME" },
						stdin = true,
						cwd = util.root_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs",
							"package.json",
						}),
						require_cwd = false,
						exit_codes = { 0, 1 },
					},
				},
				-- Форматирование при сохранении
				format_on_save = function(bufnr)
					-- Отключаем для node_modules
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if bufname:match("/node_modules/") then
						return nil
					end

					-- Отключаем если нет форматтера
					local formatters = require("conform").list_formatters(bufnr)
					if #formatters == 0 then
						return nil
					end

					return {
						timeout_ms = 1000,
						lsp_fallback = true,
					}
				end,
			})

			-- Команда для форматирования
			vim.api.nvim_create_user_command("Format", function(args)
				local range = nil
				if args.count ~= -1 then
					local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
					range = {
						start = { args.line1, 0 },
						["end"] = { args.line2, end_line:len() },
					}
				end
				require("conform").format({ async = true, lsp_fallback = true, range = range })
			end, { range = true })

			-- Команда для отладки
			vim.api.nvim_create_user_command("ConformDebug", function()
				local formatters = require("conform").list_formatters(0)
				if #formatters > 0 then
					for _, formatter in ipairs(formatters) do
						if formatter.available then
							print(string.format("✓ %s: %s", formatter.name, formatter.command or "command"))
						else
							print(string.format("✗ %s: not available", formatter.name))
						end
					end
				else
					print("No formatters for this buffer")
				end
			end, {})
		end,
	},
}
