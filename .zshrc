# clone antidote if necessary
[[ -e ~/.antidote ]] || git clone https://github.com/mattmc3/antidote.git ~/.antidote

# source antidote
. ~/.antidote/antidote.zsh

# generate and source plugins from ~/.zsh_plugins.txt
antidote load

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# aliases
alias ls='exa'
alias la='exa --header --long --all'
alias tree='exa --tree --level=3 --git-ignore'
alias cat='bat --plain --paging=never --tabs=4 --theme=Visual\ Studio\ Dark+'
alias greset='git reset --hard @{u}'
alias gpf='git push -f'
alias cls='printf "\033c"'
alias dl='yt-dlp'

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

# bun completions
[ -s "/Users/valtism/.bun/_bun" ] && source "/Users/valtism/.bun/_bun"

# bun
export BUN_INSTALL="/Users/valtism/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Python (miniconda)
. /opt/miniconda3/bin/activate py310
