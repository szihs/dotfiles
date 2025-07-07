return {
  cmd = { "pyright-langserver", "--stdio" }, -- ADD THIS LINE
  filetypes = { 'python' },
  settings = {
    python = {
      analysis = {
        typeCheckingMode       = "basic", -- "off", "basic", "strict"
        autoSearchPaths        = true,
        diagnosticMode         = "openFilesOnly",
        useLibraryCodeForTypes = true,
      },
      venvPath = ".",
      venv     = ".venv",
    },
    pyright = { disableTaggedHints = false },
  },
  root_dir = vim.fs.dirname(vim.fs.find(
    { "pyproject.toml", "setup.cfg", "requirements.txt", ".git" },
    { upward = true })[1]),
}
