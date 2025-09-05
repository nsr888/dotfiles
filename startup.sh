#!/usr/bin/env bash
set -euo pipefail

# Detect OS → choose HM profile name
case "$(uname -s)" in
  Linux)  PROFILE="artur-linux" ;;
  Darwin) PROFILE="artur-macos" ;;
  *) echo "Unsupported OS: $(uname -s)"; exit 1 ;;
esac

# 1) Install Nix if missing (official commands)
if ! command -v nix >/dev/null 2>&1; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    echo "[Nix] Installing (multi-user)…"
    sh <(curl -L https://nixos.org/nix/install) --daemon    # Linux
  else
    echo "[Nix] Installing…"
    sh <(curl -L https://nixos.org/nix/install)             # macOS
  fi
fi

# 2) Load Nix environment for this shell (works for multi-user and single-user)
if [[ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
  # multi-user install
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [[ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  # single-user install
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# 3) Ensure flakes are enabled on non-NixOS systems (safe if already set)
if [[ "$(uname -s)" != "Linux" || ! -f /etc/NIXOS ]]; then
  sudo mkdir -p /etc/nix
  if ! grep -q "experimental-features" /etc/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf >/dev/null
  fi
fi

# 4) Switch Home Manager using flake (no channels, pinned to HM release)
#    Pick a release that matches your target (e.g., 25.05). You can also use 'master'.
HM_REF="github:nix-community/home-manager?ref=release-25.05"

echo "[Home Manager] Switching to profile '$PROFILE'…"
nix run "$HM_REF" -- switch --flake ".#$PROFILE"

echo "✅ Done."
