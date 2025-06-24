return {
  {
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      require('mini.files').setup()
      statusline.setup({
        use_icons = true,

        -- content = {
        --   active = function()
        --     -- 1. Call aerial.get_location() to get the list of symbols
        --     local location = require("aerial").get_location()
        --
        --     -- 2. Process the list to create a string
        --     local aerial_parts = {}
        --     for _, symbol in ipairs(location) do
        --       table.insert(aerial_parts, symbol.name)
        --     end
        --     -- Join the names with a separator
        --     local aerial_string = table.concat(aerial_parts, " › ")
        --
        --     -- 3. Combine with other statusline sections
        --     local filename = require("mini.statusline").section_filename()
        --     local git = require("mini.statusline").section_git()
        --
        --     return require("mini.statusline").combine_groups({
        --       { hl = "MiniStatuslineDevinfo", strings = { filename, " ", git } },
        --       "%= ", -- Push to the right
        --       { hl = "MiniStatuslineDevinfo", strings = { aerial_string } },
        --     })
        --   end,
        -- }, --end content
      })
    end
  }
}
