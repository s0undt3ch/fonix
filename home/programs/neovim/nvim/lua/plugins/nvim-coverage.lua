  return {
    -- "andythigpen/nvim-coverage",
    -- "s0undt3ch/nvim-coverage",
    dir = "/home/vampas/projects/s0undt3ch/nvim-coverage/branches/main",
    init = function()
      require("coverage").setup({
        lang = {
          python = {
            only_open_buffers = true,
          },
        },
      })
    end,
  }
