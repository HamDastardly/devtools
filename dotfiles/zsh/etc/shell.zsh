# retry until return code is 0

function retry
{
    until ($@); do :; done
}

function chext
{
    if [[ $# -lt 2 ]]
    then
        echo "$0 -- Change file extension"
        echo "usage: $0 <from> <to> [*:\"file-pattern\"]"
        return 1
    fi

    local from=$1
    local to=$2
    local filter=${3:-*$from}

    for file in $~filter
    do
        mv -iv $file ${file%$from}$to
    done
}

# forward <C-s> to terminal program, don't trap it for control flow
stty -ixon

# cd to last directory ranger had open
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
