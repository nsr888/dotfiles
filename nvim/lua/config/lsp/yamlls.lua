return {
	filetypes = { "yaml", "yaml.docker-compose", "yml" },
	settings = {
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/lamoda/gonkey/master/gonkey.json"] = "/tests/cases/*/*/*",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/docker-compose.y*",
				["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "/.gitlab-ci.yml",
			},
		},
	},
}
