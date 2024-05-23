return {}

--[[
return {
  {
    "linux-cultist/venv-selector.nvim",
    opts = function(_, opts)
    if LazyVim.has("nvim-dap-python") then
      opts.dap_enabled = true
    end
    return vim.tbl_deep_extend("force", opts, {
      name = {
        "venv",
        ".venv",
        "env",
        ".env",
        ".nox/ci-test-onedir/",
      },
    })
  end,
  }
}
]]--
