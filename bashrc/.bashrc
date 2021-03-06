export VIDEO_RECORDING_RESOLUTION='1600x900' # у меня такой экран
export VIDEO_CONVERT_RESOLUTION='1280x720' # ютуб до такого размера пожмёт всё равно. Заливать меньше
export VIDEO_SAVING_PATH=~/.db/history/video
export MIC_SAVING_PATH=~/.db/history/mic
export VOICEMAIL_SAVING_PATH=~/.db/history/voicemail
export NAMED_MIC_SAVING_PATH=~/.db/history/talk
export PRJ_REPOSITORY="git@github.com:Bubujka/prj.git" # реп для мелких приватных проектов
export ADMIN_EMAIL="zendzirou@gmail.com"
export BROWSER="google-chrome"
# https://twitter.com/michaelhoffman/status/639178145673932800

HISTFILE="${HOME}/.history/$(date -u +%Y_%m_%d.%H.%M.%S)_${HOSTNAME}_$$"

alias s3-kotex='s3cmd -c ~/.s3cfg-kotex'
alias s3-my='s3cmd -c ~/.s3cfg-my'
alias s3-beta='s3cmd -c ~/.s3cfg-beta'


[[ -s "$HOME/.rvm/scripts/rvm" ]] && \
  . "$HOME/.rvm/scripts/rvm"

. "$HOME/.password"
export DEBUG='app*'
export NODE_ENV='development'
export PHP_ENV='development'
export PRJ_ENV='dev'

export PATH=$PATH:$HOME/.rvm/bin
export PATH=$HOME/.node/bin:$HOME/.bu.bin/bin:$HOME/.db/bin/stable:$HOME/.db/bin:$PATH
export PATH=$PATH:$HOME/.omega.bin/bin
export PATH=$PATH:$HOME/.bu.cards/bin
export PATH=$PATH:$HOME/.bu.bin/bin
export PATH=$PATH:$HOME/.git-radar
. ~/.bin_path
. ~/.bu.bin/alias
source ~/.ssh_agent_info


complete -cf sudo
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export EDITOR=vim
export PS1='\n\[\033[32m\]\u@\h\[\033[36m\] \w\[\033[33m\]$(__git_ps1)\[\033[34m\]\n\$\[\033[00m\] '

export GIT_PS1_SHOWDIRTYSTATE=1
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

source ~/.bu.bin/alias

complete -C ~/.db/bin/completion/rake -o default rake
complete -C ~/.db/bin/completion/fill ./fill
complete -C ~/.db/bin/completion/task ./task
complete -C ~/.db/bin/completion/mode mode
complete -C ~/.db/bin/completion/life life
complete -C ~/.db/bin/completion/prog prog
complete -C ~/.db/bin/completion/tt tt
#stty stop undef
nu() {
  if [ ! -f ~/.git-repos ]; then
    echo "Нет файла +_+"
    find ~/ -type d -name '.git' > ~/.git-repos
  fi

  if test "`find ~/.git-repos -mmin +10`"; then
    echo "Кэш старый +_+"
    find ~/ -type d -name '.git' > ~/.git-repos
  fi
  for dir in `cat ~/.git-repos | grep -v .gvm`
  do
    if [ -d "$dir" ]; then
      echo -n '.'
      cd $dir;
      cd ..
      if [ $(cat .git/config | grep 'remote "origin"' | wc -l) == 0 ] ;
      then
        echo
        echo "У репозитория нет origin!"
        git status
        return
      fi
      if [ $(git status --porcelain | wc -l ) != 0 ] ;
      then
        echo
        echo "Надо закоммитить"
        git status
        return
      fi
      if [ $(git log --branches --not --remotes | wc -l ) != 0 ] ;
      then
        echo
        echo "Не всё отправлено на сервер"
        git log --branches --not --remotes --simplify-by-decoration --decorate --oneline
        return
      fi
    else
      echo -n 'm'
    fi
  done
  cd
}

nun() {
  if [ ! -f ~/.git-repos ]; then
    echo "Нет файла +_+"
    find ~/ -type d -name '.git' > ~/.git-repos
  fi

  if test "`find ~/.git-repos -mmin +10`"; then
    echo "Кэш старый +_+"
    find ~/ -type d -name '.git' > ~/.git-repos
  fi
  for dir in `cat ~/.git-repos`
  do
    if [ -d "$dir" ]; then
      echo -n '.'
      cd $dir;
      cd ..
      if [ $(cat .git/config | grep 'remote "origin"' | wc -l) == 0 ] ;
      then
        echo
        echo "У репозитория нет origin!"
        git status
        return
      fi
      if [ $(git status --porcelain | wc -l ) != 0 ] ;
      then
        echo
        echo "Надо закоммитить"
        git status
        return
      fi
    else
      echo -n 'm'
    fi
  done
  cd
}
gua() {
  for dir in `find ~/ -type d -name '.git'`
  do
    cd $dir;
    cd ..
    basename "$(pwd)"
    pwd
    git pull
    echo
  done
  nu
}

uunu() {
  uu
  nu
}


_dk()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(ls ~/.db/dokuro/prj)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

dk() {
  if [ "$1" == "" ]; then
    cd ~/.db/dokuro/prj
  else
    cd ~/.db/dokuro/prj/$1
  fi
}

complete -F _dk dk


_prj() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(_projects)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}


p() {
  local dir
  dir=$(_projects | fzf +m) && cd $(_projects -e "$dir")
}

d() {
  local dir
  dir=$(ls ~/.db/ | fzf +m) && cd ~/.db/"$dir"
}

w() {
  local dir
  dir=$(ls ~/.db/wiki/ | fzf +m) && vim ~/.db/wiki/"$dir"
}
_cook()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(ls ~/.db/beta/kitchen/nodes | sed 's/.json$//')
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _cook cook

. ~/.bin-private/beta.bin/include
alias st='cd ~/.db/storage'
alias гг='uu'
alias ггтг='uunu'
alias s3-kotex='s3cmd -c ~/.s3cfg-kotex'
alias s3-my='s3cmd -c ~/.s3cfg-my'
alias s3-beta='s3cmd -c ~/.s3cfg-beta'
alias wiki='cd ~/.db/wiki'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export PATH=$PATH:/opt/nwjs

export NVM_DIR="/home/bubujka/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[[ -s "/home/bubujka/.gvm/scripts/gvm" ]] && source "/home/bubujka/.gvm/scripts/gvm"


# Команда для перехода к папке с использованием fzf
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}


# Запуск и подключение gpg-agent - чтобы по сотне раз не вводить пароль к почте
envfile="$HOME/.gnupg/gpg-agent.env"
if [[ -e "$envfile" ]] && kill -0 $(grep GPG_AGENT_INFO "$envfile" | cut -d: -f 2) 2>/dev/null; then
    eval "$(cat "$envfile")"
else
    eval "$(gpg-agent --daemon --write-env-file "$envfile")"
fi
export GPG_AGENT_INFO  # the env file does not contain the export statement
