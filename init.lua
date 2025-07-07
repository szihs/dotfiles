require("config.lazy")

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x')

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')
-- Resize with arrows
-- vim.keymap.set('n', '<Up>', ':resize -2<CR>')
-- vim.keymap.set('n', '<Down>', ':resize +2<CR>')
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>')

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v')      -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s')      -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=')     -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>') -- close current split window

-- Navigate between splits
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>e', '<cmd>lua MiniFiles.open()<cr>', { desc = 'File explorer' })
-- vim.api.nvim_set_keymap('t', '<C-S-v>', '<C-\\><C-n>"+pi', { noremap = true, silent = true })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP')

vim.cmd [[
nnoremap <space>ss <cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>
]]

-- vim.cmd [[ hi @function.builtin.lua guifg=pink]]

vim.opt.relativenumber = false
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.o.signcolumn = 'auto'

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


vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Terminal Bindings',
  group = vim.api.nvim_create_augroup('custom-terminal', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})


local job_id = 0
vim.keymap.set("n", "<space>cc", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)

  job_id = vim.bo.channel
end)

vim.keymap.set("n", "<space>st", function()
  vim.fn.chansend(job_id, { "cmake --build --preset debug\r\n" })
end)

-- vim.lsp.enable({ 'luals', 'clangd' })
-- local capabilities = require('blink.cmp').get_lsp_capabilities({
--   textDocument = { completion = { completionItem = { snippetSupport = false } } },
-- })
-- vim.lsp.config('*',
--   {
--     capabilities = capabilities,
--     root_markers = { '.git' },
--   }
-- )

local lsp_configs = {}
for _, f in pairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
  local server_name = vim.fn.fnamemodify(f, ':t:r')
  table.insert(lsp_configs, server_name)
end

-- vim.lsp.set_log_level(0)
vim.lsp.enable(lsp_configs)
--
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }
-- vim.diagnostic.config({ virtual_text = true })
vim.diagnostic.config({ virtual_text = { current_line = true } })
vim.o.winborder = 'none'

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.slang", "*.slangh", "*.hlsl", "*.usf", "*.ush", "*.vfx", "*.fxc" },
  callback = function()
    vim.bo.filetype = "slang"
  end,
})

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
