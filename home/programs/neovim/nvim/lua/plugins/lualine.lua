return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  init = function()
    require("lualine").setup({
      options = {
        theme = "onedark",
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
    })
  end,
}
