# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

export COLORTERM=truecolor
export CLICOLOR=1;
export LSCOLORS=GxBxCxDxexegedabagaced;

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

alias vim=nvim
alias so=source 

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/';
}

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

export PATH="$PATH:/usr/local/go/bin:"
export PATH="$PATH:/home/$USER/bin"
export PATH="$PATH:/home/$USER/go/bin"
export PATH="$PATH:/home/$USER/.cargo/bin"
export PATH="$PATH:/home/$USER/zig/"
export PATH="$PATH:/home/$USER/.local/bin"
export XDG_CONFIG_HOME=/home/$USER
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

eval "$(direnv hook bash)"

PS1="\[\033[01;32m\]\u@"
PS1+="$(hostname)\[\033[00m\]:"
PS1+="\[\033[01;34m\]\w"
PS1+="\[\033[0;32m\]\$(parse_git_branch)\[\033[00m\]\$ "

coverage() {
    t="/tmp/go-cover.$$tmp"
    go test ./... -coverprofile=$t && go tool cover -html=$t && unlink $t
}

git config --global core.editor "vim"

source <(kubectl completion bash)
source ~/.secrets

worktree(){ 
  local current_branch=$(git rev-parse --abbrev-ref HEAD)

  # Check if we're in a git repository
  if [ $? -ne 0 ]; then
      echo "Error: Not in a git repository"
      return 1
  fi

  local dir_name=$(echo "$current_branch" | cut -d'/' -f2- | tr '/' '_' | cut -d '-' -f1-2)

  if [ -d "$dir_name" ]; then
      cd "$dir_name"
      return 0
  fi

  git checkout master 

  # Create worktree
  echo "Creating worktree for branch '$current_branch' in directory '~/$dir_name'"
  git worktree add ~/"$dir_name" "$current_branch"

  # Change into the new worktree directory
  if [ $? -eq 0 ]; then
      cd ~/"$dir_name"
  else
      echo "Error: Failed to create worktree"
      return 1
  fi
}
