################################################################################
#                             Editing and Sourcing                             #
################################################################################
function profile-
{
    #profile-*
    function $0{zsh,tmux,nio}
    {
        case $(print $0 | cut -d '-' -f2) in
            zsh)  $EDITOR ~/.zsh             ; reload-zsh  ;;
            tmux) $EDITOR ~/.tmux.conf       ; reload-tmux ;;
            nio)  $EDITOR ~/.zsh/etc/nio.zsh ; reload-zsh  ;;
        esac
    }
}
profile-

function reload-
{
    #reload-*
    function $0{zsh,tmux}
    case $(print $0 | cut -d '-' -f2) in
        zsh) source ~/.zshrc ;;
        tmux) tmux source-file ~/.tmux.conf ;;
    esac
}
reload-



