#/usr/bin/ienv bash
set -xe

sudo mkdir -p /lib/firmware/ath10k/QCA6174/hw3.0
sudo cp wifi_binaries/* /lib/firmware/ath10k/QCA6174/hw3.0
