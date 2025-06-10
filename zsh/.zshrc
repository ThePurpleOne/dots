# Zsh History
export HISTFILE=~/.config/zsh/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
export COLORTERM=truecolor
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

bindkey ";5C" forward-word
bindkey ";5D" backward-word
bindkey '5~' kill-word

source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlightning/zsh-syntax-highlighting.zsh

# Miscellaneous Settings
unsetopt beep
bindkey -e

# Aliases
alias cd="z"
alias ls="eza --icons"
alias lla="ls -lah"
alias la="ls -lah"
alias zrc="helix ~/.config/zsh/.zshrc"
alias cdd='cd ..'
alias cddd='cd ../..'
alias pacu="sudo pacman -Syu"
alias pacs="sudo pacman -S"
alias pacr="sudo pacman -R"
alias picomrc="helix ~/.config/picom/picom.conf"
alias alarc="helix ~/.config/alacritty"
alias i3rc="helix ~/.config/i3/config"
alias usage="~/scripts/cpu.sh"

# ---------- THEME ---------- 
PURE_CMD_MAX_EXEC_TIME=2
zstyle :prompt:pure:git:stash show yes

fpath+=($HOME/.config/zsh/pure)
autoload -U promptinit; promptinit
prompt pure
prompt_newline='%666v'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"
