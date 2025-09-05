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
in
lib.mkMerge [
  {
    # Tie to HM version we started with
    home.stateVersion = "25.05";

    home.username = user;
    home.homeDirectory = homeDir;

    # Allow proprietary packages (Postman, Chrome, etc.)
    nixpkgs.config.allowUnfree = true;

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
        cat = "bat --style=plain";
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
      '';
    };

    ############################################
    # Global environment variables
    ############################################
    home.sessionVariables = {
      EDITOR = "nvim";
      PAGER = "less -FRX";
      LANG = "en_US.UTF-8";

      GOPATH = "$HOME/go";
      GOMODCACHE = "$GOPATH/pkg/mod";
      GOROOT = "${pkgs.go}/share/go";
      GOBIN = "$GOPATH/bin";
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

    programs.fzf.enable = true;
    programs.bat.enable = true;
    programs.eza.enable = true;

    # Alacritty config via HM module (more convenient than just package)
    # programs.alacritty = {
    #   enable = true;
    #   settings = {
    #     env = { TERM = "xterm-256color"; };
    #     window.padding = { x = 3; y = 3; };
    #     window.dynamic_padding = true;
    #     window.startup_mode = "Maximized";
    #     window.opacity = 0.97;
    #     font = {
    #       size = 16.0;
    #       bold = { family = "IosevkaTerm Nerd Font"; style = "Bold"; };
    #       normal = { family = "IosevkaTerm Nerd Font"; style = "Regular"; };
    #     };
    #   };
    # };

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
        gcc
        ninja
        pkg-config

        # Python (24.05: python311Packages available)
        python3
        python311Packages.pip
        python311Packages.virtualenv
        python311Packages.pytest
        python311Packages.pynvim
        python311Packages.python-lsp-server
        python311Packages.black
        python311Packages.flake8
        python311Packages.pylint

        # Node
        nodejs
        nodePackages.typescript
        nodePackages.typescript-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.yaml-language-server
        nodePackages.yarn

        # Go and tools (some tools may be missing in 24.05)
        go
        golangci-lint
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
        wl-clipboard # Linux+Wayland
        nixfmt-rfc-style
        nil
        # docker  # installs client; server/groups are better handled at system level

        # UI Apps
        alacritty
        # telegram-desktop
        keepassxc
        # dbeaver-bin
        chromium
        # postman        # unfree

        # Media / misc
        vlc
        transmission_3

        # Fonts (nerdfonts option)
        pkgs.nerd-fonts.iosevka-term

        # Zsh git prompt
        zsh-git-prompt

        vectorcode

      ]
      # ++ [ unstablePkgs.vectorcode ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # Only Linux specific (if you want to separate)
        # pipewire — system service, NOT installed in user profile
        # flatpak/gnome-software-plugin-flatpak — better at system level
      ];

    ############################################
    # Configs (XDG)
    ############################################
    xdg.enable = true;
    xdg.configFile = {
      # Your Neovim config, if stored next to the flake
      "nvim".source = ./nvim;
      # Example: alacritty.yml, if not using HM module for alacritty
      # Manage alacritty config via xdg.configFile to avoid conflicts
      "alacritty/alacritty.yml".source = (pkgs.formats.yaml { }).generate "alacritty.yml" {
        env = {
          TERM = "xterm-256color";
        };
        window = {
          opacity = 1.0;
          padding = {
            x = 5;
            y = 5;
          };
          dynamic_padding = true;
          startup_mode = "Maximized";
          decorations = "none";
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
  })

  # macOS specific:
  (lib.mkIf pkgs.stdenv.isDarwin {
    # example:
    # home.sessionVariables.PATH = "$PATH:/opt/homebrew/bin";
  })
]
