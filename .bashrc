export LC_CTYPE=en_US.UTF-8

[ -f ~/.bash_powerline ] && . ~/.bash_powerline

peco-history() {
  local NUM=$(history | wc -l)
  local FIRST=$((-1*(NUM-1)))

  if [ $FIRST -eq 0 ] ; then
    # Remove the last entry, "peco-history"
    history -d $((HISTCMD-1))
    echo "No history" >&2
    return
  fi

  local CMD=$(fc -l $FIRST | sort -k 2 -k 1nr | uniq -f 1 | sort -nr | sed -E 's/^[0-9]+[[:blank:]]+//' | peco | head -n 1)

  if [ -n "$CMD" ] ; then
    # Replace the last entry, "peco-history", with $CMD
    history -s $CMD

    if type osascript > /dev/null 2>&1 ; then
      # Send UP keystroke to console
      (osascript -e 'tell application "System Events" to keystroke (ASCII character 30)' &)
    fi

    # Uncomment below to execute it here directly
    # echo $CMD >&2
    # eval $CMD
  else
    # Remove the last entry, "peco-history"
    history -d $((HISTCMD-1))
  fi
}

bind '"\C-r":"peco-history\n"'

# pyenv setup
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PATH:$PYENV_ROOT/bin"
eval "$(pyenv init -)"

# GVM setup
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Default golang
#export GOPATH="$HOME/${gvm_go_name}"
#export PATH="$PATH:$GOPATH/bin" 

export PATH="$PATH:/Users/nsomeya/tools/q/bin"

export VIRTUAL_ENV_DISABLE_PROMPT="" # False

# AWS CLI Completer
complete -C '/Users/nsomeya/.pyenv/shims/aws_completer' aws


# bash completer
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi


# alias ls with color
alias ls='ls -FG'
alias ll='ls -alFG'

#maven setting
export PATH="$HOME/bin:/usr/local/opt/maven@3.2/bin:$PATH"

# tig completion
source /usr/local/Cellar/tig/2.4.1_1/etc/bash_completion.d/tig-completion.bash

# git completion
source /usr/local/opt/share/zsh/site-functions/git-completion.bash

# history num
export HISTSIZE=50000

