# Zsh shell configuration with plugins and Starship prompt.
# This sets up a productive shell with autocompletion, syntax highlighting,
# and a minimal but informative prompt.

{ config, pkgs, ... }:

{
  # ---------- Zsh ----------
  programs.zsh = {
    enable = true;

    # Plugins managed by home-manager — no need for oh-my-zsh or zinit
    autosuggestion.enable = true;       # Ghost-text suggestions from history
    syntaxHighlighting.enable = true;   # Color-coded commands as you type
    enableCompletion = true;            # Tab completion

    # Shell aliases — short commands for common operations
    shellAliases = {
      ll = "ls -la";         # Long listing with hidden files
      la = "ls -a";          # List all including hidden
      gs = "git status";     # Quick git status
      gc = "git commit";     # Quick git commit
      gp = "git push";       # Quick git push
    };

    # Extra lines added to .zshrc
    initExtra = ''
      # Disable the default zsh prompt (Starship handles it)
      # Add any custom shell config here
    '';
  };

  # ---------- Starship prompt ----------
  # Starship is a fast, cross-shell prompt written in Rust.
  # It shows git status, language versions, etc. in a minimal format.
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # Minimal configuration — Starship's defaults are already good.
    # This just trims it down to essentials.
    settings = {
      # Prompt format — show only directory, git, and prompt character
      format = "$directory$git_branch$git_status$character";

      # Directory — show up to 3 levels deep, truncate the rest
      directory = {
        truncation_length = 3;
        truncation_symbol = ".../";
      };

      # Git branch — show current branch name
      git_branch = {
        format = "[$branch]($style) ";
        style = "bold purple";
      };

      # Git status — show modified/staged/untracked counts
      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
      };

      # Prompt character — green on success, red on error
      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
      };
    };
  };
}
