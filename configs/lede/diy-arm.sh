#!/bin/bash
#


# GCC CFlags
#sed -i 's/Os/O2/g' include/target.mk
sed -i 's,-mcpu=generic,-march=armv8-a+crypto -mtune=cortex-a53,g' include/target.mk

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.11/g' package/base-files/files/bin/config_generate

#sed -i '/CYXluq4wUazHjmCDBCqXF/d' package/lean/default-settings/files/zzz-default-settings

# Hostname
sed -i 's/OpenWrt/N1/g' package/base-files/files/bin/config_generate

# Modify localtime
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/arm/index.htm

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
uci set firewall.@defaults[0].flow_offloading='1'\n\
uci set firewall.@defaults[0].flow_offloading_hw='0'\n\
uci set firewall.@defaults[0].fullcone '0'\n\
uci set firewall.@defaults[0].fullcone6 '0'\n\
uci commit firewall\n\
#/etc/init.d/irqbalance disable\n\
#/etc/init.d/irqbalance stop\n\
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

# rc.local
echo '# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

#(sleep 10; ethtool -A eth0 autoneg off rx on tx on) &

#(sleep 10; ethtool -A eth0 rx on tx on) &

#(ethtool --set-eee eth0 eee off) &

/usr/sbin/balethirq.pl
/etc/first_run.sh >/root/first_run.log 2>&1
exit 0
'> ./package/base-files/files/etc/rc.local

# Default enable irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# SSH password
sed -i "25a\\
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
" package/lean/default-settings/files/zzz-default-settings

# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# containerd Has验证
#sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/packages/utils/containerd/Makefile

# Change default config
#cp -f $GITHUB_WORKSPACE/diy/0_default_config package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
#cp -f $GITHUB_WORKSPACE/diy/domains_excluded package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
