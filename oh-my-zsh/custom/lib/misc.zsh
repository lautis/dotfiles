autoload -Uz is-at-least

if [[ $DISABLE_MAGIC_FUNCTIONS != true ]]; then
  for d in $fpath; do
  	if [[ -e "$d/url-quote-magic" ]]; then
  		if is-at-least 5.1; then
  			autoload -Uz bracketed-paste-magic
  			zle -N bracketed-paste bracketed-paste-magic
  		fi
  		autoload -Uz url-quote-magic
  		zle -N self-insert url-quote-magic
      break
  	fi
  done
fi

## jobs
setopt long_list_jobs

# recognize comments
setopt interactivecomments
