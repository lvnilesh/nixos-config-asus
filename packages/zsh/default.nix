{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "npm"
        "node"
        "python"
        "sudo"
        "history"
        "command-not-found"
        "z"
        "fzf"
        # Add more plugins as needed
      ];
      # We won't use the built-in themes as we'll use Powerlevel10k
      theme = "";
    };

    # Configure Powerlevel10k
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      # Add more custom plugins if needed
    ];

    # Shell aliases
    shellAliases = {
      # Navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Better ls
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --icons";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      glo = "git log --oneline";

      # System
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#asus"; # Change hostname
      update = "cd ~/nixos-config && nix flake update && sudo nixos-rebuild switch --flake .#asus"; # Change hostname

      # Other helpful aliases
      cat = "bat";
      find = "fd";
      grep = "rg";
      ip = "ip -color=auto";
      k = "kubectl";

      # Add your custom aliases here
    };

    history = {
      save = 10000;
      size = 10000;
    };
    envExtra = ''
      export ZOMEZSHVARIABLE="something";
    '';
    # Add code to run near the end of zsh initialization
    initContent = ''

      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Source Powerlevel10k configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



      # Attempt to remove the ls alias, ignore errors if it doesn't exist
      unalias ls 2>/dev/null || true
      alias ls=eza
      # Add any other custom init commands below

      # Better history searching with arrow keys
      bindkey "^[[A" history-beginning-search-backward
      bindkey "^[[B" history-beginning-search-forward

      # FZF integration
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh

      # Custom functions

      # Create and enter directory
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      # Extract various archive formats
      extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Find text in files
      search() {
        grep -r "$1" .
      }

      # Display weather
      weather() {
        curl -s "wttr.in/$1?m1"
      }

      # Show current directory size
      dirsize() {
        du -sh "$1" 2>/dev/null || echo "Directory not found"
      }

    '';
    # OR use initExtraFirst = '' ... ''; to run earlier
  };
}
