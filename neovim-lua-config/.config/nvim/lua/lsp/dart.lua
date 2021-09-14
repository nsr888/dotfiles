-- dart
require "lspconfig".dartls.setup {
  cmd = {"dart", "/opt/dart-sdk/bin/snapshots/analysis_server.dart.snapshot", "--lsp"},
  on_attach = require "lspconfig".common_on_attach,
  init_options = {
    closingLabels = true,
    flutterOutline = true,
    onlyAnalyzeProjectsWithOpenFiles = false,
    outline = true,
    suggestFromUnimportedLibraries = true
  }
}
