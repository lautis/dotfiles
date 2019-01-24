# Define environment variables.
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export PATH=$HOME/.cargo/bin:/usr/local/bin:/usr/local/sbin:$PATH

export EDITOR='atom --wait'
export PAGER='less'
export ARCHFLAGS='-arch x86_64'

export FZF_DEFAULT_OPTS="--height 50% --reverse --border --inline-info --preview-window 'right:60%' --preview '(bat --color=always --style=numbers {} || cat {} || tree -C {}) 2> /dev/null | head -500'"
export FZF_CTRL_T_OPTS="--preview-window 'right:60%' --preview '(bat --color=always --style=numbers {} || cat {} || tree -C {}) 2> /dev/null | head -500'"

export DISABLE_AUTO_UPDATE=true

export BAT_THEME="TwoDark"
