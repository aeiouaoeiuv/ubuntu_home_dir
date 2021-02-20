#!/bin/bash

set -e

PrintInfo()
{
    printf "\e[1;34m%s\e[0m\n" "$1"
}

PrintSuccess()
{
    printf "\e[1;32m%s\e[0m\n" "$1"
}

PrintNotice()
{
    printf "\e[1;36m%s\e[0m\n" "$1"
}

SetupDepends()
{
    PrintInfo "-- Setup depends"
    local packages="fontconfig zsh xclip vim git libevent-dev" # libevent-dev for tmux

    local arr=($packages)
    for p in ${arr[@]}; do
        if dpkg -s "$p" >/dev/null 2>&1; then
            continue # package already installed
        fi

        PrintNotice "-- Installing $p"
        sudo apt -y install "$p"
    done
}

SetupFonts()
{
    PrintInfo "-- Setup fonts"

    if [ ! -d "$HOME/.local/share/fonts" ]; then
        mkdir -p "$HOME/.local/share/fonts"
    fi

    local reset_cache=false;
    for f in .local/share/fonts/*; do
        if [ ! -f "$HOME/$f" ]; then
            \cp -f "$f" "$HOME/$f"
            reset_cache=true;
        fi
    done

    if ${reset_cache}; then
        fc-cache -f ~/.local/share/fonts
    fi
}

SetupVim()
{
    PrintInfo "-- Setup vim"
    if [ ! -d "$HOME"/.vim/bundle/Vundle.vim ]; then
        PrintNotice "-- Installing Vundle"
        git clone https://github.com/VundleVim/Vundle.vim.git "$HOME"/.vim/bundle/Vundle.vim
    fi

    \cp -f .vimrc "$HOME"
    vim +PluginInstall +qall
}

SetupGit()
{
    PrintInfo "-- Setup git"
    git config --global core.autocrlf false
    git config --global core.safecrlf true
    git config --global core.quotepath false
    git config --global core.filemode false
    git config --global core.editor /usr/bin/vim
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.lg "log --all --graph --pretty=format:\"%C(white 31) %ai %Creset%C(154 60) %h %Creset%C(17 178) %an %Creset%C(178)%Creset%C(auto)%d%Creset%n%w(0,4,4)%B\""
    git config --global log.date iso
    git config --global diff.tool vimdiff
    git config --global difftool.prompt true
}

SetupMisc()
{
    PrintInfo "-- Setup misc"
    \cp -f .git-completion.bash "$HOME"
    \cp -f .git-completion.zsh "$HOME"
    \cp -f .git-prompt.sh "$HOME"
    \cp -f .ls_colors "$HOME"
    \cp -f .tmux.conf "$HOME"
}

SetupZsh()
{
    PrintInfo "-- Setup zsh"
    if [ ! -d "$HOME"/.oh-my-zsh ]; then
        PrintNotice "-- Installing oh-my-zsh"
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME"/.oh-my-zsh
    fi

    if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
        PrintNotice "-- Installing zsh-autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
        PrintNotice "-- Installing zsh-history-substring-search"
        git clone https://github.com/zsh-users/zsh-history-substring-search.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-history-substring-search
    fi

    if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        PrintNotice "-- Installing zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    \cp -f .zshrc "$HOME"
    \cp -f .oh-my-zsh/themes/agnoster_random.zsh-theme "$HOME"/.oh-my-zsh/themes/

    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        PrintNotice "-- Changing default shell to zsh. Please enter ${USER}'s password:"
        chsh -s /usr/bin/zsh
    fi
}

SetupBash()
{
    PrintInfo "-- Setup bash"
    \cp -f .bashrc "$HOME"
}

SetupDisableUpdateNotifier()
{
    PrintInfo "-- Setup disable update notifier"
    if [ ! -L /usr/bin/update-manager ]; then
        sudo mv /usr/bin/update-manager /usr/bin/update-manager_bak
        sudo ln -sf /bin/true /usr/bin/update-manager
    fi
}

SetupDepends
SetupFonts
SetupVim
SetupGit
SetupBash
SetupZsh
SetupMisc
# SetupDisableUpdateNotifier

PrintSuccess "-- Setup complete"

