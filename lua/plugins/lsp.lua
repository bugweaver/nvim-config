return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local lspconfig = require("lspconfig")
			local util = require("lspconfig.util")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
					local opts = { buffer = ev.buf, silent = true, noremap = true }

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Leader>f", function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					local function _open_float_on_jump(diag)
						if diag then
							vim.diagnostic.open_float({ focus = false, border = "rounded" })
						end
					end
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = -1, wrap = true, on_jump = _open_float_on_jump })
					end, opts)
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = 1, wrap = true, on_jump = _open_float_on_jump })
					end, opts)
					vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
					vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, opts)
				end,
			})

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_init = function(client)
					if client.workspace_folders and client.workspace_folders[1] then
						local path = client.workspace_folders[1].name
						if
							path ~= vim.fn.stdpath("config")
							and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
						then
							return
						end
					end
					client.config.settings = client.config.settings or {}
					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
						runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
						diagnostics = { enable = true, globals = { "vim" } },
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
								vim.fn.stdpath("config"),
								"${3rd}/luv/library",
							},
						},
						telemetry = { enable = false },
					})
				end,
				settings = { Lua = {} },
			})

			-- pyright
			lspconfig.pyright.setup({
				capabilities = capabilities,
				root_dir = util.root_pattern("pyrightconfig.json", "pyproject.toml"),
				on_attach = function(client, _)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
				settings = {
					python = {
						analysis = {
							typeCheckingMode = "basic",
							autoImportCompletions = true,
						},
					},
				},
			})

			-- ruff
			lspconfig.ruff.setup({
				capabilities = capabilities,
				root_dir = util.root_pattern("pyproject.toml", "ruff.toml"),
				on_attach = function(client, _)
					client.server_capabilities.hoverProvider = false
				end,
				init_options = {
					settings = {
						organizeImports = true,
						fixAll = true,
						args = {},
					},
				},
			})

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				root_dir = util.root_pattern("tsconfig.json", "package.json", ".git"),
				single_file_support = false, -- не поднимать сервер для одиночных файлов вне проекта
				on_attach = function(client, bufnr)
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false

					if vim.lsp.inlay_hint then
						pcall(vim.lsp.inlay_hint.enable, bufnr, true)
					end

					vim.api.nvim_buf_create_user_command(bufnr, "TSOrganizeImports", function()
						vim.lsp.buf.code_action({
							apply = true,
							context = { only = { "source.organizeImports" }, diagnostics = {} },
						})
					end, {})
				end,
				settings = {
					typescript = {
						suggest = { completeFunctionCalls = true },
						preferences = {
							importModuleSpecifier = "non-relative",
							includePackageJsonAutoImports = "on",
							quotePreference = "single",
						},
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayEnumMemberValueHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayFunctionParameterTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})
		end,
	},
}
