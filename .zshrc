# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

export DOTNET_ROOT=$HOME/.dotnet
export CARGO_ROOT=$HOME/.cargo/bin/
export COMPOSER_ROOT=$HOME/.config/composer/vendor/bin/
export PATH="$PATH:$CARGO_ROOT:$COMPOSER_ROOT:$DOTNET_ROOT:$DOTNET_ROOT/tools"
export NVIM_LARAVEL_ENV=local
# export GTK_IM_MODULE=simple
export GTK_IM_MODULE=simple
# export QT_IM_MODULE=ibus
# export XMODIFIERS=@im=ibus
# export IM_MODULE=ibus

mvnquick() {
  mvn archetype:generate \
    -DgroupId="$1" \
    -DartifactId="$2" \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.5 \
    -DinteractiveMode=false
}

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Inicializar completions
autoload -Uz compinit
compinit

zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='exa -la'
alias la='exa -a'
alias lla='exa -la'
alias lt='exa --tree'
alias ..='cd ..'
alias ...='cd ~'
alias v='nvim'
alias c='clear'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(starship init zsh)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# bun completions
[ -s "/home/ger/.bun/_bun" ] && source "/home/ger/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
