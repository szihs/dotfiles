return {
  cmd = { 'clangd-18', '--background-index' },
  root_markers = { '.clangd', 'compile_commands.json' },
  filetypes = { 'c', 'cpp', 'h', 'hpp' },
}
