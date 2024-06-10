return {
  {
    "craftzdog/solarized-osaka.nvim",
    branch = "osaka",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true,
      }
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
}

--[[
return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    init = function()
      require("onedark").setup({
        style = "warmer",
      })
    end,
  },

  -- Configure LazyVim to load cobalt2
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
]]--
