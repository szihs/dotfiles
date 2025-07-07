return {
  {
    'echasnovski/mini.nvim',
    config = function()
      local statusline = require 'mini.statusline'
      require('mini.files').setup()

      -- Define custom highlight groups for different sections
      vim.api.nvim_set_hl(0, 'StatuslineGit', { fg = '#F38BA8', bg = '#313244', bold = true })
      vim.api.nvim_set_hl(0, 'StatuslineDiff', { fg = '#A6E3A1', bg = '#313244', bold = true })
      vim.api.nvim_set_hl(0, 'StatuslineDiag', { fg = '#FAB387', bg = '#313244', bold = true })
      vim.api.nvim_set_hl(0, 'StatuslineLSP', { fg = '#89B4FA', bg = '#313244', bold = true })
      -- vim.api.nvim_set_hl(0, 'StatuslineAerial', { fg = '#CBA6F7', bg = '#313244', bold = true })
      vim.api.nvim_set_hl(0, 'StatuslineSymbol', { fg = '#F9E2AF', bg = '#313244', bold = true })

      vim.api.nvim_set_hl(0, 'StatuslineAerial', { fg = '#F9E06F', bg = '#313244', bold = true })
      statusline.setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git = statusline.section_git({ trunc_width = 40 })
            local diff = statusline.section_diff({ trunc_width = 75 })
            local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp = statusline.section_lsp({ trunc_width = 75 })
            local filename = statusline.section_filename({ trunc_width = 140 })
            local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
            local location = statusline.section_location({ trunc_width = 75 })
            local search = statusline.section_searchcount({ trunc_width = 75 })

            -- Get LSP server names
            local lsp_names = ""
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients > 0 then
              local client_names = {}
              for _, client in ipairs(clients) do
                table.insert(client_names, client.name)
              end
              lsp_names = "LSP:" .. table.concat(client_names, ",")
            end

            -- Get repository name and branch
            local repo_info = ""
            local git_root = vim.fn.system('git rev-parse --show-toplevel 2>/dev/null'):gsub('\n', '')
            if git_root ~= "" and vim.v.shell_error == 0 then
              -- Get repository name from the root directory
              local repo_name = vim.fn.fnamemodify(git_root, ':t')

              -- Get current branch
              local branch = vim.fn.system('git branch --show-current 2>/dev/null'):gsub('\n', '')
              if branch ~= "" and repo_name ~= "" then
                repo_info = repo_name .. ":" .. branch
              end
            end

            -- Get aerial symbol location and info
            local aerial_info = ""
            local aerial = require("aerial")
            local symbols = aerial.get_location()
            if #symbols > 0 then
              local symbol_details = {}
              for _, symbol in ipairs(symbols) do
                -- Add icon based on symbol kind
                local icon = symbol.icon
                -- if symbol.kind == "Function" then
                --   icon = "󰊕"
                -- elseif symbol.kind == "Method" then
                --   icon = "󰆧"
                -- elseif symbol.kind == "Class" then
                --   icon = "󰠱"
                -- elseif symbol.kind == "Interface" then
                --   icon = "󰜰"
                -- elseif symbol.kind == "Module" then
                --   icon = "󰏗"
                -- elseif symbol.kind == "Variable" then
                --   icon = "󰀫"
                -- elseif symbol.kind == "Constant" then
                --   icon = "󰏿"
                -- elseif symbol.kind == "Struct" then
                --   icon = "󰙅"
                -- elseif symbol.kind == "Enum" then
                --   icon = "󰕘"
                -- elseif symbol.kind == "Constructor" then
                --   icon = "󰆧"
                -- elseif symbol.kind == "Property" then
                --   icon = "󰜢"
                -- elseif symbol.kind == "Field" then
                --   icon = "󰜢"
                -- else
                --   icon = "󰀫"
                -- end

                -- Keep original format but add icon at the beginning
                local detail = symbol.name
                if symbol.kind then
                  detail = detail .. "(" .. symbol.kind .. ")"
                end
                -- Add icon with space before the detail
                if icon ~= "" then
                  detail = icon .. " " .. detail
                end
                table.insert(symbol_details, detail)
              end
              aerial_info = table.concat(symbol_details, " > ")
            end

            -- Get aerial backend info
            local aerial_backend = ""
            local aerial_info_data = aerial.info()
            if aerial_info_data and aerial_info_data.backends and type(aerial_info_data.backends) == "table" then
              local backends = {}
              for _, backend in ipairs(aerial_info_data.backends) do
                if type(backend) == "string" then
                  table.insert(backends, backend)
                end
              end
              if #backends > 0 then
                aerial_backend = "(" .. table.concat(backends, ",") .. ")"
              end
            end

            -- Get current time
            local time = os.date("%H:%M")

            return statusline.combine_groups({
              { hl = mode_hl,          strings = { mode } },
              { hl = 'StatuslineGit',  strings = { git } },
              { hl = 'StatuslineDiff', strings = { diff } },
              { hl = 'StatuslineDiag', strings = { diagnostics } },
              { hl = 'StatuslineLSP',  strings = { lsp, lsp_names } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              { hl = 'StatuslineAerial',       strings = { aerial_info, aerial_backend } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location, time } },
            })
          end,
        },
      })
    end
  }
}
