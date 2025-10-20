{
  config,
  lib,
  pkgs,
  unstablePkgs,
  ...
}:

let
  user = "anasyrov";
  homeDir = "/home/${user}";
  npmGlobal = "${config.home.homeDirectory}/.npm-global";

  # Overlay for custom Go packages
  go-overlay = self: super: {
    go_1_23 = unstablePkgs.go_1_23;
    golangci-lint_1_63_4 = super.buildGoModule {
      pname = "golangci-lint";
      version = "1.63.4";

      src = super.fetchFromGitHub {
        owner = "golangci";
        repo = "golangci-lint";
        rev = "v${self.golangci-lint_1_63_4.version}";
        hash = "sha256-7nIo6Nuz8KLuQlT7btjnTRFpOl+KVd30v973HRKzh08=";
      };

      vendorHash = "sha256-atr4HMxoPEfGeaNlHqwTEAcvgbSyzgCe262VUg3J86c=";

      subPackages = [ "." ];

      ldflags = [
        "-s"
        "-w"
        "-X main.version=${self.golangci-lint_1_63_4.version}"
        "-X main.commit=unknown"
        "-X main.date=unknown"
      ];

      meta = with super.lib; {
        description = "Fast linters runner for Go";
        homepage = "https://golangci-lint.run/";
        license = licenses.gpl3Only;
        maintainers = with maintainers; [ ];
      };
    };
  };

  # Apply the overlay
  customPkgs = pkgs.extend go-overlay;
in
lib.mkMerge [
  {
    # Tie to HM version we started with
    home.stateVersion = "25.05";

    home.username = lib.mkDefault user;
    home.homeDirectory = lib.mkDefault homeDir;

    # Allow proprietary packages (Postman, Chrome, etc.)
    nixpkgs.config.allowUnfree = false;

    programs.home-manager.enable = true;

    ############################################
    # Shell / Zsh
    ############################################
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        vi = "nvim";
        vim = "nvim";
        k = "kubectl";
        l = "eza";
        la = "eza -a";
        ll = "eza -lah";
        ls = "eza --color=auto";
      };

      initContent = ''
        # Ensure .zprofile is always sourced, even in non-login shells
        if [ -f "$HOME/.zprofile" ]; then
          source "$HOME/.zprofile"
        fi

        # Enable zsh-git-prompt
        source ${pkgs.zsh-git-prompt}/share/zsh-git-prompt/zshrc.sh
        ZSH_GIT_PROMPT_FORCE_BLANK=1

        # Set the prompt
        export PROMPT='%n@%m:%~ $(git_super_status)%# '

        # kubectl completion for zsh
        if command -v kubectl >/dev/null 2>&1; then
          source <(kubectl completion zsh)
          alias k=kubectl
          compdef _kubectl k
        fi

        # History
        setopt hist_ignore_all_dups
        setopt hist_save_no_dups
        setopt hist_ignore_dups
        export HISTSIZE=1000000
        export SAVEHIST=1000000
        export HISTTIMEFORMAT="%F %T "

        setopt extended_history          # save timestamp & duration
        setopt inc_append_history        # write as you go
        setopt share_history             # share across sessions
        setopt hist_ignore_all_dups
        setopt hist_save_no_dups
        setopt hist_ignore_dups
        setopt hist_ignore_space         # commands starting with space aren't saved
        setopt hist_reduce_blanks
        setopt hist_verify               # don't auto-execute from history

        # ---------- Small QoL ----------
        setopt auto_cd                   # `..` or a path jumps there
        setopt no_beep
        setopt interactive_comments      # allow comments in interactive shell
        setopt no_nomatch                # wildcards that match nothing don't error

        # Optional: bind Ctrl-Backspace to delete-word (often handy)
        bindkey '^H' backward-kill-word
        bindkey "^A" vi-beginning-of-line
        bindkey "^E" vi-end-of-line

        llm -s "respond with 3 choices that can be ran directly on command line, no formatting" --save cli
        llm_cli(){
            emulate -L zsh
            zle -M "$(uvx --with llm-anthropic llm --key $ANTHROPIC_API_KEY -m claude-3.5-sonnet -t cli $BUFFER)"
        }
        zle -N llm_cli
        bindkey '^[l' llm_cli   # ^[ is ESC, so Meta-l
      '';
    };

    ############################################
    # Global environment variables
    ############################################
    home.sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less -FRX";
      LANG = "en_US.UTF-8";

      PATH = "$PATH:$GOPATH/bin:$GOROOT/bin";
      FZF_DEFAULT_COMMAND = "rg --files --hidden --follow --glob '!.git'";
      KUBECONFIG = "$HOME/.kube/config";
    };

    ############################################
    # Tools and programs
    ############################################
    programs.git = {
      enable = true;
      userName = "Artur Nasyrov";
      userEmail = builtins.getEnv "GIT_AUTHOR_EMAIL";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;
      # Plugins can be added through flakes/xdg.configFile, keeping base setup
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true; # ^R history / ^T files / Alt-C cd
    };

    programs.bat.enable = true;
    programs.eza.enable = true;

    # direnv (if you use it)
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    ############################################
    # User packages (profile)
    ############################################
    home.packages =
      with pkgs;
      [
        # Build tools
        git
        cmake
        unzip
        wget
        gnumake
        ninja
        pkg-config

        # Python (24.05: python311Packages available)
        uv
        python3
        python311Packages.pip
        python311Packages.virtualenv
        python311Packages.pytest
        python311Packages.pynvim
        python311Packages.python-lsp-server
        python311Packages.black
        python311Packages.flake8
        python311Packages.pylint
        python311Packages.llm
        python311Packages.llm-anthropic

        # Node
        nodejs
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.yaml-language-server
        nodePackages.yarn
        nodePackages.prettier

        # Go and tools (some tools may be missing in 24.05)
        (customPkgs.go_1_23)
        (customPkgs.golangci-lint_1_63_4)
        gopls
        gofumpt
        # gci golines yamlfmt — check in your nixpkgs branch, can be added via nixpkgs-unstable overlay if needed

        # Rust
        rustc
        cargo
        stylua

        # Dev tools
        protobuf
        kubectl
        kubernetes-helm
        nixfmt-rfc-style
        nil
        # docker  # installs client; server/groups are better handled at system level

        # Fonts (nerdfonts option)
        pkgs.nerd-fonts.iosevka-term

        # Zsh git prompt
        zsh-git-prompt

        k9s
        ripgrep

      ]
      # ++ [ unstablePkgs.vectorcode ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # Only Linux specific (if you want to separate)
        # pipewire — system service, NOT installed in user profile
        # flatpak/gnome-software-plugin-flatpak — better at system level
        gcc
        wl-clipboard # Linux+Wayland
        xclip
      ];

    home.sessionPath = [ "${npmGlobal}/bin" ];

    # do the install with an explicit prefix so it never touches /nix/store
    home.activation.installClaudeCode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${npmGlobal}"
      "${pkgs.nodejs}/bin/npm" --userconfig "$HOME/.npmrc" \
        --prefix "${npmGlobal}" -g install @anthropic-ai/claude-code
    '';

    ############################################
    # Configs (XDG)
    ############################################
    xdg.enable = true;
    xdg.configFile = {
      # Your Neovim config, if stored next to the flake
      "nvim".source = ./nvim;
      # Example: alacritty.yml, if not using HM module for alacritty
      # Manage alacritty config via xdg.configFile to avoid conflicts
      "alacritty/alacritty.toml".source = (pkgs.formats.toml { }).generate "alacritty.toml" {
        env = {
          TERM = "xterm-256color";
          WINIT_UNIX_BACKEND = "wayland"; # Force Wayland backend if available
        };
        keyboard = {
          bindings = [
              # macOS-like (Super mapped by keyd to send Insert variants)
              { key = "Insert"; mods = "Control"; action = "Copy"; }   # Super+C (keyd -> Ctrl+Insert)
              { key = "Insert"; mods = "Shift";   action = "Paste"; }  # Super+V (keyd -> Shift+Insert) use CLIPBOARD now
              # Optional: keep legacy PRIMARY access
              { key = "Y";      mods = "Control|Shift"; action = "PasteSelection"; } # Explicit primary if needed
              # Standard terminal shortcuts (still available)
              { key = "C"; mods = "Control|Shift"; action = "Copy"; }
              { key = "V"; mods = "Control|Shift"; action = "Paste"; }
              # (Super variants directly, if you also press them without keyd translation)
              { key = "C"; mods = "Super"; action = "Copy"; }
              { key = "V"; mods = "Super"; action = "Paste"; }
          ];
        };
        terminal = {
          shell = {
            program = "${pkgs.zsh}/bin/zsh";
            args = [ "-l" ];
          };
        };
        selection = {
          save_to_clipboard = true;
        };
        window = {
          opacity = 1.0;
          padding = {
            x = 5;
            y = 5;
          };
          dynamic_padding = true;
          startup_mode = "Windowed";
          decorations = "Full";
          resize_increments = true;
        };
        font = {
          size = if pkgs.stdenv.isLinux then 14.0 else 16.0;
          bold = {
            family = "IosevkaTerm Nerd Font";
            style = "Bold";
          };
          normal = {
            family = "IosevkaTerm Nerd Font";
            style = "Regular";
          };
        };
      };
    };
  }

  # Linux specific:
  (lib.mkIf pkgs.stdenv.isLinux {
    # example:
    # home.packages = [ pkgs.wl-clipboard ];
    xdg.configFile = {
      "keyd/default.conf".source = ./keyd/default.conf;
      # XKB option: CapsLock becomes Ctrl
      "kxkbrc".text = ''
        [Layout]
        Options=ctrl:nocaps
        ResetOldOptions=true
        LayoutList=us,ru
      '';
      # Key repeat: delay (ms) and rate (chars/sec)
      "kcminputrc".text = ''
        [Keyboard]
        RepeatDelay=250
        RepeatRate=40
      '';
    };

    home.sessionVariables = {
      GOPATH = "${config.home.homeDirectory}/go";
      GOMODCACHE = "${config.home.homeDirectory}/go/pkg/mod";
      GOROOT = "${customPkgs.go_1_23}/share/go";
      GOBIN = "${config.home.homeDirectory}/go/bin";
      GOCACHE = "${config.home.homeDirectory}/.cache/go-build";
    };
  })

  # macOS specific:
  (lib.mkIf pkgs.stdenv.isDarwin {
    # example:
    # home.sessionVariables.PATH = "$PATH:/opt/homebrew/bin";
    home.sessionVariables = {
      GOPATH = "$HOME/go";
      GOMODCACHE = "$HOME/Library/Caches/go/mod";
      GOROOT = "${customPkgs.go_1_23}/share/go";
      GOBIN = "$HOME/go/bin";
      GOCACHE = "$HOME/Library/Caches/go-build";
      LD = "/usr/bin/ld";
    };
  })
]
