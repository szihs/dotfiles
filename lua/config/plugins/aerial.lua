return {
  'stevearc/aerial.nvim',
  lazy_load = true,
  opts = {},
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('aerial').setup {
      backends = { "lsp", "treesitter", "markdown", "asciidoc", "man" },
      -- optionally use on_attach to set keymaps when aerial has attached to a buffer
      on_attach = function(bufnr)
        -- Jump forwards/backwards with '{' and '}'
        vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
        vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
      end,

      -- Disable aerial on files with this many lines
      -- disable_max_lines = 1000000,
      -- icons = setmetatable({}, {
      --   __index = function(_, kind)
      --     return kind:sub(1, 1)
      --   end,
      -- }),
      -- Disable aerial on files this size or larger (in bytes)
      disable_max_size = 200000000, -- Default 2MB
      disable_max_lines = 1000000,
      layout = {
        min_width = 30,
      },
    }
    vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle<CR>')
  end,
}
