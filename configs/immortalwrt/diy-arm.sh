#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-Selfuse.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# GCC CFlags
#sed -i 's/Os/O2/g' include/target.mk
sed -i 's,-mcpu=generic,-march=armv8-a+crypto -mtune=cortex-a53,g' include/target.mk

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.11/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's/ImmortalWrt/N1/g' package/base-files/files/bin/config_generate

# Modify localtime
# sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm

# Remove some packages
rm -rf feeds/luci/applications/luci-app-ssr-plus
rm -rf feeds/luci/applications/luci-app-passwall

#sed -i 's/[+]dockerd //' feeds/luci/applications/luci-app-dockerman/Makefile
#sed -i '39,42d' feeds/packages/utils/dockerd/Makefile
#sed -i -e '39,42d' -e '45d' feeds/packages/utils/dockerd/Makefile

# Add additional packages
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/openwrt-passwall-packages

# Remove snapshot tags
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt 23.05 $(date +%Y-%m-%d)'/g" package/base-files/files/etc/openwrt_release

sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

sed -i "25a\\
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
" package/emortal/default-settings/files/99-default-settings

#cp -rf $GITHUB_WORKSPACE/diy/glib2 feeds/packages/libs/
#cat feeds/packages/libs/glib2/Makefile
