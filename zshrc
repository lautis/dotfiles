# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

SPACESHIP_DOCKER_SHOW="false"
SPACESHIP_PROMPT_SYMBOL="❯"
SPACESHIP_PROMPT_SEPARATE_LINE="true"

SPACESHIP_PROMPT_ORDER=(time user host dir git line_sep char)

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="spaceship"

function rprompt() {
  RETVAL=$?

  if [[ $timer_show -gt 1 ]]; then
    echo -n "%F{yellow}(${timer_show}s)%{$reset_color%}"
  fi

  if [[ $RETVAL -ne 0 ]]; then
    echo -n "%{$fg[red]%}%  $RETVAL ↵%{$reset_color%}"
  fi
}

function preexec() {
  timer=${timer:-$SECONDS}
}

function precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    unset timer
  fi
}

if [[ $SPACESHIP_PROMPT_SEPARATE_LINE == true ]]; then
  RPROMPT_PREFIX='%{'$'\e[1A''%}'
  RPROMPT_SUFFIX='%{'$'\e[1B''%}'
fi

RPS1='$RPROMPT_PREFIX$(rprompt)$RPROMPT_SUFFIX'

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
  gem git fasd bundler colored-man-pages docker docker-compose rake extract
  rails yarn fast-syntax-highlighting
)

cdpath=(.. ~ ~/Documents)

# Aliases
alias j=z
alias irssi="mosh irssi -- screen -rdU irssi"
alias vmp="git reset --hard; git clean -f"
alias c="pygmentize -O style=monokai -f console256 -g"
alias chrome="/Applications/Google\\ \\Chrome.app/Contents/MacOS/Google\\ \\Chrome"
if command -v hub > /dev/null; then alias git=hub; fi


# Completion finetunage

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*:match:*' original only

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
# do not insert tab on empty line
zstyle ':completion:*' insert-tab false
# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# offer indices before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# ignores

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# nonexisting commands
zstyle ':completion:*:functions' ignored-patterns '_*'

# Show menu for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

expand-or-complete-with-redisplay() {
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-redisplay
bindkey "^I" expand-or-complete-with-redisplay

source $ZSH/oh-my-zsh.sh

if [ -f /usr/local/share/zsh/site-functions/_tmuxinator ]; then
  source /usr/local/share/zsh/site-functions/_tmuxinator
fi

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
_load-toolchain-env jenv

[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
