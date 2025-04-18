{ username, config, ... }:

{
  # import sub modules
  imports = [
    ./git.nix
    ./shell.nix
  ];

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "24.11";
  };

  home.file.".config/helix" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotconfig/home/helix";
    recursive = true;
  };

  home.file.".config/oh-my-posh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotconfig/home/oh-my-posh";
    recursive = true;
  };

  home.file.".config/aerospace" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotconfig/home/aerospace";
    recursive = true;
  };

  home.file.".config/tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dev/dotconfig/home/tmux";
    recursive = true;
  };

  home.file."Library/KeyBindings" = {
    source = ./key_bindings;
    recursive = true;
  };
  programs.home-manager.enable = true;
}
