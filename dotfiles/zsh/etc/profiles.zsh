################################################################################
#                             Editing and Sourcing                             #
################################################################################
function profile-
{
    #profile-*
    function $0{zsh,tmux,loft}
    {
        case $(print $0 | cut -d '-' -f2) in
            zsh)  $EDITOR ~/.zshrc                    ; reload-zsh  ;;
            tmux) $EDITOR ~/.tmux.conf                ; reload-tmux ;;
            loft)  $EDITOR ~/.config/zsh/etc/loft.zsh ; reload-zsh  ;;
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



