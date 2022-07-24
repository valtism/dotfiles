# clone antidote if necessary
[[ -e ~/.antidote ]] || git clone https://github.com/mattmc3/antidote.git ~/.antidote

# source antidote
. ~/.antidote/antidote.zsh

# generate and source plugins from ~/.zsh_plugins.txt
antidote load

# fnm (Fast Node Manager)
eval "$(fnm env --use-on-cd)"

# aliases
alias ls='exa'
alias la='exa --header --long --all'
alias tree='exa --tree --level=3 --git-ignore'
alias cat='bat --plain --paging=never --tabs=4 --theme=Visual\ Studio\ Dark+'
alias greset='git reset --hard @{u}'
alias gpf='git push -f'
alias cls='printf "\033c"'

# functions

# fuzzy branch switcher
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# find bloated files in git history
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

# tmux template for Pry
pryup() {
    tmux new-session -d -s 'pry'
    tmux send 'cd ~/Developer/budgit-client' C-m
    tmux send 'yarn start' C-m
    tmux split-window -v
    tmux send 'cd ~/Developer/budgit-server' C-m
    tmux send 'rbenv' C-m
    tmux send 'QUEUE=* rake resque:work' C-m
    tmux split-window -h
    tmux send 'cd ~/Developer/budgit-server' C-m
    tmux send 'rbenv' C-m
    tmux send 'rails server' C-m
}
