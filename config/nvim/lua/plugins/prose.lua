-- Tone down "code-like" auto-editing in prose buffers.
--
-- nvim-ts-autotag auto-closes HTML/XML tags: typing `<filename>` immediately
-- inserts `</filename>`. LazyVim aliases the `markdown` filetype to `html`, so
-- this fires while writing Markdown too, which is rarely wanted for prose.
--
-- LazyVim's blink.cmp defaults also pull LSP, snippets, and buffer words on
-- every keyword, which is noisy and easy to accept by accident while writing.
--
-- This spec:
--   1. Disables tag auto-close/rename for prose filetypes (markdown, text,
--      gitcommit, gitrebase, rst, org). mini.pairs bracket/quote pairing is
--      left untouched.
--   2. Restricts blink.cmp sources in those filetypes to path completions
--      only (no lsp, snippets, or buffer words). Auto-show and keymaps are
--      unchanged, so path candidates still appear while typing paths and
--      <C-space> still works — both only for path.
--   3. Adds a per-buffer toggle (`:AutoCloseTagsToggle`, `<leader>ut`) so you
--      can turn tag auto-close back on for the current buffer when you do want
--      it (e.g. an HTML-heavy Markdown doc, or a plain-text file you're treating
--      as markup).
--
-- Note: of the prose filetypes above, only `markdown` actually has an autotag
-- config, so it's the only one where tags were being auto-closed. The others
-- are listed for completeness/future-proofing and are harmless no-ops.

local PROSE_FILETYPES = { "markdown", "text", "gitcommit", "gitrebase", "rst", "org" }

local function is_prose()
  return vim.tbl_contains(PROSE_FILETYPES, vim.bo.filetype)
end

-- Build the per_filetype override table: disable every autotag behavior.
local disabled = { enable_close = false, enable_rename = false, enable_close_on_slash = false }
local per_filetype = {}
for _, ft in ipairs(PROSE_FILETYPES) do
  per_filetype[ft] = disabled
end

-- Add/remove the buffer-local insert-mode `>` map that performs tag auto-close.
-- This mirrors nvim-ts-autotag's own attach logic (internal.lua) so a toggled-on
-- buffer behaves exactly like a normally-enabled one, without mutating global
-- plugin config.
local function set_autoclose(buf, enable)
  local ok, internal = pcall(require, "nvim-ts-autotag.internal")
  if not ok then
    return
  end
  if enable then
    -- Ensure the buffer's tag patterns are registered (no-op if already attached).
    internal.attach(buf)
    vim.keymap.set("i", ">", function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      vim.api.nvim_buf_set_text(buf, row - 1, col, row - 1, col, { ">" })
      internal.close_tag()
      vim.api.nvim_win_set_cursor(0, { row, col + 1 })
    end, { noremap = true, silent = true, buffer = buf, desc = "Auto-close tag" })
  else
    pcall(vim.keymap.del, "i", ">", { buffer = buf })
    pcall(vim.keymap.del, "i", "/", { buffer = buf })
  end
  vim.b[buf].autoclose_tags = enable
end

local function toggle_autoclose()
  local buf = vim.api.nvim_get_current_buf()
  -- If the buffer already has the insert-mode `>` map, it's currently on.
  local currently_on = vim.b[buf].autoclose_tags
  if currently_on == nil then
    currently_on = vim.fn.maparg(">", "i") ~= ""
  end
  set_autoclose(buf, not currently_on)
  vim.notify(
    "Tag auto-close " .. (not currently_on and "enabled" or "disabled") .. " for this buffer",
    vim.log.levels.INFO
  )
end

return {
  {
    "windwp/nvim-ts-autotag",
    opts = {
      per_filetype = per_filetype,
    },
    keys = {
      -- `ut` = (u)i-toggle, (t)ag. Change this if you enable the
      -- treesitter-context extra, which also claims <leader>ut.
      { "<leader>ut", toggle_autoclose, desc = "Toggle tag auto-close (buffer)" },
    },
    config = function(_, opts)
      require("nvim-ts-autotag").setup(opts)
      vim.api.nvim_create_user_command("AutoCloseTagsToggle", toggle_autoclose, {
        desc = "Toggle HTML/XML tag auto-close for the current buffer",
      })
    end,
  },

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      -- Preserve LazyVim / extra sources when not in a prose buffer. LazyVim's
      -- default is { "lsp", "path", "snippets", "buffer" }; other extras may
      -- already have replaced this with a function.
      local previous = opts.sources.default
      opts.sources.default = function(ctx)
        if is_prose() then
          return { "path" }
        end
        if type(previous) == "function" then
          return previous(ctx)
        end
        return previous or { "lsp", "path", "snippets", "buffer" }
      end
    end,
  },
}
