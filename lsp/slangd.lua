return {
  cmd = { '/home/haaggarwal/.local/bin/slangd' },
  root_markers = { 'slangdconfig.json' },
  filetypes = { 'slang', 'hlsl' },
  settings = {
    slang = {
      additionalSearchPaths = {},
      predefinedMacros = {},
      searchInAllWorkspaceDirectories = true
    },
    -- capabilities = {
    --   textDocument = {
    --     semanticTokens = nil -- vim.empty_dict() -- Explicitly disable semantic tokens
    --   }
    -- },
    slangLanguageServer = {
      trace = {
        server = "verbose"
      }
    }
  },
}
