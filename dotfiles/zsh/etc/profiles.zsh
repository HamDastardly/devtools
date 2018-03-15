################################################################################
#                             Editing and Sourcing                             #
################################################################################
function profile
{
    #profile-*
    function $0-{zsh,tmux,nio}
    {
        case $(print $0 | cut -d '-' -f2) in
            zsh)  vim ~/.zshrc ;;
            tmux) vim ~/.tmux.conf ;;
            nio)  vim ~/.zsh/etc/nio.zsh ;;
        esac
    }
}
profile

function reload
{
    #reload-*
    function $0-{zsh,tmux}
    case $(print $0 | cut -d '-' -f2) in
        zsh) source ~/.zshrc ;;
        tmux) tmux source-file ~/.tmux.conf ;;
    esac
}
reload



