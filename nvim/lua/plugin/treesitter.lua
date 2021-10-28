require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {
    "beancount",
    "bibtex",
    "clojure",
    "commonlisp",
    "cuda",
    "devicetree",
    "dot",
    "erlang",
    "elm",
    "elixir",
    "fennel",
    "fish",
    "fortran",
    "gdscript",
    "glimmer",
    "glsl",
    "godot",
    "heex",
    "julia",
    "java",
    "hcl",
    "ledger",
    "llvm",
    "nix",
    "pioasm",
    "ql",
    "r",
    "rst",
    "scala",
    "sparql",
    "supercollider",
    "surface",
    "svelte",
    "teal",
    "tlaplus",
    "turtle",
    "kotlin",
    "latex",
    "ocaml",
    "ocamllex",
    "ocaml_interface",
    "verilog",
    "ruby",
    "yang",
    "zig"
  }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {"latex"} -- list of language that will be disabled
  }
}
