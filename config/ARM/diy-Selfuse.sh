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
sed -i 's/192.168.1.1/192.168.1.11/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's/OpenWrt/qnmlgb/g' package/base-files/files/bin/config_generate

# Enable AAAA
echo option filter_aaaa	1 | sed -i 's/1/0/g' package/network/services/dnsmasq/files/dhcp.conf

# Disable Cache
echo option cachesize 8000 | sed -i 's/8000/0/g' package/network/services/dnsmasq/files/dhcp.conf
echo option mini_ttl 3600 | sed -i 's/3600/0/g' package/network/services/dnsmasq/files/dhcp.conf

# Disable DNS Cache
echo DNS_CACHE=$(config_t_get global dns_cache 1) | sed -i 's/1/0/g' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh

# Timezone
#sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# cpufreq
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/services/system/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua

# Change default theme
#sed -i 's#luci-theme-bootstrap#luci-theme-opentomcat#g' feeds/luci/collections/luci/Makefile
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# Add additional packages
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
#git clone --depth=1 -b luci https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat

# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# containerd Has验证
#sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile

#sed -i '741a \                <tr><td width="33%"><%:Compile Author%></td><td>https://t.me/passwall2</td></tr>' package/lean/autocore/files/arm/index.htm
#sed -i '741a \                <tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' package/lean/autocore/files/arm/index.htm
#sed -i '742a \                <tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' package/lean/autocore/files/x86/index.htm
#sed -i '4122a \\nmsgid "Compile Author"' feeds/luci/modules/luci-base/po/zh-cn/base.po
#sed -i '4123a msgstr "交流群"' feeds/luci/modules/luci-base/po/zh-cn/base.po
#echo '<tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' >> package/lean/autocore/files/arm/index.htm
#echo '<tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' >> package/lean/autocore/files/x86/index.htm
#echo 'msgid "Compiler author"' >> feeds/luci/modules/luci-base/po/zh-cn/base.po
#echo 'msgstr "交流群"' >> feeds/luci/modules/luci-base/po/zh-cn/base.po

cp -f $GITHUB_WORKSPACE/diy/0_default_config package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
cp -f $GITHUB_WORKSPACE/diy/domains_excluded package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2