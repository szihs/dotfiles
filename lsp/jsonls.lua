return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git', 'package.json' },
  settings = {
    json = {
      format = { enable = true },
      validate = { enable = true }
    }
  }
}
