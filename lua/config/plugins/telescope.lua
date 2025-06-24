return {
  {
    'nvim-telescope/telescope.nvim',
    -- tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' }
    },
    config = function()
      local actions = require 'telescope.actions'
      local builtin = require 'telescope.builtin'
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-k>'] = actions.move_selection_previous, -- move to prev result
              ['<C-j>'] = actions.move_selection_next,     -- move to next result
              ['<C-l>'] = actions.select_default,          -- open file
            },
            n = {
              ['q'] = actions.close,
            },
          },
        },
        pickers = {
          find_files = {
            theme = "ivy"
          }
        },
        extensions = {
          fzf = {}
        }
      }

      require('telescope').load_extension('fzf')

      vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags, { desc = '[H]elp Telescope' })
      vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files, { desc = '[F]ind Files' })
      --
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[S]earch existing [B]uffers' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      --
      vim.keymap.set("n", "<space>en", function()
        local opts = require('telescope.themes').get_dropdown({
          cwd = vim.fn.stdpath("config")
        })
        require('telescope.builtin').find_files(opts)
      end, { desc = "Find in neovim config directory" })

      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end, { desc = "Find in nvim package dir" })


      require("config.telescope.multigrep").setup()
    end
  }
}
