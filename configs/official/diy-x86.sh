#!/bin/bash
#

# GCC CFlags
sed -i 's/Os/O2/g' include/target.mk
#sed -i 's/O2/O2 -march=x86-64-v2/g' include/target.mk
#sed -i 's/-Os -pipe/-O2 -pipe -march=x86-64-v2/g' include/target.mk

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.13/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's,OpenWrt,N100,g' package/base-files/files/bin/config_generate

# Timezone
#sed -i "s/'UTC'/'CST-8'\n   set system.@system[-1].zonename='Asia\/Shanghai'/g" package/base-files/files/bin/config_generate

# Add additional packages
rm -rf feeds/packages/net/{xray-core,v2ray-core,sing-box}
rm -rf feeds/luci/applications/{luci-app-ssr-plus,luci-app-passwall,luci-app-passwall2,luci-app-ddns}
git clone --depth=1 https://github.com/yunxi993/extra.git package/extra
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git package/luci-app-ddns-go
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/openwrt-passwall-packages

# Update Go Version
#rm -rf feeds/packages/lang/golang && git clone -b 26.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# Some adjust
#sed -i  "10a\\
#uci set firewall.@defaults[0].flow_offloading='1'\n\
#uci set firewall.@defaults[0].flow_offloading_hw='0'\n\
#uci commit firewall\n\n\
#uci set fstab.@global[0].anon_mount=1\n\
#uci commit fstab\n\n\
#uci delete network.@globals[0].ula_prefix\n\
#uci set network.@globals[0].packet_steering='0'\n\
#uci delete network.@globals[0].steering_flows='128'\n\n\
#uci del_list network.@device[0].ports='eth0'\n\
#uci add_list network.@device[0].ports='eth1'\n\
#uci add_list network.@device[0].ports='eth2'\n\
#uci add_list network.@device[0].ports='eth3'\n\
#uci del network.wan\n\
#uci set network.wan.device='eth0'\n\
#uci set network.wan.proto='pppoe'\n\
#uci del network.wan6\n\
#uci commit network\n\
#/etc/init.d/network restart\n\n\
#/etc/init.d/packet_steering disable\n\
#/etc/init.d/packet_steering stop\n\
#/etc/init.d/irqbalance disable\n\
#/etc/init.d/irqbalance stop\n\
#/etc/init.d/ddns disable\n\
#/etc/init.d/ddns stop\n\
#/etc/init.d/passwall2_server disable\n\
#/etc/init.d/passwall2_server stop\n\
#/etc/init.d/sing-box disable\n\
#/etc/init.d/sing-box stop\n\
#/etc/init.d/xray disable\n\
#/etc/init.d/xtay stop\n\n\
#" package/extra/default-settings/files/zzz-default-settings

# Remove snapshot tags
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i '/CONFIG_BUILDBOT/d' include/feeds.mk
sed -i 's/;)\s*\\/; \\/' include/feeds.mk
sed -i "s,OPENWRT_RELEASE=\"[^\"]*\",OPENWRT_RELEASE=\"%D %V $(date +"%y/%m/%d %H:%M")\",g" package/base-files/files/usr/lib/os-release
#sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='$(date +%Y-%m-%d)-%D %V %C'/g" package/base-files/files/etc/openwrt_release
#sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION='(by Sil)-%R'/g" package/base-files/files/etc/openwrt_release
#sed -i "s/OPENWRT_RELEASE=\"*.*\"/OPENWRT_RELEASE=\"$(date +%Y-%m-%d)-%D %V %C\"/g" package/base-files/files/usr/lib/os-release
#cp -f package/extra/banner/Sil  package/base-files/files/etc/banner/

# OpenWrt name
echo '#!/bin/sh
# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

if ! grep "Default string" /tmp/sysinfo/model > /dev/null; then
    echo should be fine
else
    echo "Generic x86_64" > /tmp/sysinfo/model
fi

status=$(cat /sys/devices/system/cpu/intel_pstate/status)

if [ "$status" = "passive" ]; then
    echo "active" | tee /sys/devices/system/cpu/intel_pstate/status
fi

#{ sleep 15; ethtool -A eth0 autoneg off rx on tx on; ethtool -A eth1 autoneg off rx on tx on; } &

(
sleep 10
[ -f '/mnt/nvme0n1p3/adguardhome.yaml' ] && cp -f '/mnt/nvme0n1p3/adguardhome.yaml' '/etc/adguardhome/'
/etc/init.d/adguardhome restart 

[ -f '/mnt/nvme0n1p3/passwall2' ] && cp -f '/mnt/nvme0n1p3/passwall2' '/etc/config/'

ls /mnt/nvme0n1p3/*.dat >/dev/null && cp -f /mnt/nvme0n1p3/*.dat /usr/share/v2ray/

#[ -f '/mnt/nvme0n1p3/push_nft.rule' ] && cp -f '/mnt/nvme0n1p3/push_nft.rule' '/etc/'
#[ -f '/mnt/nvme0n1p3/passwall2_server' ] && cp -f '/mnt/nvme0n1p3/passwall2_server' '/etc/config/'
#[ -f '/mnt/nvme0n1p3/ddns-go-config.yaml' ] && cp -f '/mnt/nvme0n1p3/ddns-go-config.yaml' '/etc/ddns-go/'
) &
sed -i '/^#{/,/^sed/d' /etc/rc.local && sed -i "/^$/N;/^\n$/D" /etc/rc.local

exit 0
'> ./package/base-files/files/etc/rc.local

# Default enable irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# Modify localtime
#sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm
