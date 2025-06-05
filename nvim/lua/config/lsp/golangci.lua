return {
	cmd = { "golangci-lint-langserver" },
	init_options = {
		command = { "golangci-lint", "run", "--out-format", "json" },
	},
}
