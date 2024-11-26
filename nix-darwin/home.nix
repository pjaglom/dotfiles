# home.nix

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.username = "bear";
  home.homeDirectory = "/Users/bear";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    #".zshrc".source = ../zshrc/.zshrc;
    ".config/alacritty".source = ../alacritty;
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "/Users/bear/config-files/nvim";
    ".config/nix".source = ../nix;
    ".config/nix-darwin".source = ../nix-darwin;
    #".config/tmux".source = ~/.dotfiles/tmux;
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/davish/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

# Not entirely sure what this does. Need to investigate. Source: https://github.com/omerxx/dotfiles/blob/master/nix-darwin/home.nix
#  home.sessionPath = [
#    "/run/current-system/sw/bin"
#      "$HOME/.nix-profile/bin"
#  ];
  # atuin options
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
  # zsh options
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "z"
        "web-search"
        "macos"
        "copypath"
        "copyfile"
        "copybuffer"
        "dirhistory"
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];
    };
    shellAliases = {
      vi="nvim";
      ls="colorls -la";
      ols="ls";
      copilot="gh copilot";
      gcs="gh copilot suggest";
      gce="gh copilot explain";
      update-nix="nix flake update --commit-lock-file";
      switch-nix="darwin-rebuild switch --flake ~/config-files/dotfiles/nix-darwin#macbookpro-2024";
    };
    #theme = "powerlevel10k/powerlevel10k";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

