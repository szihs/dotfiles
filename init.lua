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


-- Import color theme based on environment variable NVIM_THEME
local default_color_scheme = 'nord'
local env_var_nvim_theme = os.getenv 'NVIM_THEME' or default_color_scheme

-- Define a table of theme modules
local themes = {
  nord = 'plugins.themes.nord',
  onedark = 'plugins.themes.onedark',
}

require('lazy').setup({
    require(themes[env_var_nvim_theme]),
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
    require 'plugins.debug',
    require 'plugins.vim-tmux-navigator',
    require 'plugins.aerial'
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
--vim.o.winborder = 'rounded'

