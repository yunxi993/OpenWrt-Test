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

# Delete default password
sed -i "/CYXluq4wUazHjmCDBCqXF/d" package/lean/default-settings/files/zzz-default-settings

# Hostname
sed -i 's/OpenWrt/qnmlgb/g' package/base-files/files/bin/config_generate
#
# Enable AAAA
#sed -i 's/filter_aaaa	1/filter_aaaa	0/g' package/network/services/dnsmasq/files/dhcp.conf
#
# Disable Cache
#sed -i 's/cachesize	8000/cachesize	0/g' package/network/services/dnsmasq/files/dhcp.conf
#sed -i 's/mini_ttl		3600/mini_ttl		0/g' package/network/services/dnsmasq/files/dhcp.conf
#
# Disable rebind protection
#sed -i 's/rebind_protection 1/rebind_protection 0/g' package/network/services/dnsmasq/files/dhcp.conf
#chmod -R 755 package/network/services/dnsmasq/files/dhcp.conf
#
# Timezone
#sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# cpufreq
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/services/system/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua
#
# Change default theme
#sed -i 's#luci-theme-bootstrap#luci-theme-opentomcat#g' feeds/luci/collections/luci/Makefile
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# Add additional packages
git clone --depth=1 https://github.com/fw876/helloworld.git package/helloworld
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall.git package/openwrt-passwall
#git clone --depth=1 -b luci https://github.com/xiaorouji/openwrt-passwall.git package/luci-app-passwall
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat
#
# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile
#
# containerd Has验证
#sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile
#
#sed -i '741a \                <tr><td width="33%"><%:Compile Author%></td><td>https://t.me/passwall2</td></tr>' package/lean/autocore/files/arm/index.htm
#sed -i '741a \                <tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' package/lean/autocore/files/arm/index.htm
#sed -i '742a \                <tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' package/lean/autocore/files/x86/index.htm
#sed -i '4122a \\nmsgid "Compile Author"' feeds/luci/modules/luci-base/po/zh-cn/base.po
#sed -i '4123a msgstr "交流群"' feeds/luci/modules/luci-base/po/zh-cn/base.po
#echo '<tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' >> package/lean/autocore/files/arm/index.htm
#echo '<tr><td width="33%"><%:Compiler author%></td><td>https://t.me/passwall2</td></tr>' >> package/lean/autocore/files/x86/index.htm
#echo 'msgid "Compiler author"' >> feeds/luci/modules/luci-base/po/zh-cn/base.po
#echo 'msgstr "交流群"' >> feeds/luci/modules/luci-base/po/zh-cn/base.po
#
# Change default config
#cp -f $GITHUB_WORKSPACE/diy/0_default_config package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
#cp -f $GITHUB_WORKSPACE/diy/domains_excluded package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
#
# Disable DNS Cache
#sed -i 's/global dns_cache 1/global dns_cache 0/g' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh
#
# re close bridge-nf
#sed -i '759,760d' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh && sed -i '779d' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh
#chmod -R 755 package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/0_default_config && chmod -R 755 package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/domains_excluded && chmod -R 755 package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh

# Modify firewall rules
sed -i '40,46d' package/lean/default-settings/files/zzz-default-settings
echo '# iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo '# iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo '# [ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo '# [ -n "$(command -v ip6tables)" ] && ip6tables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 53' >> package/network/config/firewall/files/firewall.user
echo 'ip6tables -I FORWARD 2 -p tcp --sport 5223 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT' >> package/network/config/firewall/files/firewall.user
echo 'ip6tables -I FORWARD 2 -p tcp --dport 5223 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT' >> package/network/config/firewall/files/firewall.user
echo 'iptables -I FORWARD 2 -p tcp --sport 5223 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT' >> package/network/config/firewall/files/firewall.user
echo 'iptables -I FORWARD 2 -p tcp --dport 5223 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT' >> package/network/config/firewall/files/firewall.user

# Default enable software traffic offloading
sed -i "13i uci set firewall.@defaults[0].flow_offloading='1'" /mnt/test
sed -i "14i uci set firewall.@defaults[0].flow_offloading_hw='0'" /mnt/test
sed -i '15i uci commit firewall' /mnt/test
sed -i '16i\\' /mnt/test
