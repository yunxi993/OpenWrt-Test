#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# sed -i 's/LINUX_VERSION-6.1 = .28/LINUX_VERSION-6.1 = .27/g' include/kernel-6.1
# sed -i 's/LINUX_KERNEL_HASH-6.1.28 = 7a094c1428b20fef0b5429e4effcc6ed962a674ac6f04e606d63be1ddcc3a6f0/LINUX_KERNEL_HASH-6.1.27 = c2b74b96dd3d0cc9f300914ef7c4eef76d5fac9de6047961f49e69447ce9f905/g' include/kernel-6.1

sed -i "57a\\
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
" package/lean/default-settings/files/zzz-default-settings
