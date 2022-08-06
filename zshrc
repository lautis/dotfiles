[[ -f ~/.local/share/zsh-snap/plugins/zsh-snap/znap.zsh ]] ||
  git clone --depth 1 -- \
    https://github.com/marlonrichert/zsh-snap.git ~/.local/share/zsh-snap/plugins/zsh-snap

source ~/.local/share/zsh-snap/plugins/zsh-snap/znap.zsh

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

ZSH_DISABLE_COMPFIX=true

# Set to this to use case-sensitive completion
# export CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# export DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# export DISABLE_LS_COLORS="true"

# Disable auto-setting terminal title
# export DISABLE_AUTO_TITLE="true"

cdpath=(.. ~ ~/Documents)

fpath=(/usr/local/share/zsh-completions $fpath)

# Aliases
alias _=sudo
alias j=z
alias irssi="mosh irssi -- screen -rdU irssi"
alias vmp="git reset --hard; git clean -f"

if [[ -d "/Applications/Google Chrome.app" ]]; then
  alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"
fi

alias grep='grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

if (( ${+commands[hub]} )); then alias git=hub; fi

znap source romkatv/zsh-defer

if [ -f $ZSH/custom/oh-my-zsh.sh ]; then
  zsh-defer source $ZSH/custom/oh-my-zsh.sh
else
  zsh-defer source $ZSH/oh-my-zsh.sh
fi

# Remove conflicting alias
(( ${+aliases[rg]} )) && unalias rg

# Completion finetune

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# enable approximate matches
zstyle ':completion:*' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
# do not insert tab on empty line
zstyle ':completion:*' insert-tab false
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %F{214}%d%b'
zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'
zstyle ':completion:*' group-name ''

# offer indices before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# ignores

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# nonexisting commands
zstyle ':completion:*:functions' ignored-patterns '_*'

expand-or-complete-with-redisplay() {
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-redisplay
bindkey "^I" expand-or-complete-with-redisplay

znap source ohmyzsh/ohmyzsh lib/{completion,history,functions,key-bindings,termsupport}
zsh-defer znap source ohmyzsh/ohmyzsh plugins/{bundler,colored-man-pages,rake,rake-fast}

zsh-defer znap source zsh-users/zsh-autosuggestions
zsh-defer znap source zsh-users/zsh-syntax-highlighting
zsh-defer znap source wfxr/emoji-cli
zsh-defer znap source wfxr/forgit
zsh-defer znap source fzf-git
zsh-defer znap source colors
zsh-defer znap source sshuttle

zsh-defer znap eval rbenv rbenv init - --no-rehash
zsh-defer znap eval nodenv nodenv init - --no-rehash
zsh-defer znap eval zoxide zoxide init zsh

if [ -f ~/.fzf.zsh ]; then
  zsh-defer source ~/.fzf.zsh
elif [ -d /usr/share/fzf ]; then
  [[ $- == *i* ]] && zsh-defer source /usr/share/fzf/completion.zsh
  zsh-defer source /usr/share/fzf/key-bindings.zsh
fi

# Use fd instead of the default find
if (( ${+commands[fd]} )); then
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

if (( ${+commands[starship]} )); then
  znap eval starship starship init zsh --print-full-init
fi
