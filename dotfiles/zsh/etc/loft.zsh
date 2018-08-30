# rbenv ruby version manager
# needed for OpenSatKit
# https://raw.githubusercontent.com/OpenSatKit/OpenSatKit/vendor/install.sh
insert_path $HOME/.rbenv/bin   pre
insert_path $HOME/.rbenv/shims pre
eval "$(rbenv init -)"

# python pip installation path
insert_path $HOME/.local/bin pre

function picu-
{
    function $0tmux-all
    {
        case $(print $0 | cut -d '-' -f3) in
            all)
                cd $HOME/work/picu/

                pushd cFS
                tmux rename-window "FSW"
                tmux split-window -h -p30
                tmux select-pane -t0
                    tmux send-keys "${EDITOR}" Enter
                tmux select-pane -t1
                    tmux send-keys "make" Enter
                popd

                pushd cosmos
                tmux new-window -n "COSMOS"
                tmux select-pane -t0
                    tmux send-keys "${EDITOR}" Enter
                popd

                tmux new-window -n "Console"
                tmux split-window -h
                tmux select-pane -t1
                tmux split-window -v
                tmux select-pane -t1
                    tmux send-keys "cd cFS" Enter
                    tmux send-keys "make install && pushd build/exe/cpu1; ./core-cpu1; popd" Enter
                tmux select-pane -t2
                    tmux send-keys "cd cosmos" Enter
                    tmux send-keys "ruby Launcher" Enter
                ;;
        esac
    }
}
picu-
