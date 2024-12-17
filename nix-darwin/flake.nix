{
  description = "Initial nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, homebrew-core, homebrew-cask, home-manager }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true; # allow installation of unfree/paid apps

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
	[ pkgs.alacritty
          pkgs.atuin
	  pkgs.colorls
	  pkgs.curl
          pkgs.discord
	  pkgs.ffmpeg
	  pkgs.git
	  pkgs.gh
	  pkgs.gnupg
	  pkgs.google-chrome
	  pkgs.jq
          pkgs.libfido2
          pkgs.mkalias # have nix make aliases instead of symlinks for installed apps
          pkgs.oh-my-zsh
          pkgs.openssh
	  pkgs.neovim
	  pkgs.raycast
          pkgs.signal-desktop
	  pkgs.slack
        # pkgs.tailscale # commented because did not install desktop version
          pkgs.tmux
        #  pkgs.virtualbox
	  pkgs.wget
          pkgs.wireshark
          pkgs.yubikey-manager
          pkgs.zoom-us
          pkgs.zsh-autosuggestions
          pkgs.zsh-powerlevel10k
          pkgs.zsh-syntax-highlighting
        ];

      homebrew = {
        enable = true;
	brews = [
	  "mas" # note: requires xcode-select, which I could not figure out how to install via nix
	];
	casks = [
          "1password"
          "1password-cli"
          "adobe-acrobat-pro"
          "anki"
          "microsoft-office"
          "microsoft-teams"
	  "orbstack"
	  "orion"
          "tailscale"
          "visual-studio-code@insiders"
          "whatsapp"
	];
	masApps = {
	  "FinalCutPro" = 424389933;
          "Kindle" = 302584613;
	  "Remarkable" = 1276493162;
          "Things 3" = 904280696;
          "Yubico Authenticator" = 1497506650; # Never successfully installed; installed manually
	};
	onActivation.cleanup = "zap";
	onActivation.autoUpdate = true;
	onActivation.upgrade = true;
      };

      fonts.packages = [
        pkgs.meslo-lgs-nf
        pkgs.nerd-fonts.jetbrains-mono
        ];

      # Enable powerlevel10k for zsh
      programs.zsh.promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # script from https://gist.github.com/elliottminns/211ef645ebd484eb9a5228570bb60ec3#file-nix-darwin-activation-nix to set up aliases instead of symlinks
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
            done
          '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;

      # Enable tailscale
        #services.tailscale.enable = true;
      # Enable oh-my-zsh
      #oh-my-zsh = {
      #  enable = true;
      #  plugins = [ ];
      #  theme = "agnoster";
      #};

      # Enable sudo with touch id
      security.pam.enableSudoTouchIdAuth = true;

      # Configure home-manager
      users.users.bear.home = "/Users/bear";
      #home-manager.backupFileExtension = "backup";
      nix.configureBuildUsers = true;
      nix.useDaemon = true;

      # MacOS System Defaults
      system.defaults = {
        dock.autohide = true;
	dock.autohide-delay = 0.0;
	dock.autohide-time-modifier = 0.0;
        dock.mineffect = "scale";
        dock.minimize-to-application = true;
	dock.orientation = "left";
	dock.persistent-apps = [
          "${pkgs.alacritty}/Applications/Alacritty.app"
	  "/System/Applications/Calendar.app"
          "/System/Applications/System Settings.app"
          "/Applications/1Password.app/"
          "/Applications/Orion.app/"
          "/Applications/Safari.app/"
          "/System/Applications/Messages.app/"
          # Apps in Nix Apps folder don't play well in dock
          #"/Applications/Nix Apps/Google Chrome.app"
          #"/Applications/Nix Apps/Slack.app"
          #"/Applications/Nix Apps/Signal.app"
	];
        # Commented out because didn't work well
          #dock.persistent-others = [
          #  "~/Documents"
          #  "~/Downloads"
          #];
        #dock.mru-spaces = false; # commented due to not working right
        finder.AppleShowAllExtensions = true;
        finder.FXEnableExtensionChangeWarning = false;
        finder.FXPreferredViewStyle = "clmv";
        finder.ShowPathbar = true;
        finder.ShowStatusBar = true;
        finder._FXShowPosixPathInTitle = true;
        finder._FXSortFoldersFirst = true;
	loginwindow.GuestEnabled = false;
        loginwindow.LoginwindowText = "Bear's MacBook Pro";
        magicmouse.MouseButtonMode = "TwoButton";
        NSGlobalDomain = {
        "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
        "com.apple.trackpad.enableSecondaryClick" = true;
	AppleICUForce24HourTime = true;
	AppleInterfaceStyle = "Dark";
        InitialKeyRepeat = 15; # commented due to not working right
        KeyRepeat = 2; # commented due to not working right
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        };
        screencapture.location = "~/Pictures/screenshots";
        screensaver.askForPasswordDelay = 5;
        trackpad.TrackpadRightClick = true;
      };

      system.keyboard.enableKeyMapping = true;

      system.keyboard.remapCapsLockToEscape = true;

      # Allow building and running binaries for x86_64 and aarch64 (enabled by Rosetta 2)
      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # Linux builder provided by NixOS VM that works on Apple Silicon & Intel Macs
      nix.linux-builder.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbookpro-2024
    darwinConfigurations."macbookpro-2024" = nix-darwin.lib.darwinSystem {
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
            user = "bear";

            # Optional: Declarative tap management
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };

            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            mutableTaps = true;
          };
        }
	home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.bear = import ./home.nix;
	}
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macbookpro-2024".pkgs;
  };
}
