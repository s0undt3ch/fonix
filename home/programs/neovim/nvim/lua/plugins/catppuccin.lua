return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  init = function()
    local compile_path = vim.fn.stdpath("cache") .. "/catppuccin-nvim"
    vim.fn.mkdir(compile_path, "p")
    vim.opt.runtimepath:append(compile_path)

    require("catppuccin").setup({
      compile_path = compile_path,
      flavour = "mocha",
      term_colors = true,
    })
  end,
  config = function ()
    vim.cmd([[colorscheme catppuccin-mocha]])
  end,
}
