{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, ... }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget

        nixpkgs.config.allowUnfree = true;

        environment.systemPackages = with pkgs; [
          neovim
          tmux
          stow
          vscode
          uv
          nixd
          cargo
          htop
          raycast
          firefox
          brave
          ollama
          aerospace
          unar
          yarn
          pnpm
        ];

        homebrew = {
          enable = true;
          casks = [
            "iina"
            "docker"
            "ghostty"
          ];
          # onActivation.cleanup = "zap"; # Clean up casks on activation
        };

        fonts.packages = with pkgs; [
          # Use the following to install a font:
          # $ nix-env -iA nixpkgs.fonts.<font-name>
          # e.g. $ nix-env -iA nixpkgs.fonts.fira-code
          fira-code
          jetbrains-mono
          source-code-pro
        ];

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        system.primaryUser = "hossein";
        system.defaults = {
          dock.autohide = true;
          # dock.persistent-apps = [];
          finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "clmv";
          };
          NSGlobalDomain.KeyRepeat = 2;
          NSGlobalDomain.AppleInterfaceStyle = "Dark";
        };

        # Set Git commit hash for darwin-version.
        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        system.stateVersion = 6;

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

      };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#m2pro
      darwinConfigurations."m2pro" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "hossein";

              # Automatically migrate existing Homebrew installations
              autoMigrate = true;
            };
          }
        ];
      };
    };
}
