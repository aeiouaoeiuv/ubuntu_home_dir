# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster_random"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Remove forward-char widgets from ACCEPT
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#vi-forward-char}")

# Add forward-char widgets to PARTIAL_ACCEPT
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(vi-forward-char)

plugins=(
    git
    jump
    zsh-autosuggestions
    zsh-history-substring-search
    zsh-syntax-highlighting # must be the last plugin sourced
)

source $ZSH/oh-my-zsh.sh

bindkey "^[h" backward-char                 # Alt+h
bindkey "^[j" down-line-or-search           # Alt+j
bindkey "^[k" up-line-or-search             # Alt+k
bindkey "^[l" forward-char                  # Alt+l
bindkey "^[." autosuggest-accept            # Alt+.
bindkey "^J"  autosuggest-execute           # Ctrl+J
bindkey "^[]" history-substring-search-down # Alt+]
bindkey "^[[" history-substring-search-up   # Alt+[

[[ $TMUX = "" ]] && export TERM="xterm-256color"

# man page color
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[38;5;37;1m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;24;48;5;148;1m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[38;5;11;1m'
export LESS_TERMCAP_ue=$'\E[0m'

# zsh history config
export HISTSIZE=1024
export HISTFILESIZE=1024
export HISTFILE=$HOME/.zsh_history
export SAVEHIST=$HISTSIZE
setopt bang_hist                 # Treat the '!' character specially during expansion.
setopt extended_history          # Write the history file in the ":start:elapsed;command" format.
setopt hist_expire_dups_first    # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups          # Don't record an entry that was just recorded again.
setopt hist_ignore_all_dups      # Delete old recorded entry if new entry is a duplicate.
setopt hist_find_no_dups         # Do not display a line previously found.
setopt hist_ignore_space         # Don't record an entry starting with a space.
setopt hist_save_no_dups         # Don't write duplicate entries in the history file.
setopt hist_reduce_blanks        # Remove superfluous blanks before recording entry.
setopt hist_verify               # Don't execute immediately upon history expansion.
setopt hist_ignore_all_dups

# colors' configuration
if [ -e $HOME/.ls_colors ]; then
    eval $( dircolors -b $HOME/.ls_colors )
fi

alias j="jump"

setopt rmstarsilent
setopt no_nomatch

# user's private bin
newpath="$HOME/.local/bin"
if [[ "${PATH}" != *"${newpath}"* ]]; then
    export PATH=$newpath:$PATH
fi

# nvm configuration
export NVM_DIR="$HOME/.nvm"
if [ -e $NVM_DIR ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# opam configuration
if [ -e $HOME/.opam ]; then
    test -r $HOME/.opam/opam-init/init.zsh && . $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
fi

