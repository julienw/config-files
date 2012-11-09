alias j='jobs -l'
alias po=popd
alias pu=pushd
alias ls='ls -F'

function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
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

alias logcat="adb logcat | grep -v parsing | egrep '(JavaScript Error|>>>)'"

kill_b2g() {
    adb shell kill `adb shell ps | grep 'b2g/b2g' | awk '{ print $2 }'`
}

GAIADIR="/home/julien/travail/git/gaia"
MOZCENTRAl="/home/julien/travail/hg/mozilla-central"
B2G="/home/julien/travail/git/B2G"
alias go_gaia="cd $GAIADIR"
alias go_mozcentral="cd $MOZCENTRAL"
alias go_b2g="cd $B2G"
alias build_b2g="go_mozcentral && hg pull -u && make -f client.mk"
alias launch_tests='~/firefox-nightly/firefox --no-remote -profile $GAIADIR/profile/ http://test-agent.gaiamobile.org:8080/ &'

go() {
    eval go_$1
}
