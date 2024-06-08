vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "Add nvim-coverage highlight",
  callback = function()
    vim.cmd([[
        hi CoverageCovered guifg=#b7f071
        hi CoverageUncovered guifg=#f07178
        hi CoveragePartial guifg=#aa71f0
        hi CoverageSummaryHeader gui=bold,underline guisp=fg
        hi! link CoverageSummaryBorder FloatBorder
        hi! link CoverageSummaryNormal NormalFloat
        hi! link CoverageSummaryCursorLine CursorLine
        hi! link CoverageSummaryPass CoverageCovered
        hi! link CoverageSummaryFail CoverageUncovered
      ]])
  end,
})
