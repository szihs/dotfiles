return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      -- "williamboman/mason.nvim",
    },
    config = function()
      local dap = require "dap"
      local ui = require "dapui"

      require("dapui").setup()

      require("nvim-dap-virtual-text").setup {
        -- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match "secret" or name:match "api" or value:match "secret" or value:match "api" then
            return "*****"
          end

          if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
          end

          return " " .. variable.value
        end,
      }

      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
      }

      dap.configurations.c = {
        {
          name = "Launch",
          type = "gdb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = "${workspaceFolder}",
          stopAtBeginningOfMainSubprogram = false,
          args = function()
            local args_str = vim.fn.input('Arguments: ')
            return vim.split(args_str, ' +')
          end,
        },
        {
          name = "Select and attach to process",
          type = "gdb",
          request = "attach",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          pid = function()
            local name = vim.fn.input('Executable name (filter): ')
            return require("dap.utils").pick_process({ filter = name })
          end,
          cwd = '${workspaceFolder}'
        },
        {
          name = 'Attach to gdbserver :1234',
          type = 'gdb',
          request = 'attach',
          target = 'localhost:1234',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}'
        },
      }
      dap.configurations.cpp = dap.configurations.c
      -- local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
      -- if elixir_ls_debugger ~= "" then
      --   dap.adapters.mix_task = {
      --     type = "executable",
      --     command = elixir_ls_debugger,
      --   }
      --
      --   dap.configurations.elixir = {
      --     {
      --       type = "mix_task",
      --       name = "phoenix server",
      --       task = "phx.server",
      --       request = "launch",
      --       projectDir = "${workspaceFolder}",
      --       exitAfterTaskReturns = false,
      --       debugAutoInterpretAllModules = false,
      --     },
      --   }
      -- end
      --
      vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<space>dr", function()
        require("dapui").open({ reset = true })
      end)

      -- Eval var under curso
      vim.keymap.set("n", "<space><space>q", function()
        require("dapui").eval(nil, { enter = true })
      end)

      vim.keymap.set("n", "<F5>", dap.continue)    -- Continue
      vim.keymap.set("n", "<F11>", dap.step_into)  -- Step Into
      vim.keymap.set("n", "<F10>", dap.step_over)  -- Step Over
      vim.keymap.set("n", "<S-F11>", dap.step_out) -- Step Out (Shift+F11)
      vim.keymap.set("n", "<C-S-F5>", dap.restart) -- Restart (Ctrl+Shift+F5)
      vim.keymap.set("n", "<S-F5>", dap.step_back) -- Step Back (Shift+F5)

      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
