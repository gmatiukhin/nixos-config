{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  history.share = false;
  enableSyntaxHighlighting = true;
  autocd = true;
  shellAliases = {
    update = "sudo nixos-rebuild switch";
    tryit = "nix-shell --run zsh -p";
  };

  zplug = {
    enable = true;
    plugins = [
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
    ];
  };
  # oh-my-zsh = {
  #   enable = true;
  #   plugins = [
  #     "git-auto-fetch"
  #   ];
  # };
  
  initExtraFirst = ''
    # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
    # Initialization code that may require console input (password prompts, [y/n]
    # confirmations, etc.) must go above this block; everything else may go below.
    if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    fi
  '';
  initExtra = ''
    source ~/.p10k.zsh
    unsetopt beep
    bindkey -e # turn off vi mode
    bindkey "^[[1;5C" forward-word # Ctrl+Right
    bindkey "^[[1;5D" backward-word # Ctrl+Left
    # Don't forget about this when tryinig to make vi mode work
    # [Workaround to use surrounds while keeping KEYTIMEOUT=1](https://github.com/softmoth/zsh-vim-mode/issues/33)
  '';
}
