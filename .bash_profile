export EDITOR='vim';
export BASH_SILENCE_DEPRECATION_WARNING=1

# Case-insensitive globbing (used in pathname expansion)
##shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
# shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

export CLICOLOR=1;
export LSCOLORS=GxBxCxDxexegedabagaced;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;


# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
	# Ensure existing Homebrew v1 completions continue to work
	export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
	source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
	source /etc/bash_completion;
fi;
eval "$(/opt/homebrew/bin/brew shellenv)"

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/';
}

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

export PATH=$PATH:$(go env GOPATH)/bin:~/bin

eval "$(direnv hook bash)"

PS1="\[\033[01;32m\]\u@"
PS1+="$(scutil --get ComputerName)\[\033[00m\]:"
PS1+="\[\033[01;34m\]\w"
PS1+="\[\033[0;32m\]\$(parse_git_branch)\[\033[00m\]\$ "
