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
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2 -pipe/O2 -pipe -march=x86-64-v2/g' include/target.mk

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.13/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's,OpenWrt,N100,g' package/base-files/files/bin/config_generate

# Timezone
#sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# cpufreq
#sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile
#sed -i 's/services/system/g' package/lean/luci-app-cpufreq/luasrc/controller/cpufreq.lua

# Change default theme
#sed -i 's,luci-theme-bootstrap,luci-theme-opentomcat,g' feeds/luci/collections/luci/Makefile
#sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap

# Add additional packages
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/sing-box
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/openwrt-passwall-packages
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/yunxi993/extra.git package/extra

# Remove snapshot tags
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION='Sil'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-23.05 $(date +%Y-%m-%d)'/g" package/base-files/files/etc/openwrt_release
cp -f package/extra/banner/Sil  package/base-files/files/etc/banner

sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# Modify localtime
# sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm

# Change default config
cp -f $GITHUB_WORKSPACE/diy/Makefile feeds/packages/lang/golang/golang/Makefile
cp -f $GITHUB_WORKSPACE/diy/002-fix-adding-offloading-device.patch package/network/config/firewall4/patches/
cp -f $GITHUB_WORKSPACE/diy/10_system.js /feeds/luci/modules/luci-mod-status/htdocs/luci-static/resources/view/status/include/10_system.js
#cp -f $GITHUB_WORKSPACE/diy/0_default_config package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2
#cp -f $GITHUB_WORKSPACE/diy/domains_excluded package/openwrt-passwall2/luci-app-passwall2/root/usr/share/passwall2

#sed -i "21a\\
#uci set firewall.@defaults[0].flow_offloading='0'\n\
#uci set firewall.@defaults[0].flow_offloading_hw='0'\n\
#uci commit firewall\n\
#" package/emortal/default-settings/files/99-default-settings

#sed -i "27a\\
#uci set network.@device[0].ports='eth1'\n\
#uci add_list network.@device[0].ports='eth2'\n\
#uci add_list network.@device[0].ports='eth3'\n\
#uci commit network\n\n\
#sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
#" package/emortal/default-settings/files/99-default-settings

#sed -i "25a\\
#sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
#" package/default-settings-23.05.0/default-settings/files/99-default-settings

#curl -fsSL https://raw.githubusercontent.com/yunxi993/OpenWrt-Patch/mast/docerdpatch/Makefile > feeds/packages/utils/dockerd/Makefile
#curl -fsSL https://raw.githubusercontent.com/yunxi993/OpenWrt-Patch/mast/docerdpatch/dockerd.init > feeds/packages/utils/dockerd/files/dockerd.init
#curl -fsSL https://raw.githubusercontent.com/yunxi993/OpenWrt-Test/main/diy/Makefile feeds/packages/lang/golang/golang/Makefile

echo '# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

grep "Default string" /tmp/sysinfo/model >> /dev/null
if [ $? -ne 0 ];then
    echo should be fine
else
    echo "Generic_x86" > /tmp/sysinfo/model
fi

exit 0
'> ./package/base-files/files/etc/rc.local
