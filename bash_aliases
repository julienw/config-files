# don't ignore line starting with a space
HISTCONTROL=ignoredups
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

alias j='jobs -l'
alias po=popd
alias pu=pushd
alias ls='ls -F --color=auto'

#[[ -s "/etc/profile.d/vte.sh" ]] && . "/etc/profile.d/vte.sh"

function _git_prompt() {
    local git_status="`LC_ALL=C git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=42
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=43
        else
            local ansi=45
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master || branch=' '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\[\e[0;37;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '
    fi
}

OLDPS1=$PS1
function _prompt_command() {
    PS1="`_git_prompt`$OLDPS1"
}
PROMPT_COMMAND=_prompt_command

alias adblogcat="while true ; do adb logcat -v threadtime; done"
alias greplogcat="egrep '(JavaScript Error|>>>|Content JS|Offline cache|LOG:)'"
alias grepdebug="egrep '(JavaScript Error|>>>|\-\*\-|=\*=|-@-|Content JS|Offline cache|LOG:|MobileMessageDatabaseService:|Network Worker)'"
alias logcat="adblogcat | greplogcat"
alias debuglogcat="adblogcat | grepdebug"

kill_b2g() {
  adb shell stop b2g && adb shell start b2g
#    adb shell kill `adb shell ps | grep 'b2g/b2g' | awk '{ print $2 }'`
}

GAIADIR="/home/julien/travail/git/gaia"
CDPATH=".:$GAIADIR/apps"
MOZCENTRAL="/home/julien/travail/hg/mozilla-central-really"
MOZBETA="/home/julien/travail/hg/mozilla-beta"
MOZB2G="/home/julien/travail/hg/mozilla-b2g18"
MOZPERF="/home/julien/travail/hg/mozilla-b2g18-perf"
B2G="/home/julien/travail/git/B2G"
FLASHTOOL="/home/julien/travail/git/B2G-flash-tool"
alias go_gaia="cd $GAIADIR"
alias go_central="cd $MOZCENTRAL"
alias go_b2g="cd $B2G"
alias go_beta="cd $MOZBETA"
alias go_18="cd $MOZB2G"
alias go_perf="cd $MOZPERF"
alias go_flash="cd $FLASHTOOL"
alias go_sms="go gaia sms"
alias build_b2g="go_mozcentral && hg pull -u && make -f client.mk"
alias adbforward="adb forward tcp:6000 tcp:60000"
alias adbtest="adb forward tcp:2828 tcp:2828"
alias b2gps="adb shell b2g-ps"
alias pushapp="install-to-adb"

pushmydata() {
  for tentativedir in permanent persistent ; do
    true=`adb shell "[ -d /data/local/storage/$tentativedir ] && echo true" | tr -d '\r'`
    if [ "$true" = "true" ] ; then
      dir="$tentativedir"
    fi
  done

  if [ -z "$dir" ] ; then
    echo "Storage directory not found, exiting."
    exit 1
  fi

  adb shell stop b2g
  for i in csot ssm ; do
    # "rm -r /.../*{csot,ssm}*" stops at the first file that does not exist.
    # "rm -rf" does not but is not available on all gonks.
    adb shell rm -r /data/local/storage/$dir/chrome/idb/*$i*
  done

  for i in *{csot,ssm}* ; do
    adb push $i /data/local/storage/$dir/chrome/idb/$i
  done
  adb shell start b2g
}

go() {
    if [ -z "$1" ] ; then
      go_gaia
      return
    fi

    eval go_$1
    if [ -n "$2" ] ; then
      cd apps/$2 || cd $2 || true
    fi
}

find_git_commit() {
    git cherry $1 | awk '{ print $2 }' | xargs -n 1 git branch --contains | sort | uniq
}

launch_tests() {
    cd $GAIADIR
    if [ ! -d profile-tests/extensions/httpd ] ; then
       PROFILE_FOLDER=profile-tests DEBUG=1 DESKTOP=0 make
#        DEBUG=1 make
    fi
    #~/firefox-aurora-64b/firefox --no-remote -profile profile-debug/ http://test-agent.gaiamobile.org:8080/ &
    ~/firefox-nightly/firefox --no-remote -profile profile-tests/ http://test-agent.gaiamobile.org:8080/ &
    make test-agent-server
}


alias resetapps="adb push ~/travail/webapps.json /data/local/webapps/"

alias hgup="hg qpop -a && hg pull -u && hg qpush -a"

loc() {
  repwd="`pwd | sed 's/[]\\{}[\.$*+?^|()]/\\&/g'`"
  locate --regex "^${repwd}/.*$@" -i | grep -F -i "$@"
  #locate "$@" | grep -E --color=never ^"$repwd" | grep -F "$@"
}

PATH="~/travail/git/moz-git-tools:$PATH"
export FIREFOX=~/firefox-nightly/firefox
export FIREFOX_NIGHTLY_BIN=$FIREFOX
export PERL5LIB="$HOME/perl5/lib/perl5/"


