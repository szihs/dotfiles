require 'core.options'
require 'core.keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
	local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
	if vim.v.shell_error ~= 0 then
		error('Error cloning lazy.nvim:\n' .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    require 'plugins.neotree',
    require 'plugins.colortheme',
    require 'plugins.bufferline',	
    require 'plugins.lualine',
    require 'plugins.treesitter',
    require 'plugins.telescope',
    require 'plugins.autocompletion',
    require 'plugins.gitsigns',
    require 'plugins.alpha',
    require 'plugins.misc',
    require 'plugins.indent-blankline',
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = { current_line = true }
})

vim.lsp.enable({"lua-language-server", "clangd"})
vim.cmd("set completeopt+=noselect")
vim.o.winborder = 'rounded'

