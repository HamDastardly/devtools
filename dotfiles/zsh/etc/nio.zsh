################################################################################
#                                Shell Settings                                #
################################################################################
insert_path $HOME/bin            post
insert_path $HOME/bin/s32k-tools post

export ASIMOV_DISABLE_CAN_SLEEP=1

################################################################################
#                                   Aliases                                    #
################################################################################
alias com="femtocom"
alias komodo="open -n -a \"komodo gui\"" # can open >1 instance

################################################################################
#                               Asimov Commands                                #
################################################################################
function asimov-
{
    work_dir="/Users/Hamilton.Little/work"
    upload_dir="/root/scp"
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
            smc) com $(asimov-ls-smc) -r 115200 ;;
            mcu) com $(asimov-ls-mcu) -r 115200 ;;
            me)  com $(asimov-ls-me)  -r 930600 ;;
        esac
    }

    # network commands
    function $0{scp,ssh,sftp,ping,id,connect}
    {
        local asimov_ssh_opts="-o StrictHostKeyChecking=no"
        local asimov_default_ip="172.20.1.12"

        case $(print $0 | cut -d '-' -f2) in
            ping) ping ${@:1} $asimov_default_ip ;;
            ssh)  retry asimov-ping -c1 -t1; ssh         $asimov_ssh_opts        root@$asimov_default_ip ${@:1}                            ;;
            scp)  retry asimov-ping -c1 -t1; scp         $asimov_ssh_opts ${@:1} root@$asimov_default_ip:$upload_dir/$(basename ${@:1})    ;;
            sftp) retry asimov-ping -c1 -t1; sftp        $asimov_ssh_opts        root@$asimov_default_ip                                   ;;
            id)   retry asimov-ping -c1 -t1; ssh-copy-id $asimov_ssh_opts        root@$asimov_default_ip; ssh-keygen -R $asimov_default_ip ;;
        esac
    }

    # diagnostics commands
    function $0slog{-once,-all,-new}{,-filter}
    {
        local cmd="slog2info -Saf"

        case $(print $0 | cut -d '-' -f3) in
            once)         ;;
            all) cmd+="w" ;;
            new) cmd+="W" ;;
        esac

        if [[ $(print $0 | cut -d '-' -f4) == "filter" ]]
        then
            cmd+="b ${@:1}"
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
    function $0{v,k}-update{,-bl}
    {
        case $(print $0 | cut -d '-' -f2-4) in
            k-update)
                local file=${1:-$s32k_build_dir/s32k-app.upd.bin}
                asimov-scp $$file && asimov-ssh "smc-update -i $upload_dir/$(basename $file)" ;;
            v-update)
                local file=${1:-$s32v_build_dir/app.bin}
                asimov-scp $file && asimov-ssh "nio-qspi-flash.sh app $upload_dir/$(basename $file) && shutdown" ;;
            v-update-bl)
                local file=${1:-$s32v_build_dir/ipl/ipl-asimov.bin}
                asimov-scp $file && asimov-ssh "nio-qspi-flash.sh boot $upload_dir/$(basename $file) && shutdown" ;;
        esac
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
}

# Call it once so parser is pre-loaded with asimov-* completions
# There should be a workaround the lazy evaluator in zsh, but im too lazy
asimov-
