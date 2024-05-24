require("lspconfig").kotlin_language_server.setup({

	-- cmd = { '/opt/code/forks/kotlin-language-server/server/build/install/server/bin/kotlin-language-server' },
	cmd = { "/opt/kotlin-language-server/bin/kotlin-language-server" },
	init_options = {
		storagePath = "$HOME/.cache/lspcache/",
	},
	-- root_dir = util.root_pattern("build.gradle", "build.gradle.kts")
})
