compdef _waf waf

function _waf {
    local -a targets
    targets=('analyze'
             'build'
             'build_s32k'
             'build_s32v'
             'build_x86-64'
             'clean'
             'configure'
             'distclean'
             'mcu_flash'
             'mcu_flash_app'
             'mcu_flash_app_direct'
             'mcu_flash_bl'
             'mcu_flash_ssh'
             'mcu_flash_uds'
             'smc_flash'
             'smc_flash_app'
             'smc_flash_bl'
             'smc_flash_ssh'
             'smc_gdb'
             'smc_gdb_bl'
             'smc_gdbserver')
    _describe 'target' targets
}
