# rbenv ruby version manager
# needed for OpenSatKit
# https://raw.githubusercontent.com/OpenSatKit/OpenSatKit/vendor/install.sh
insert_path $HOME/.rbenv/bin   pre
insert_path $HOME/.rbenv/shims pre
insert_path $HOME/tools/grmon-pro-3.0.16/linux/bin64/ post
eval "$(rbenv init -)"

# python pip installation path
insert_path $HOME/.local/bin pre

function picu-
{
    function $0up
    {
        cd $HOME/work/picu

        tmux rename-window "Gen1"
        tmux split-window -v -p30
        tmux select-pane -t1
        tmux split-window -h -p50

        tmux select-pane -t0
        cd gen1
        tmux send-keys "${EDITOR} ." Enter

        tmux select-pane -t1
        tmux send-keys "docker/build/stop.sh" Enter
        tmux send-keys "docker/build/start.sh" Enter
        tmux send-keys "scripts/build.sh vendor:loft" Enter
        tmux send-keys "scripts/build.sh -c 'make CONFIG=linux -j12 clean' picu:all psp:linux src/deployment/test_deployment" Enter
        tmux send-keys "scripts/build.sh -c 'make CONFIG=linux -j12 target' picu:all psp:linux src/deployment/test_deployment" Enter

        tmux select-pane -t2
        tmux send-keys "git status" Enter
    }
}
picu-

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/hamilton/tools/google-cloud-sdk/path.zsh.inc' ]; then . '/home/hamilton/tools/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/hamilton/tools/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/hamilton/tools/google-cloud-sdk/completion.zsh.inc'; fi
