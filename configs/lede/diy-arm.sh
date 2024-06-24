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
sed -i 's/192.168.1.1/192.168.11.11/g' package/base-files/files/bin/config_generate

#sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# Hostname
sed -i 's/OpenWrt/N1/g' package/base-files/files/bin/config_generate

# Modify localtime
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/arm/index.htm

# Enable AAAA
#sed -i 's/filter_aaaa	1/filter_aaaa	0/g' package/network/services/dnsmasq/files/dhcp.conf

# Disable Cache
#sed -i 's/cachesize	8000/cachesize	0/g' package/network/services/dnsmasq/files/dhcp.conf
#sed -i 's/mini_ttl		3600/mini_ttl		0/g' package/network/services/dnsmasq/files/dhcp.conf

# Disable rebind protection
#sed -i 's/rebind_protection 1/rebind_protection 0/g' package/network/services/dnsmasq/files/dhcp.conf
#chmod -R 755 package/network/services/dnsmasq/files/dhcp.conf

# Timezone
#sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# cpufreq
sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' feeds/luci/applications/luci-app-cpufreq/Makefile
sed -i 's/services/system/g' feeds/luci/applications/luci-app-cpufreq/luasrc/controller/cpufreq.lua

# Change default theme
#sed -i 's#luci-theme-bootstrap#luci-theme-opentomcat#g' feeds/luci/collections/luci/Makefile
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# Add additional packages
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/openwrt-passwall-packages
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/Leo-Jo-My/luci-theme-opentomcat.git package/luci-theme-opentomcat

sed -i '741a\
                <tr><td width="33%">&#32534;&#35793;&#32773;&#58;&#32;&#83;&#105;&#108;</td><td><a href="https://t.me/passwall2" style="color: black;" target="_blank">&#32676;&#32452;&#38142;&#25509;</a></td></tr>\
                <tr><td width="33%">&#28304;&#30721;&#58;&#32;&#108;&#101;&#100;&#101;</td><td><a href="https://github.com/coolsnowwolf/lede" style="color: black;" target="_blank">&#28304;&#30721;&#38142;&#25509;</a></td></tr>
' package/lean/autocore/files/arm/index.htm

# Default disable ntp server
sed -i "s/enable_server='1'/enable_server='0'/g" package/base-files/files/bin/config_generate

# Default disable
sed -i "63a\\
/etc/init.d/irqbalance disable\n\
/etc/init.d/irqbalance stop\n\
/etc/init.d/ddns disable\n\
/etc/init.d/ddns stop\n\
/etc/init.d/passwall2 disable\n\
/etc/init.d/passwall2 stop\n\
/etc/init.d/passwall2_server disable\n\
/etc/init.d/passwall2_server stop\n\
/etc/init.d/sing-box disable\n\
/etc/init.d/sing-box stop\n\
/etc/init.d/xray disable\n\
/etc/init.d/xray stop\n\
" package/lean/default-settings/files/zzz-default-settings

#rc.local
echo '# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

(sleep 10; ethtool -A eth0 autoneg off rx on tx on) &

exit 0
'> ./package/base-files/files/etc/rc.local

# Default enable irqbalance
#sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# containerd Has验证
#sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile

# Change default config
#cp -f $GITHUB_WORKSPACE/diy/0_default_config package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
#cp -f $GITHUB_WORKSPACE/diy/domains_excluded package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2

# Disable DNS Cache
#sed -i 's/global dns_cache 1/global dns_cache 0/g' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh

# re close bridge-nf
#sed -i '759,760d' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh && sed -i '779d' package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh
#chmod -R 755 package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/0_default_config && chmod -R 755 package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/domains_excluded && chmod -R 755 package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2/app.sh
