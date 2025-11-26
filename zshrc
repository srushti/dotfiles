# source antidote
source $(brew --prefix)/opt/antidote/share/antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load

# # Path to your oh-my-zsh configuration.
# ZSH=$HOME/.oh-my-zsh
# if [ -s $HOME/.oh-my-zsh-custom ]; then
#     ZSH_CUSTOM=$HOME/.oh-my-zsh-custom
# fi

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# if [ -n $ZSH_CUSTOM ] && [ -f $ZSH_CUSTOM/`whoami`.zsh-theme ]; then
#     ZSH_THEME="`whoami`"
# fi

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# plugins=(git gh git-prompt tmux colorize rbenv ruby gem rails brew macos iterm2 bundler npm tmuxinator)

DISABLE_UPDATE_PROMPT=true # will auto update without prompt
ZSH_COLORIZE_STYLE="colorful"

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

# Customize to your needs...
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/X11/bin

# general
alias la="ls -lach"
alias lsd="ls | grep ^d"
# which ack >> /dev/null || alias ack=ack-grep

# global aliases
alias -g H='| head'
alias -g T='| tail'
alias -g G='| rg'
alias -g L="| less"
alias -g M="| most"
alias -g B="&|"
alias -g HL="--help"
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'

alias ll="ls -l"
if which brew &> /dev/null; then
  alias i="brew install"
  alias up-all="brew upgrade --all"
  alias up="brew upgrade"
  alias un="brew uninstall"
elif which apt-get &> /dev/null; then
  alias i="sudo apt-get install"
  alias up="sudo apt-get upgrade"
  alias up-all=up
  alias un="sudo apt-get remove"
fi
alias gi="gem install"
alias refreshctags="ack -f | ctags -L - && ack -f >| cscope.files && cscope -b -q"
alias sp=spork
alias r=rake
alias b=bundle
alias be='bundle exec'
alias dnsget='networksetup -getdnsservers Wi-Fi'
alias dnsset='networksetup -setdnsservers Wi-Fi'

export HISTFILE=~/.zhistory

# git aliases
#alias gst='git st'
#alias gl='git pull'
#alias gp='git push'
#alias gd='git diff | mate'
#alias gc='git commit -v'
#alias gca='git commit -v -a'
#alias gb='git branch'
#alias gba='git branch -a'
#alias glg='git lg'

# directory options
setopt auto_cd
setopt auto_pushd

# paths -------------------------------------------------------

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="./bin:$PATH"

export PATH="./node_modules/.bin:$PATH"

alias vi=vim
alias ep="vim ~/.zshrc && source ~/.zshrc"
alias eplocal="vim ~/.zshrc.local && source ~/.zshrc.local"
export EDITOR="vim"
if [ -f /usr/local/bin/nvim ]; then
  alias vim="nvim"
  export EDITOR="nvim"
  export GIT_EDITOR=$EDITOR
fi

export LESS='-RM --no-init --quit-if-one-screen' # -R: print ANSI color escapes directly to the screen
                  # -M: use very verbose prompt, with pos/%

# folder aliases
[[ -e ~/.zshrc.local ]] && source ~/.zshrc.local

# quick access to directories
# softlinks (e.g. rspec) created in the directory ~/.soft_links will
# be accessible as ~rspec from anywhere
if [ -d ~/.soft_links ]; then
  for i in $HOME/.soft_links/*; do
    soft_link=`basename $i`;
    hash -d $soft_link="$i"
  done
fi

title_manual() {
  print -Pn "\e]1;$1\a"
}

# rbenv
export RBENV_ROOT=$HOME/.rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

export PATH=./bin:~/.bin:$PATH

export JRUBY_OPTS=--1.9

#Neovim true color support
export NVIM_TUI_ENABLE_TRUE_COLOR=1
#Neovim cursor shape support
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

[[ -s /usr/local/etc/profile.d/z.sh ]] && . /usr/local/etc/profile.d/z.sh

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

[[ -f $HOME/.bin/tmuxinator.zsh ]] && source $HOME/.bin/tmuxinator.zsh

# added by travis gem
[ -f /Users/srushti/.travis/travis.sh ] && source /Users/srushti/.travis/travis.sh

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Use fd to generate the list for directory completion
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" --exclude ".next" . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" --exclude ".next" . "$1"
}

# Herd injected PHP 8.3 configuration.
export HERD_PHP_83_INI_SCAN_DIR="/Users/srushti/Library/Application Support/Herd/config/php/83/"


# Herd injected PHP binary.
export PATH="/Users/srushti/Library/Application Support/Herd/bin/":$PATH


# Herd injected PHP 7.4 configuration.
export HERD_PHP_74_INI_SCAN_DIR="/Users/srushti/Library/Application Support/Herd/config/php/74/"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform
#compdef cdktf
###-begin-cdktf-completions-###
#
# yargs command completion script
#
# Installation: node_modules/.bin/cdktf completion >> ~/.zshrc
#    or node_modules/.bin/cdktf completion >> ~/.zprofile on OSX.
#
_cdktf_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" node_modules/.bin/cdktf --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _cdktf_yargs_completions cdktf
###-end-cdktf-completions-###

#zk
export ZK_NOTEBOOK_DIR="$HOME/.config/zk/notes"
mkdir -p $ZK_NOTEBOOK_DIR

# ~/.zshrc
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)

# bun completions
[ -s "/Users/srushti/.bun/_bun" ] && source "/Users/srushti/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export XDG_CONFIG_HOME=/Users/srushti/.config

eval "$(zoxide init zsh)"

# eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/srushti.json)"
eval "$(starship init zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/srushti/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/srushti/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/srushti/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/srushti/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Added by Antigravity
export PATH="/Users/srushti/.antigravity/antigravity/bin:$PATH"
