# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#	# We have color support; assume it's compliant with Ecma-48
#	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#	# a case would tend to support setf rather than setaf.)
#	color_prompt=yes
#    else
#	color_prompt=
#    fi
#fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#    ;;
#*)
#    ;;
#esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# The space will tell bash that the first word after 'sudo' is a command that should be expanded
alias sudo='sudo '

# 256 color
case "$TERM" in
    xterm*)
        export TERM=xterm-256color
        ;;
esac

# GPG error fix
export GPG_TTY=$(tty)

# man page color
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[38;5;37;1m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[38;5;24;48;5;148;1m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[38;5;11;1m'
export LESS_TERMCAP_ue=$'\E[0m'

#### 38;2 for the foreground, then the color number
#### 48;2 for the background, then the color number
. $HOME/.git-completion.bash
. $HOME/.git-prompt.sh

SEPARATER=$'\UE0B0'         # Rightwards black arrowhead

function boldtext() { # bold text
    echo "\\[\\033[1m\\]"
}
function bgcolor() { # background color
    echo "\\[\\033[48;2;${1}m\\]"
}
function defbgcolor() { # default background color
    echo "\\[\\033[49m\\]"
}
function fgcolor() { # foreground color
    echo "\\[\\033[38;2;${1}m\\]"
}
function reverse() { # reverse foreground color and background color
    echo "\\[\\033[7m\\]"
}
function rscolor() { # reset color
    echo "\\[\\033[0m\\]"
}

prompt_status() {
    local -a txt
    local bg="152;13;57"
    local fg="232;209;180"
    local JOBS_CHAR=$'\u2699' # ⚙

    [[ ${RETVAL} -ne 0 ]] && txt+=${RETVAL}
    [[ $(jobs -l | wc -l) -gt 0 ]] && {
        if [ -n "${txt}" ]; then
            txt+=" "
        fi
        txt+="${JOBS_CHAR}"
    }

    if [ -n "${txt}" ]; then
        LAST_FG="${fg}"
        LAST_BG="${bg}"
        PS1+="$(fgcolor ${fg})$(bgcolor ${bg}) ${txt} "
    fi
}

prompt_dir() {
    local bg="49;75;108"
    local fg="225;140;28"

    if [ -n "${LAST_BG}" -a -n "${LAST_FG}" ]; then
        PS1+="$(fgcolor ${LAST_BG})$(bgcolor ${bg})${SEPARATER}"
    fi

    local txt="\w"

    # check dir writable
    local LOCK_CHAR=$'\UE0A2' #  Closed padlock
    if [ ! -w "$PWD" ]; then
        txt+=" ${LOCK_CHAR}"
    fi

    LAST_BG="${bg}"
    LAST_FG="${fg}"
    PS1+="$(fgcolor ${fg})$(bgcolor ${bg}) ${txt} "
}

prompt_git() {
    local GIT_CHAR=$'\ue0a0' #  Version control branch
    local STASH_CHAR=$'\u25fc' # ◼
    local STAGE_CHAR=$'\u271a' # ✚
    local UNSTAGE_CHAR=$'\u2217' # ∗
    local UNTRACK_CHAR="?"
    local bg="42;127;192"
    local fg="249;243;60"

    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        if [ -n "${LAST_BG}" -a -n "${LAST_FG}" ]; then
            PS1+="$(fgcolor ${LAST_BG})$(bgcolor ${bg})${SEPARATER}"
        fi

        local txt="${GIT_CHAR} $(__git_ps1 %s)"

        if ! $(git rev-parse --is-inside-git-dir); then
            # check stash list
            if [ $(git stash list | wc -l) -gt 0 ]; then
                txt+=" ${STASH_CHAR}"
            fi

            for i in {1}; do
                if [ "${AGNOSTER_RANDOM_GIT_STATUS}" -eq 0 ]; then
                    break
                fi

                # check staged files
                $(git diff --no-ext-diff --quiet --cached)
                if [ $? -ne 0 ]; then
                    txt+=" ${STAGE_CHAR}"
                    break
                fi

                # check unstaged files
                $(git diff --no-ext-diff --quiet)
                if [ $? -ne 0 ]; then
                    txt+=" ${UNSTAGE_CHAR}"
                    break
                fi

                # check untracked files
                if [ ! -z "$(git status --porcelain)" ]; then
                    txt+=" ${UNTRACK_CHAR}"
                    break
                fi
            done
        fi

        LAST_BG="${bg}"
        LAST_FG="${fg}"
        PS1+="$(fgcolor ${fg})$(bgcolor ${bg}) ${txt} "
    fi
}

prompt_end() {
    if [ -n "${LAST_BG}" -a -n "${LAST_FG}" ]; then
        PS1+="$(fgcolor ${LAST_BG})$(defbgcolor)${SEPARATER}$(rscolor) "
    fi
}

build_prompt() {
    RETVAL=$?
    LAST_BG=""
    LAST_FG=""
    AGNOSTER_RANDOM_GIT_STATUS=1
    PS1=""
    prompt_status
    prompt_dir
    prompt_git
    prompt_end
}

PROMPT_COMMAND=build_prompt

if [ -e $HOME/.ls_colors ]; then
    eval $( dircolors -b $HOME/.ls_colors )
fi

