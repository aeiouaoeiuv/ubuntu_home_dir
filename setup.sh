#!/bin/bash

set -e

SetupDepends()
{
    printf "\e[1;34m-- Setup depends\e[0m\n"
    sudo apt -y install fontconfig zsh xclip vim git
}

SetupFonts()
{
    printf "\e[1;34m-- Setup fonts\e[0m\n"
    \cp -rf .local "$HOME"
    fc-cache -f ~/.local/share/fonts
}

SetupVim()
{
    printf "\e[1;34m-- Setup vim\e[0m\n"
    if [ ! -d "$HOME"/.vim/bundle/Vundle.vim ]; then
        printf "\e[36m-- Installing Vundle\e[0m\n"
        git clone https://github.com/VundleVim/Vundle.vim.git "$HOME"/.vim/bundle/Vundle.vim
    fi

    \cp -f .vimrc "$HOME"
    vim +PluginInstall +qall
}

SetupGit()
{
    printf "\e[1;34m-- Setup git\e[0m\n"
    git config --global core.autocrlf false
    git config --global core.safecrlf true
    git config --global core.quotepath false
    git config --global core.filemode false
    git config --global core.editor /usr/bin/vim
    git config --global alias.st status
    git config --global alias.co checkout
    git config --global alias.lg "log --all --graph --pretty=format:\"%C(154)%h %C(31)%ai %C(6)%an%Creset%C(auto)%d%Creset%n%w(0,4,4)%B\""
    git config --global log.date iso
    git config --global diff.tool vimdiff
    git config --global difftool.prompt true
}

SetupMisc()
{
    printf "\e[1;34m-- Setup misc\e[0m\n"
    \cp -f .git-completion.bash "$HOME"
    \cp -f .git-completion.zsh "$HOME"
    \cp -f .git-prompt.sh "$HOME"
    \cp -f .ls_colors "$HOME"
    \cp -f .tmux.conf "$HOME"
}

SetupZsh()
{
    printf "\e[1;34m-- Setup zsh\e[0m\n"
    if [ ! -d "$HOME"/.oh-my-zsh ]; then
        printf "\e[36m-- Installing oh-my-zsh\e[0m\n"
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME"/.oh-my-zsh
    fi

    if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
        printf "\e[36m-- Installing zsh-autosuggestions\e[0m\n"
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-autosuggestions
    fi

    if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-history-substring-search ]; then
        printf "\e[36m-- Installing zsh-history-substring-search\e[0m\n"
        git clone https://github.com/zsh-users/zsh-history-substring-search.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-history-substring-search
    fi

    if [ ! -d "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
        printf "\e[36m-- Installing zsh-syntax-highlighting\e[0m\n"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME"/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    fi

    \cp -f .zshrc "$HOME"
    \cp -f .oh-my-zsh/themes/agnoster_random.zsh-theme "$HOME"/.oh-my-zsh/themes/

    if [ "$SHELL" != "/usr/bin/zsh" ]; then
        printf "\n\e[33m-- Changing default shell to zsh. Please enter [%s]'s password: \e[0m\n" "$USER"
        chsh -s /usr/bin/zsh
    fi
}

SetupBash()
{
    printf "\e[1;34m-- Setup bash\e[0m\n"
    \cp -f .bashrc "$HOME"
}

SetupDisableUpdateNotifier()
{
    printf "\e[1;34m-- Setup disable update notifier\e[0m\n"
    if [ -f /etc/apt/apt.conf.d/99update-notifier ]; then
        sudo rm -f /etc/apt/apt.conf.d/99update-notifier
    fi
}

SetupDepends
SetupFonts
SetupVim
SetupGit
SetupBash
SetupZsh
SetupMisc
SetupDisableUpdateNotifier

printf "\e[1;32m-- Setup complete\e[0m\n"

