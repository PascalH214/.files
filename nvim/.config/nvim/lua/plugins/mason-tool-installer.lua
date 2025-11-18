return {
  'WhoIsSethDaniel/mason-tool-installer.nvim',
  config = function()
    require("mason-tool-installer").setup({
      ensure_installed = {
        "ansible-lint",
        "markdownlint",
        "eslint_d",
        "tflint",
      },
      auto_update = true,
    })
  end,
}
