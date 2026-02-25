{ pkgs, ... }: {
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
    pnpm
    obsidian
    sketchybar
    zellij
    docker
    starship
    fish
    ffmpeg
    discord
    # opencode
    # nodejs_24
  ];

  homebrew = {
    enable = true;

    casks = [
      "iina"
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
  programs.fish.enable = true;


  users.knownUsers = [ "hossein" ];
  users.users.hossein.uid = 501;
  # Set fish as the default shell
  users.users.hossein.shell = pkgs.fish;

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
  system.configurationRevision = null; # self.rev is not available here easily, so setting to null or removing is common in split configs, or pass it via specialArgs if needed. 
  # However, to keep it simple and working without self reference issues in a simple module:
  # We can remove system.configurationRevision for now or set it to null. 
  # The original had: self.rev or self.dirtyRev or null;
  # To support this in a module, we would need to pass 'self' as a specialArg.
  # For now, I'll comment it out or set to null to avoid errors, and we can add it back if you want to pass self.

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
