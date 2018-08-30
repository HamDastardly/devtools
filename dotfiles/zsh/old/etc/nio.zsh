################################################################################
#                                Shell Settings                                #
################################################################################
insert_path $HOME/bin            post
insert_path $HOME/bin/s32k-tools post

export power_switch_ip='10.118.48.131'
export jlink_ip='10.118.48.132'
export asimov_ip='10.118.48.133' #default: 172.20.1.12
export rpi_ip='10.118.48.134'
export mac_ip='10.118.48.140'

# this hasn't been ported to build_parameters.py yet
export JLINK_IP=$jlink_ip

################################################################################
#                                   Aliases                                    #
################################################################################
alias komodo="open -n -a \"komodo gui\"" # can open >1 instance

################################################################################
#                               Asimov Commands                                #
################################################################################
function asimov-
{
    work_dir="/Users/Hamilton.Little/work"
    upload_dir="scp"
    s32k_build_dir="$work_dir/asimov/build/s32k/platform/s32k"
    s32v_build_dir="$work_dir/asimov/build/s32v/platform/s32v"

    # ls serial devices
    function $0ls-{smc,mcu,me}
    {
        local dev_teriminator_smc=3
        local dev_teriminator_mcu=1
        local dev_teriminator_me=0

        case $(print $0 | cut -d '-' -f3) in
            smc) ls /dev/tty.usbserial* | grep $dev_teriminator_smc$ ;;
            mcu) ls /dev/tty.usbserial* | grep $dev_teriminator_mcu$ ;;
            me)  ls /dev/tty.usbserial* | grep $dev_teriminator_me$  ;;
        esac
    }

    # connect to serial devices
    function $0serial-{smc,mcu,me}
    {

        case $(print $0 | cut -d '-' -f3) in
            smc) minicom -b 115200 -D $(asimov-ls-smc) ;;
            mcu) minicom -b 115200 -D $(asimov-ls-mcu) ;;
            me)  minicom -b 115200 -D $(asimov-ls-me)  ;;
        esac
    }

    # network commands
    function $0{scp,ssh,sftp,ping}
    {
        local options="-o StrictHostKeyChecking=no"

        case $(print $0 | cut -d '-' -f2) in
            ping) ping -c2 -t2 -o $asimov_ip ;;
            ssh)  retry asimov-ping; ssh  $options        root@$asimov_ip ${@:1}       ;;
            scp)  retry asimov-ping; scp  $options ${@:1} root@$asimov_ip:$upload_dir/ ;;
            sftp) retry asimov-ping; sftp $options        root@$asimov_ip              ;;
        esac
    }

    # network invoked commands
    function $0v-shutdown
    {
        case $(print $0 | cut -d '-' -f3) in
            shutdown) asimov-ssh shutdown
        esac
    }

    # diagnostics commands
    function $0slog{,-filter}
    {
        local cmd="slog2info -Saf"

        if [[ $(print $0 | cut -d '-' -f3) == "filter" ]]
        then
            cmd+=" -b ${@:1}"
        fi

        asimov-ssh $cmd
    }

    # tftp commands
    function $0tftp-{start,stop,set}
    {
        local tftp_file="/private/tftpboot/app-uboot.bin"

        case $(print $0 | cut -d '-' -f3) in
            start) sudo launchctl start com.apple.tftpd; sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist ;;
            stop) sudo launchctl unload -F /System/Library/LaunchDaemons/tftp.plist; sudo launchctl stop com.apple.tftpd ;;
            set)
                local file=${1:-$s32v_build_dir/app-uboot.bin}
                rm -f $tftp_file; ln -s $(realpath $file) $tftp_file ;;
        esac
    }

    # MCU reflash options
    function $0{v,k}-update-{app,bl}
    {
        case $(print $0 | cut -d '-' -f2-4) in
            k-update-app) local default="$s32k_build_dir/s32k-app.upd.bin"   ; local arg="--smc_app"  ;;
            k-update-bl)  local default="$s32k_build_dir/s32k-bl.upd.bin"    ; local arg="--smc_boot" ;;
            v-update-app) local default="$s32v_build_dir/app.bin"            ; local arg="--mcu_app"  ;;
            v-update-bl)  local default="$s32v_build_dir/ipl/ipl-asimov.bin" ; local arg="--mcu_boot" ;;
        esac

        local file=${1:-$default}
        asimov-scp $file && asimov-ssh "flash -v $arg $upload_dir/$(basename $file) --reboot"
    }

    # UDS commands
    function $0uds-{bundle{,-all},reset,update}
    {
        local uds_dir="$work_dir/uds"
        local bundle_dir="$work_dir/asimov/platform/s32v/uds/utils"

        case $(print $0 | cut -d '-' -f3,4) in
            bundle) $bundle_dir/fwupdate-bundle.py ${@:1} ;;
            bundle-all) $bundle_dir/fwupdate-bundle.py --smc_app  $s32k_build_dir/s32k-app.upd.bin      \
                                                       --mcu_boot $s32v_build_dir/ipl/ipl-asimov.bin    \
                                                       --mcu_app  $s32v_build_dir/app.bin               \
                                                       --swpn "$(whoami)-$(git rev-parse --short HEAD)" \
                                                       --baseline 01                                    \
                                                       --out $uds_dir/fw_bundles ;;
            reset)  $uds_dir/reset.py          ;;
            update) $uds_dir/updater.py ${@:1} ;;
        esac
    }

    # uboot
    function $0uboot-build
    {
        case $(print $0 | cut -d '-' -f3) in
            build) open $work_dir/s32v-uboot-toolchain/case-sensitive.sparseimage &&                \
                   CROSS_COMPILE=/Volumes/case-sensitive/install/bin/aarch64-linux-gnu- make -j8 && \
                   (cd tools/s32v234-qspi && CROSS_COMPILE=/Volumes/case-sensitive/install/bin/aarch64-linux-gnu- make) ;;
        esac
    }

    # JLink loadbin/savebin
    function $0s32k-{load,save}bin-{flash,flash_bl,flash_data,flash_data_vpd,flash_app,flash_app_rsvd,flash_spare,flash_reserved,flash_vpd_rsvd,flash_key_store,flash_log,flex_ram,ram}
    {
        case $(print $0 | cut -d '-' -f4) in
            flash)           local default='s32k-flash.bin'           ; local address=0x00000000 ; local size=0x80000  ;; # 512K
            flash_bl)        local default='s32k-flash_bl.bin'        ; local address=0x00000000 ; local size=0x8000   ;; # 32K
            flash_data)      local default='s32k-flash_data.bin'      ; local address=0x00008000 ; local size=0x8000   ;; # 32K
            flash_data_vpd)  local default='s32k-flash_data_vpd.bin'  ; local address=0x0000F000 ; local size=0x1000   ;; # 4K
            flash_app)       local default='s32k-flash_app.bin'       ; local address=0x00010000 ; local size=0x30000  ;; # 192K
            flash_app_rsvd)  local default='s32k-flash_app_rsvd.bin'  ; local address=0x00040000 ; local size=0x8000   ;; # 32K
            flash_spare)     local default='s32k-flash_spare.bin'     ; local address=0x00048000 ; local size=0x30000  ;; # 192K
            flash_reserved)  local default='s32k-flash_reserved.bin'  ; local address=0x00078000 ; local size=0x8000   ;; # 32K
            flash_vpd_rsvd)  local default='s32k-flash_vpd_rsvd.bin'  ; local address=0x10000000 ; local size=0x1000   ;; # 4K
            flash_key_store) local default='s32k-flash_key_store.bin' ; local address=0x10001000 ; local size=0x3000   ;; # 12K
            flash_log)       local default='s32k-flash_log.bin'       ; local address=0x10004000 ; local size=0xC000   ;; # 48K
            flex_ram)        local default='s32k-flex_ram.bin'        ; local address=0x14000000 ; local size=0xE00    ;; # 4K - 512
            ram)             local default='s32k-ram.bin'             ; local address=0x1FFF8000 ; local size=0xF000   ;; # 60K
        esac

        local file=${1:-$default}
        echo $file

        case $(print $0 | cut -d '-' -f3) in
            loadbin) local cmd="loadbin \"$file\", $address" ;;
            savebin) local cmd="savebin \"$file\", $address, $size" ;;
        esac

        local commands='/tmp/commands.txt'
        : >$commands
        echo "connect" >>$commands
        echo "$cmd"    >>$commands
        echo "exit"    >>$commands
        JLinkExe -Device S32K144 -If SWD -speed auto -CommandFile $commands
    }

    # tmux commands
    function $0tmux-{1,2,3}
    {
        case $(print $0 | cut -d '-' -f3) in
            1) # code editing
                tmux rename-window "Asimov Editor"
                # nvim - LHS 70%
                tmux split-window -h -p30
                tmux select-pane -t0
                tmux send-keys "${EDITOR}" Enter
                ;;
            2) # Console
                tmux new-window -n "Asimov Console"
                # slog | can keep alive - bottom panel
                tmux split-window -v -p20
                tmux select-pane -t1
                tmux send-keys "slog.sh -sfaw" Enter
                tmux split-window -h -p30
                tmux select-pane -t2
                tmux send-keys "rpi-ssh" Enter "can.sh 0 1 2 3 4 5" Enter
                tmux split-window -v
                tmux select-pane -t3
                tmux send-keys "rpi-ssh" Enter "kcontrol.py" Enter
                # serial consoles - RHS split
                tmux select-pane -t0
                tmux split-window -h
                tmux select-pane -t1
                tmux send-keys "sleep 2s" Enter "rpi-ssh" Enter "asimov-serial-smc" Enter
                tmux split-window -v
                tmux select-pane -t2
                tmux send-keys "sleep 2s" Enter "rpi-ssh" Enter "asimov-serial-mcu" Enter
                # LHS ssh
                tmux select-pane -t0
                tmux send-keys "ssh.sh" Enter
                ;;
            3) # SMC gdb
                tmux new-window -n "Asimov GDB"
                # nvim read-only - RHS TOP
                tmux split-window -h
                tmux select-pane -t1
                tmux send-keys "${EDITOR} -R" Enter
                # gdbserver - RHS BOT
                tmux split-window -v -p20
                tmux select-pane -t2
                tmux send-keys "waf smc_gdbserver" Enter
                #LHS - gdb
                tmux select-pane -t0
                tmux send-keys "waf smc_gdb" Enter
                ;;
        esac
    }
}
asimov-

function rpi-
{
    # network commands
    function $0{scp,ssh,sftp,ping}
    {
        case $(print $0 | cut -d '-' -f2) in
            ping) ping -c2 -t2 -o $rpi_ip ;;
            ssh)  retry rpi-ping; ssh         hamilton@$rpi_ip ${@:1}       ;;
            scp)  retry rpi-ping; scp  ${@:1} hamilton@$rpi_ip:$upload_dir/ ;;
            sftp) retry rpi-ping; sftp        hamilton@$rpi_ip              ;;
        esac
    }
}
rpi-
