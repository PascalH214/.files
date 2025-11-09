require("config.lazy")
require("oil").setup()

vim.lsp.enable('pyright')
vim.lsp.enable('bashls')
vim.lsp.enable('terraformls')

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

vim.cmd.colorscheme "catppuccin-mocha"

vim.diagnostic.config({
	virtual_text = {
    severity = {
			min = vim.diagnostic.severity.ERROR
		},
  },
	virtual_lines = {
		current_line = false,
    severity = {
			min = vim.diagnostic.severity.ERROR
		},
	},
})

vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float(0, {
    scope = "line",
    severity_sort = true,
  })
end, { desc = "Show diagnostics for current line" })

vim.keymap.set('n', '<leader><Tab>', ':Oil<CR>', { noremap = true, silent = true })
