compdef _waf waf

function _waf {
    local -a subcommands
    subcommands=('analyze'
                 'build'
                 'build_s32k'
                 'build_s32v'
                 'build_x86-64'
                 'clean'
                 'configure'
                 'distclean'
                 'mcu_flash'
                 'mcu_flash_bl'
                 'mcu_flash_primary'
                 'mcu_flash_secondary'
                 'smc_flash'
                 'smc_flash_app'
                 'smc_flash_bl'
                 'smc_gdb'
                 'smc_gdb_bl')
    _describe 'subcommand' subcommands
}

# _waf_completions()
# {
#     local cur="${COMP_WORDS[COMP_CWORD]}"
#     local words="analyze             \
#                  build               \
#                  build_s32k          \
#                  build_s32v          \
#                  build_x86-64        \
#                  clean               \
#                  configure           \
#                  distclean           \
#                  mcu_flash           \
#                  mcu_flash_bl        \
#                  mcu_flash_primary   \
#                  mcu_flash_secondary \
#                  smc_flash           \
#                  smc_flash_app       \
#                  smc_flash_bl        \
#                  smc_gdb             \
#                  smc_gdb_bl"

#     COMPREPLY=($(compgen -W "${words}" -- ${cur}))
#     return 0
# }

# complete -F _waf_completions waf

# eval $(thefuck --alias)

