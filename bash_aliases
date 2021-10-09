# don't ignore line starting with a space
HISTCONTROL=ignoredups:erasedups
# big history
HISTSIZE=100000
# Option 'histreedit' allows users to re-edit a failed history substitution. 
shopt -s histreedit
# If set, minor errors in the spelling of a directory component in a cd command
# will be corrected.
shopt -s cdspell
# If set, Bash attempts spelling correction on directory names during word
# completion if the directory name initially supplied does not exist.
shopt -s dirspell
# If set, Bash lists the status of any stopped and running jobs before exiting
# an interactive shell.
shopt -s checkjobs
# If set, Bash attempts to save all lines of a multiple-line command in the
# same history entry. This allows easy re-editing of multi-line commands.
shopt -s cmdhist
# If set, and Readline is being used, the results of history substitution are
# not immediately passed to the shell parser. Instead, the resulting line is
# loaded into the Readline editing buffer, allowing further modification.
shopt -s histverify
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

alias j='jobs -l'
alias po=popd
alias pu=pushd
alias ls='ls -F --color=auto'

#[[ -s "/etc/profile.d/vte.sh" ]] && . "/etc/profile.d/vte.sh"

function _git_prompt() {
  local branch=`LC_ALL=C git symbolic-ref --short -q HEAD 2>&1`
  if ! [[ "$branch" =~ ot\ a\ git\ repo ]]; then
    if [ -z "$branch" ]; then
      # This command doesn't give the most obvious name sometimes
      branch=`LC_ALL=C git describe --all --contains --abbrev=4 HEAD 2> /dev/null`
      if [ $? -ne 0 ]; then
        branch="DETACHED 🙃"
      fi
    fi

    if [ -d "$(git rev-parse --git-path rebase-merge)" ]; then
      branch="$branch (rebase)"
    fi

    local git_status="`LC_ALL=C git status --porcelain --ignore-submodules -unormal 2>&1`"
    if [ -z "$git_status" ]; then
            local ansi=42
        elif [[ ! "$git_status" =~ ?? ]]; then
            local ansi=45
        else
            local ansi=43
        fi
        test "$branch" != master -a "$branch" != main || branch=' '
        echo -n '\[\e[0;37;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '
    fi
}

function _virtualenv_prompt() {
  if [ -n "$VIRTUAL_ENV" ] ; then
    virtual_env_basename=`basename "$VIRTUAL_ENV"`
    if [ "$virtual_env_basename" = venv ] ; then
      virtual_env_basename=`basename "${VIRTUAL_ENV%/*}"`
    fi
    echo -n "(${virtual_env_basename}) "
  fi
}

OLDPS1=$PS1
function _prompt_command() {
    PS1="`_virtualenv_prompt``_git_prompt`$OLDPS1"
}
PROMPT_COMMAND=_prompt_command
# Disabling the default pormpt handling of python virtualenv, because it doesn't
# work with the git prompt. Instead we roll up our own.
VIRTUAL_ENV_DISABLE_PROMPT=yes

CDPATH=".:~/travail/git/"
MOZPERF="/home/julien/travail/git/perf.html"
MOZCENTRAL="/home/julien/travail/git/mozilla-central"
MOZCENTRALARTIFACT="/home/julien/travail/git/mozilla-central-artifacts"
MOZPERFSERVER="/home/julien/travail/git/profiler-server"
alias go_perf="cd $MOZPERF"
alias go_central="cd $MOZCENTRAL"
alias go_server="cd $MOZPERFSERVER"
alias go_artifacts="cd $MOZCENTRALARTIFACT"

go() {
    if [ -z "$1" ] ; then
      go_perf
      return
    fi

    eval go_$1
    if [ -n "$2" ] ; then
      cd src/$2 || cd devtools/$2 || cd $2 || true
    fi
}

find_git_commit() {
    git cherry $1 | awk '{ print $2 }' | xargs -n 1 git branch --contains | sort | uniq
}

loc() {
  repwd="`pwd | sed 's/[]\\{}[\.$*+?^|()]/\\&/g'`"
  locate --regex "^${repwd}/.*$@" -i | grep -F -i "$@"
  #locate "$@" | grep -E --color=never ^"$repwd" | grep -F "$@"
}

PATH="$PATH:$HOME/node_modules/.bin:$HOME/.gem/ruby/2.5.0/bin:$HOME/.local/bin:$HOME/.mozbuild/git-cinnabar:$HOME/.mozbuild/version-control-tools/git/commands"
export FIREFOX=~/firefox-nightly/firefox
export FIREFOX_NIGHTLY_BIN=$FIREFOX
export PERL5LIB="$HOME/perl5/lib/perl5/"

export VISUAL=vim
export EDITOR=$VISUAL
# nice scrolling in Firefox
export MOZ_USE_XINPUT2=1
# wayland support in Firefox
#export GDK_BACKEND=wayland

export WEB_EXT_FIREFOX=~/firefox-nightly/firefox
