# History Configuration
HISTSIZE=50000               # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=50000               # Number of history entries to save to disk
setopt    appendhistory     # Append history to the history file (no overwriting)
setopt    sharehistory      # Share history across terminals
setopt    incappendhistory  # Immediately append to the history file, not just when a term is killed

# autocd
setopt autocd

# completions
zstyle :compinstall filename '/Users/danielwood/.zshrc'

autoload -Uz compinit
compinit

# antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# fnm
eval "$(fnm env --multi)"

# aliases
alias ls='exa'
alias la='exa --header --long --all'
alias greset='git reset --hard @{u}'
alias gpf='git push -f'

# functions
fbr() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}
