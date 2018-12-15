# ls colors
autoload -U colors && colors

if (( $+commands[dircolors] )); then
  if [[ -z "$LS_COLORS" ]]; then
    if [[ -s "$HOME/.dir_colors" ]]; then
      eval "$(dircolors --sh "$HOME/.dir_colors")"
    else
      eval "$(dircolors --sh)"
    fi
  fi
  alias ls="${aliases[ls]:-ls} --color=auto"
else
  if [[ -z "$LSCOLORS" ]]; then
    export LSCOLORS='Gxfxcxdxbxegedabagacad'
  fi

  if [[ -z "$LS_COLORS" ]]; then
    export LS_COLORS='di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;41'
  fi
  alias ls="${aliases[ls]:-ls} -G"
fi

export GREP_COLOR='37;45' # BSD.
export GREP_COLORS="mt=$GREP_COLOR" # GNU.

setopt auto_cd
setopt multios
setopt prompt_subst

[[ -n "$WINDOW" ]] && SCREEN_NO="%B$WINDOW%b " || SCREEN_NO=""
