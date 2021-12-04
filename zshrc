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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(
  bundler git fasd colored-man-pages rake rake-fast extract
  fast-syntax-highlighting emoji-cli fzf-git forgit fzf-fasd sshuttle
)

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

if command -v hub > /dev/null; then alias git=hub; fi

if [ -f $ZSH/custom/oh-my-zsh.sh ]; then
  source $ZSH/custom/oh-my-zsh.sh
else
  source $ZSH/oh-my-zsh.sh
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

# Cache initialisation scripts for *env
function _load-toolchain-env() {
  if command -v $1 > /dev/null; then
    toolchain_cache="$ZSH_CACHE_DIR/$1-init-cache"
    if [ "$(command -v $1)" -nt "$toolchain_cache" -o ! -s "$toolchain_cache" ]; then
      $1 init - --no-rehash >| "$toolchain_cache"
    fi
    source "$toolchain_cache"
    unset toolchain_cache
  fi
}

_load-toolchain-env rbenv
_load-toolchain-env nodenv

function _load-plugin() {
  if [ -f "/usr/share/zsh/plugins/$1" ]; then
    source "/usr/share/zsh/plugins/$1"
  elif [ -f "/usr/local/share/$1" ]; then
    source "/usr/local/share/$1"
  elif [ -f "/opt/homebrew/share/$1" ]; then
    source "/opt/homebrew/share/$1"
  else
    echo "could not find $1"
  fi
}

_load-plugin zsh-autosuggestions/zsh-autosuggestions.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
  eval "$(starship init zsh)"
fi
