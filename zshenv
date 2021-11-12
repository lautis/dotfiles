# Define environment variables.
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

if [[ -d /opt/homebrew ]]; then
  export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH
fi

export PATH=$HOME/.cargo/bin:/usr/local/bin:/usr/local/sbin:$PATH

if (( $+commands[code] )); then
  export EDITOR='code --wait'
else
  export EDITOR='nano'
fi

export PAGER='less'
export LESS='-R'
export ARCHFLAGS='-arch x86_64'

export FZF_DEFAULT_OPTS="--height 50% --reverse --border --inline-info --preview-window 'right:60%' --preview '(bat --color=always --style=numbers {} || cat {} || tree -C {}) 2> /dev/null | head -500'"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview '(bat --color=always --style=numbers {} || cat {} || tree -C {}) 2> /dev/null | head -500'"

export DISABLE_AUTO_UPDATE=true

export BAT_THEME="TwoDark"
