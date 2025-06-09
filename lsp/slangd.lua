return {
  cmd = { '/home/haaggarwal/.local/bin/slangd' },
  root_markers = { 'slangdconfig.json' },
  filetypes = { 'slang', 'hlsl' },
  settings = {
    slang = {
      additionalSearchPaths = {},   -- Add your include directories here
      predefinedMacros = {},        -- Add any macros you need
      searchInAllWorkspaceDirectories = true
    },
    ["slangLanguageServer.trace.server"] = "verbose",
    ["slangLanguageServer.trace.communication"] = "verbose"
  }
}
