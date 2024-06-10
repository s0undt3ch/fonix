return {
  "catppuccin/nvim",
  lazy = false,
  init = function()
    local compile_path = vim.fn.stdpath("cache") .. "/catppuccin-nvim"
    vim.fn.mkdir(compile_path, "p")
    vim.opt.runtimepath:append(compile_path)

    require("catppuccin").setup({
      compile_path = compile_path,
      flavour = "mocha",
      term_colors = true,
    })

    vim.api.nvim_command("colorscheme catppuccin-macchiato")
  end,
}
