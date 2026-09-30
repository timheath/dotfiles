-- Build treesitter parsers and wait for them to finish. For headless runs
-- (install.sh):
--
--   nvim --headless "+Lazy! sync" "+luafile scripts/ts-build.lua" +qa
--
-- LazyVim's nvim-treesitter build hook starts the parser rebuild in the
-- background, so a plain `+Lazy! sync +qa` quits before anything compiles and
-- leaves old parsers running against the updated queries.

local TIMEOUT = 10 * 60 * 1000
local ts = LazyVim.treesitter

local function warn(msg)
  io.stderr:write("ts-build: " .. msg .. "\n")
end

-- Same tree-sitter CLI setup as LazyVim's build hook (installs it with mason
-- if needed)
local cli_ready = false
ts.ensure_treesitter_cli(function()
  cli_ready = true
end)
vim.wait(5 * 60 * 1000, function()
  return cli_ready
end, 100)

local ok, health = ts.check()
if not ok then
  local missing = {}
  for tool, have in pairs(health) do
    if not have then
      missing[#missing + 1] = tool
    end
  end
  table.sort(missing)
  return warn("skipped parser build; missing " .. table.concat(missing, ", "))
end

local TS = require("nvim-treesitter")

-- Install any missing ensure_installed parsers, then rebuild outdated ones.
-- Parsers the build hook is already compiling are waited on, not rebuilt.
local langs = LazyVim.opts("nvim-treesitter").ensure_installed or {}
local done, err = TS.install(langs, { summary = true }):pwait(TIMEOUT)
if not done then
  warn("install failed: " .. tostring(err))
end
done, err = TS.update(nil, { summary = true }):pwait(TIMEOUT)
if not done then
  warn("update failed: " .. tostring(err))
end
