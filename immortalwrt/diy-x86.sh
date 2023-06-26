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

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.13/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's/ImmortalWrt/nzksma/g' package/base-files/files/bin/config_generate

# Modify localtime
# sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm

# Add additional packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
#git clone --depth=1 -b luci https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
rm -rf package/helloworld/v2ray-core
rm -rf package/helloworld/xray-core

# Change default config
#cp -f $GITHUB_WORKSPACE/diy/0_default_config package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
#cp -f $GITHUB_WORKSPACE/diy/domains_excluded package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2

#sed -i "21a\\
#uci set firewall.@defaults[0].flow_offloading='0'\n\
#uci set firewall.@defaults[0].flow_offloading_hw='0'\n\
#uci commit firewall\n\
#" package/emortal/default-settings/files/99-default-settings

sed -i "27a\\
uci set network.@device[0].ports='eth1'\n\
uci add_list network.@device[0].ports='eth2'\n\
uci add_list network.@device[0].ports='eth3'\n\
uci commit network\n\n\
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
" package/emortal/default-settings/files/99-default-settings

sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

#sed -i "25a\\
#sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
#" package/emortal/default-settings/files/99-default-settings
