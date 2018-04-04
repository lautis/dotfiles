# Define environment variables.
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8
export PATH=$HOME/.cargo/bin:/usr/local/bin:/usr/local/sbin:$PATH

export EDITOR='atom --wait'
export PAGER='less'
export ARCHFLAGS='-arch x86_64'

export FZF_DEFAULT_OPTS='--height 40% --reverse --border --inline-info'
export FZF_CTRL_T_OPTS="--preview '(highlight --out-format=xterm256 --style=Candy {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

export DISABLE_AUTO_UPDATE=true
