# History Configuration
HISTSIZE=50000              # How many lines of history to keep in memory
HISTFILE=~/.zsh_history     # Where to save history to disk
SAVEHIST=50000              # Number of history entries to save to disk
setopt  appendhistory       # Append history to the history file (no overwriting)
setopt  sharehistory        # Share history across terminals
setopt  incappendhistory    # Immediately append to the history file, not just when a term is killed
setopt  histignorespace     # Don't save commands with a space 

# autocd
setopt autocd

# completions
zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit
compinit

# antibody
source <(antibody init)
antibody bundle < ~/.zsh_plugins.txt

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# fnm
eval "$(fnm env)"

# rbenv
eval "$(rbenv init -)"

# aliases
alias ls='exa'
alias la='exa --header --long --all'
alias tree='exa --tree --level=3 --git-ignore'
alias cat='bat --plain --paging=never --tabs=4 --theme=Visual\ Studio\ Dark+'
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

fatgit() {
    git rev-list --all --objects | \
    sed -n $(git rev-list --objects --all | \
    cut -f1 -d' ' | \
    git cat-file --batch-check | \
    grep blob | \
    sort -n -k 3 | \
    tail -n40 | \
    while read hash type size; do
         echo -n "-e s/$hash/$size/p ";
    done) | \
    sort -n -k1
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle :compinstall filename '/Users/valty/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


#### FIG ENV VARIABLES ####
[ -s ~/.fig/fig.sh ] && source ~/.fig/fig.sh
#### END FIG ENV VARIABLES ####


