require("config.lazy")
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- vim.cmd [[ hi @function.builtin.lua guifg=pink]]

vim.opt.shiftwidth = 4
-- press p to paste clip board buffer
vim.opt.clipboard = "unnamedplus"
-- Highlight when yanking text
-- See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})





-- vim.lsp.enable({'luals', 'clangd'})
local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

vim.lsp.enable(lsp_configs)

vim.opt.completeopt = {'menu', 'menuone', 'noinsert', 'noselect'}
-- vim.diagnostic.config({ virtual_text = true })
vim.diagnostic.config({ virtual_text = { current_line = true } })
vim.o.winborder = 'rounded'

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if not client:supports_method('textDocument/willSaveWaitUntil')
      and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
	buffer = ev.buf,
	callback = function()
	  vim.lsp.buf.format({ bufnr = ev.buf, id = client.id, timeout_ms = 1000 })
	end,
      })
    end
  end,
})
