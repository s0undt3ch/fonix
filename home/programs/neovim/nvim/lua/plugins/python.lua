local M = {}

local path = require('lspconfig.util').path

-- TODO:
-- https://github.com/neovim/nvim-lspconfig/wiki/Project-local-settings
-- nvim_lsp.rust_analyzer.setup {
--   on_init = function(client)
--     client.config.settings.xxx = "yyyy"
--     client.notify("workspace/didChangeConfiguration")
--     return true
--   end
-- }

local function get_pipenv_dir()
  return vim.fn.trim(vim.fn.system 'pipenv --venv')
end

local function get_poetry_dir()
  return vim.fn.trim(vim.fn.system 'poetry env info -p')
end

local function get_pdm_package()
  return vim.fn.trim(vim.fn.system 'pdm info --packages')
end

local function get_python_dir(workspace)
  local poetry_match = vim.fn.glob(path.join(workspace, 'poetry.lock'))
  if poetry_match ~= '' then
    return get_poetry_dir()
  end

  local pipenv_match = vim.fn.glob(path.join(workspace, 'Pipfile.lock'))
  if pipenv_match ~= '' then
    return get_pipenv_dir()
  end

  -- Find and use virtualenv in workspace directory.
  local site_packages_paths = {}
  for _, pattern in ipairs { '*', '.*', '.nox/ci-test*' } do
    local pattern_path = path.join(workspace, pattern, 'pyvenv.cfg')
    local match = vim.fn.glob(pattern_path)
    local matches = vim.split(match, '\n', {trimempty=true})
    print("matches", matches)
    if match ~= '' then
      for _, l_match in ipairs(matches) do
        local venv = path.dirname(l_match)
        print("VENV", venv, "|")
        -- local site_packages_pattern = path.join(venv, "lib", "*", "site-packages", "*.py")
        local site_packages_pattern = path.join(workspace, pattern, "lib", "*", "site-packages", "_virtualenv.py")
        print("Processing pattern", site_packages_pattern, '|')
        local site_packages_pattern_match = vim.fn.glob(site_packages_pattern)
        print("SITE Match", site_packages_pattern_match, '|')
        if site_packages_pattern_match ~= '' then
          local sp_matches = vim.split(site_packages_pattern_match, '\n', {trimempty=true})
          -- return sp_matches
          for _, sp_match in ipairs(sp_matches) do
            local site_packages_path = path.dirname(sp_match)
            print("SITE PATH FINAL", site_packages_path, "|")
            table.insert(site_packages_paths, site_packages_path)
          end
        end
      end
    end
  end

  print("DIRS", site_packages_paths)
  local s = ""
  for k, v in pairs(site_packages_paths) do
    s = s .. k .. ":" .. v .. "\n" -- concatenate key/value pairs, with a newline in-between
  end
  print("SSS", s)

  local seen = {}
  local final_site_packages_paths = {}
  for _, v in pairs(site_packages_paths) do
    if (not seen[v]) then
      table.insert(final_site_packages_paths, v)
      seen[v] = true
    end
  end

  local ss = ""
  for k, v in pairs(site_packages_paths) do
    ss = ss .. k .. ":" .. v .. "\n" -- concatenate key/value pairs, with a newline in-between
  end
  print("SSS 2", ss)
  return final_site_packages_paths
end

local _virtual_env = ''
local _package = ''

local function py_bin_dir()
  if is_windows then
    return path.join(_virtual_env, 'Scripts;')
  else
    return path.join(_virtual_env, 'bin:')
  end
end

local function env(root_dir)
  if not vim.env.VIRTUAL_ENV or vim.env.VIRTUAL_ENV == '' then
    _virtual_env = get_python_dir(root_dir)
  end

  if _virtual_env ~= '' then
    vim.env.VIRTUAL_ENV = _virtual_env
    vim.env.PATH = py_bin_dir() .. vim.env.PATH
  end

  if _virtual_env ~= '' and vim.env.PYTHONHOME then
    vim.env.old_PYTHONHOME = vim.env.PYTHONHOME
    vim.env.PYTHONHOME = ''
  end

  return _virtual_env ~= '' and py_bin_dir() or ''
end

-- PEP 582 support
M.pep582 = function(root_dir)
  local pdm_match = vim.fn.glob(path.join(root_dir, 'pdm.lock'))
  if pdm_match ~= '' then
    _package = get_pdm_package()
  end

  if _package ~= '' then
    return path.join(_package, 'lib')
  end
end

M.conda = function(root_dir) end

return {
-- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        pyright = {
          settings = {
    python = {
      analysis = {
        -- diagnosticMode = 'workspace', -- ["openFilesOnly", "workspace"]
        -- typeCheckingMode = 'off', -- ["off", "basic", "strict"]
        useLibraryCodeForTypes = true,
        completeFunctionParens = true,
        extraPaths = {".nox/ci-test-onedir/lib/python3.10/site-packages"}
      },
    },
  },
  --[[
  before_init = function(_, config)
    -- config.settings.python.pythonPath = "python"
    config.settings.python.analysis.extraPaths = env(config.root_dir)
  end,
  ]]--

  -- before_init = function(params, config)
  --   py.env(config.root_dir)
  --   config.settings.python.analysis.extraPaths = { py.pep582(config.root_dir) }
  -- end,
  --[[
  on_new_config = function(new_config, new_root_dir)
    -- print("New config", new_config, "New Root dir", new_root_dir)
    -- M.env(new_root_dir)
    --local python_exe = get_nox_virtualenv_python_exe(new_root_dir)
    -- print("PY", python_exe)
    -- new_config.settings.python.pythonPath = python_exe
    new_config.settings.python.pythonPath = "python"
    -- new_config.cmd_env.PATH = M.env(new_root_dir) .. new_config.cmd_env.PATH
    -- new_config.settings.python.analysis.extraPaths = { M.pep582(new_root_dir) }
    new_config.settings.python.analysis.extraPaths = env(new_root_dir)
  end,
          ]]--
        },
      },
    },
  },
}
