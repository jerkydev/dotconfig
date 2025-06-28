{
  description = "My macOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-24.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, darwin, nixpkgs, home-manager }:
  let
    username = "vladimir";
    useremail = "vyalov.v@gmail.com";
    hostname = "vladimir-macbook-air";
    git_username = "Vladimir Vialov";
    specialArgs =
      inputs
      // {
        inherit username useremail hostname git_username;
      };
    configuration = { pkgs, lib, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        rustup
      ];
      environment.variables.EDITOR = "hx";

      # do garbage collection weekly to keep disk usage low
      nix.gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 7d";
      };

      #  TODO To make this work, homebrew need to be installed manually, see https://brew.sh
      # 
      # The apps installed by homebrew are not managed by nix, and not reproducible!
      # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
      homebrew = {
        enable = true;
        caskArgs.no_quarantine = true;

        onActivation = {
          autoUpdate = true;
          upgrade = true;
          # 'zap': uninstalls all formulae(and related files) not listed here.
          cleanup = "zap";
        };

        taps = [
          "homebrew/services"
          "int128/kubelogin"
          "norwoodj/tap"
          "satrik/togglemute"
          "tilt-dev/tap"
          "fluxcd/tap"
          "derailed/k9s"
          "nikitabobko/tap"
          "FelixKratz/formulae"
        ];

        brews = [
          "bat"
          "dua-cli"
          "duf"
          "eza"
          "fd"
          "fluxcd/tap/flux"
          "fzf"
          "helix"
          "helm"
          "int128/kubelogin/kubelogin"
          "just"
          "k3d"
          "lazydocker"
          {
            name = "libpq";
            link = true;
          }
          "logcli"
          "mactop"
          "mongosh"
          "neofetch"
          "node"
          "norwoodj/tap/helm-docs"
          "oh-my-posh"
          "openssl@3"
          "pkg-config"
          "scc"
          "stern"
          "telnet"
          "tilt-dev/tap/tilt"
          "minikube"
          "kind"
          "unar"
          "xh"
          "zoxide"
          "zsh-autosuggestions"
          "zsh-history-substring-search"
          "derailed/k9s/k9s"
          "tmux"
          "neovim"
          "FelixKratz/formulae/sketchybar"
          "lazygit"
          "watchexec"
          "gnuplot"
        ];

        casks = [
          {
            name = "syncthing";
            greedy = true;
          }
          {
            name = "ghostty";
            greedy = true;
          }
          {
            name = "zoom";
            greedy = true;
          }
          {
            name = "nikitabobko/tap/aerospace";
            greedy = true;
          }
          {
            name = "openzfs";
            greedy = true;
          }
          {
            name = "ukelele";
            greedy = true;
          }
          {
            name = "mqtt-explorer";
            greedy = true;
          }
          {
            name = "homerow";
            greedy = true;
          }
          {
            name = "anki";
            greedy = true;
          }
          {
            name = "dbeaver-community";
            greedy = true;
          }          {
            name = "docker";
            greedy = true;
          }
          {
            name = "firefox";
            greedy = true;
          }
          {
            name = "font-meslo-lg-nerd-font";
            greedy = true;
          }
          {
            name = "google-chrome";
            greedy = true;
          }
          {
            name = "iina";
            greedy = true;
          }
          {
            name = "keepassxc";
            greedy = true;
          }
          {
            name = "mos";
            greedy = true;
          }
          # "orbstack"
          {
            name = "obsidian";
            greedy = true;
          }
          {
            name = "openvpn-connect";
            greedy = true;
          }
          {
            name = "postman";
            greedy = true;
          }
          {
            name = "slack";
            greedy = true;
          }
          {
            name = "spotify";
            greedy = true;
          }
          {
            name = "sublime-text";
            greedy = true;
          }
          {
            name = "telegram";
            greedy = true;
          }
          {
            name = "the-unarchiver";
            greedy = true;
          }
          {
            name = "togglemute";
            greedy = true;
          }
          {
            name = "vial";
            greedy = true;
          }
          {
            name = "visual-studio-code";
            greedy = true;
          }
        ];

        masApps = {
          "Xcode" = 497799835;
        };
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;
      environment.shells = [
        pkgs.zsh
      ];

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      
      # Add ability to use TouchID for sudo authentication
      security.pam.enableSudoTouchIdAuth = true;

      system = {
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 5;
        
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        
        # Activation Scripts are executed every time you boot the system or run `nixos-rebuild` / `darwin-rebuild`.
        activationScripts.postUserActivation.text = ''
          # activateSettings -u will reload the settings from the database and apply them to the current session,
          # so we do not need to logout and login again to make the changes take effect.
          /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
        '';

        # Disable the startup chime on boot
        startup.chime = false;

        defaults = {
          dock = {
            autohide = true;
            autohide-delay = 0.0;  # remove autohide delay, Dock appears instantly
            autohide-time-modifier = 0.0;  # remove autohide animation
            show-recents = false;  # disable recent apps
            showhidden = true;  # make Dock icons of hidden applications translucent
            persistent-apps = [];  # remove all apps from Dock
            mru-spaces = false;  # don't automatically rearrange Spaces based on most recent use
            appswitcher-all-displays = true;  # display the appswitcher on all displays
            minimize-to-application = true;  # minimize windows into their application icon
            mineffect = "scale";  # change minimize/maximize window effect
            expose-animation-duration = 0.1;
          };

          finder = {
            QuitMenuItem = true;  # allow quitting Finder via ⌘ + Q; doing so will also hide desktop icons
            _FXShowPosixPathInTitle = true;  # show full path in finder title
            AppleShowAllExtensions = true;  # show all file extensions
            FXEnableExtensionChangeWarning = false;  # disable warning when changing file extension
            ShowPathbar = true;  # show path bar
            ShowStatusBar = true;  # show status bar
            _FXSortFoldersFirst = true;  # keep folders on top when sorting by name
            FXDefaultSearchScope = "SCcf";  # when performing a search, search in the current folder
            FXPreferredViewStyle = "clmv";  # use column view in all Finder windows by default
          };

          NSGlobalDomain = {
            "com.apple.trackpad.scaling" = 3.0;  # trackpad tracking speed (0.0 - 3.0), default = 1.0
            KeyRepeat = 2;  # minimum is 2 (30 ms), maximum is 120 (1800 ms)
            InitialKeyRepeat = 15;  # minimum is 15 (225 ms), maximum is 120 (1800 ms)          
            AppleShowAllFiles = true;  # show hidden files
            NSDocumentSaveNewDocumentsToCloud = false;  # home directory is opened in the fileviewer dialog when saving a new document instead of iCloud
            AppleFontSmoothing = 1;  # enable subpixel font rendering on non-Apple LCDs

            NSAutomaticCapitalizationEnabled = false;  # disable auto capitalization
            NSAutomaticDashSubstitutionEnabled = false;  # disable auto dash substitution
            NSAutomaticPeriodSubstitutionEnabled = false;  # disable auto period substitution
            NSAutomaticQuoteSubstitutionEnabled = false;  # disable auto quote substitution
            NSAutomaticSpellingCorrectionEnabled = false;  # disable auto spelling correction

            # Expand save panel by default
            NSNavPanelExpandedStateForSaveMode2 = true;           
            NSNavPanelExpandedStateForSaveMode = true;

            # Expand print panel by default
            PMPrintingExpandedStateForPrint = true;
            PMPrintingExpandedStateForPrint2 = true;
          };

          trackpad = {
            Clicking = true;  # enable tap to click
            TrackpadThreeFingerDrag = true;  # enable three finger drag
          };

          screencapture = {
            location = "~/Pictures";
          };

          controlcenter = {
            NowPlaying = false;
          };
          
          ActivityMonitor.ShowCategory = 100;  # show all processes

          spaces.spans-displays = true;
          
          # Customize settings that not supported by nix-darwin directly
          # see the source code of this project to get more undocumented options:
          #    https://github.com/rgcr/m-cli
          # 
          # All custom entries can be found by running `defaults read` command.
          # or `defaults read xxx` to read a specific domain.
          CustomUserPreferences = {
            "~/Library/Preferences/ByHost/com.apple.controlcenter.plist" = {
              "Bluetooth" = 18;  # show bluetooth icon in menu bar
              "BatteryShowPercentage" = 1;  # battery show percentage
            };
            "com.apple.finder" = {
              NewWindowTarget = "PfHm";
              ShowRecentTags = false;
              DisableAllAnimations = true;
            };
            "com.apple.desktopservices" = {
              # Avoid creating .DS_Store files on network or USB volumes
              DSDontWriteNetworkStores = true;
              DSDontWriteUSBStores = true;
            };
            ".GlobalPreferences" = {
              "com.apple.mouse.scaling" = 1.5;
            };
          };
        };
      };
    };
  in
  {
    darwinConfigurations."${hostname}" = darwin.lib.darwinSystem {
      inherit specialArgs;
      modules = [
        configuration
        ./modules/host-users.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.${username} = import ./home;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."${hostname}".pkgs;
  };
}
