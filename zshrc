
source ~/.zprofile

path+=~/bin

# package database search for unrecognized commands
source /usr/share/doc/pkgfile/command-not-found.zsh

############################################################################
# Locale
############################################################################
export LANG=cs_CZ.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_COLLATE="C"

# YYYY-MM-DD
export LC_TIME=en_DK.UTF-8

# fallback
export LANGUAGE="cs_CZ:en_US:en"

############################################################################
# Env variables
############################################################################
export EDITOR=vim
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk
export M2_HOME=/opt/maven
export M2=$M2_HOME/bin
export MAVEN_OPTS="-Xms512m -Xmx1024m"

############################################################################
# Key bindings
############################################################################
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^D" kill-whole-line
bindkey "^R" history-incremental-search-backward


############################################################################
# History
############################################################################
export HISTFILE=~/.zsh-history
export HISTSIZE=1000
export SAVEHIST=1000
setopt appendhistory
# commands starting with whitespace will not be saved in history
setopt hist_ignore_space
# ignore duplicates
setopt hist_ignore_all_dups


############################################################################
# Aliases
############################################################################
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'
alias j=jobs
alias ls='ls -F --color=auto'
alias l='ls'
alias ll='ls -l'
alias la='ls -a'
alias cd..='cd ..'
alias df='df -h'
alias grep='grep --color=auto'

alias clojure='rlwrap clj'

alias -g L='|less'

############################################################################
# Colors
############################################################################
[ -r ~/.dir_colors ] && eval `dircolors -b ~/.dir_colors`

############################################################################
# ZSH settings
############################################################################
zmodload zsh/complist
autoload -U compinit
compinit

setopt extendedglob
setopt correctall
setopt autolist
setopt autocd
setopt autoresume
setopt nobeep


############################################################################
# Prompt
############################################################################
autoload -U promptinit
autoload -Uz vcs_info
autoload colors
promptinit
colors

setopt prompt_subst

# set convinient variables for prompt colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RESET="%{${reset_color}%}"

# VCS settings
# formatting
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository

# general
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' disable bzr darcs svk mtn cvs cdv tla svn hg
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "${PR_GREEN}•${PR_RESET}"
zstyle ':vcs_info:*' unstagedstr "${PR_YELLOW}•${PR_RESET}"

# svn
# zstyle ':vcs_info:svn:*' branchformat '%r'
# zstyle ':vcs_info:svn:*' formats '%r (%b)%u%c '

# git
zstyle ':vcs_info:(git|git-svn):*' branchformat '%b%u%c'
zstyle ':vcs_info:(git|git-svn):*' formats '%r (%b) '
# zstyle ':vcs_info:(git|git-svn):*' formats '%r (%b%u%c) '
zstyle ':vcs_info:(git|git-svn):*' actionformats '%r (%b - %a) '


precmd() {
    if [[ ! -z $(git ls-files -o --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:(git|git-svn):*' formats "%r (%b%u%c${PR_RED}•${PR_RESET}) "
    } else {
        zstyle ':vcs_info:(git|git-svn):*' formats '%r (%b%u%c) '
    }

    vcs_info 2> /dev/null
}

function prompt_char {
    git branch > /dev/null 2> /dev/null && echo '☿' && return
    echo '%#'
}

export PROMPT='%n@%m:%~ %(?..(%?%) )$(prompt_char) '
export RPROMPT='[${vcs_info_msg_0_}%* on %D]'


############################################################################
# Completion
############################################################################
# approximation
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# case-insensitive (uppercase from lowercase) completion
zstyle '*:completion:*' matcher-list 'm:{a-z}={A-Z}'

# tab completion for PID
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# If you end up using a directory as argument, this will remove the trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true

# cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd


############################################################################
# Functions
############################################################################

# jump to git repo root dir
function groot() {
    cd $(git rev-parse --show-cdup)
}

function extract() {
    local exitcode=0
    local i
    local cmd
    for i in "$@"; do
        if [[ -f $i && -r $i ]]; then
            cmd=
            case $i in
                *.tar.bz2)  cmd='tar xjf'   ;;
                *.tbz2)     cmd='tar xjf'   ;;
                *.tar.gz)   cmd='tar xzf'   ;;
                *.tgz)      cmd='tar xzf'   ;;
                *.bz2)      cmd='bunzip2'   ;;
                *.gz)       cmd='gunzip'    ;;
                *.tar)      cmd='tar xf'    ;;
                *.xz)       cmd='unxz'      ;;
                *.zip)      cmd='unzip'     ;;
                *)
                    echo "$0: cannot extract '$i': Unknown file extension" >&2;
                    exitcode=1
                    ;;
            esac
            [[ -n $cmd ]] && command $cmd "$i"
        else
            echo "$0 cannot extract '$i': File is not readable" >&2
            exitcode=2
        fi
    done
    return $exitcode
}  

# pipe math expression to bc
function calc() {
    echo "scale=3; $@" | bc -l
}


fortune -s all | cowsay
echo

