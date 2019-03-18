# cd to last directory ranger had open
alias ranger='ranger --choosedir=$HOME/.rangerdir; cd "$(cat $HOME/.rangerdir)"'

# use the configuration files in ~/.config/ranger
# to regenerate, run `ranger --copy-config=all`
# export RANGER_LOAD_DEFAULT_RC=FALSE
