#!/bin/bash
#

# GCC CFlags
#sed -i 's/Os/O2/g' include/target.mk
sed -i 's,-mcpu=generic,-march=armv8-a+crypto -mtune=cortex-a53,g' include/target.mk

# Modify default IP
sed -i 's/192.168.1.1/192.168.11.11/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's/ImmortalWrt/N1/g' package/base-files/files/bin/config_generate

# Modify localtime
#sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm

#sed -i 's/[+]dockerd //' feeds/luci/applications/luci-app-dockerman/Makefile
#sed -i '39,42d' feeds/packages/utils/dockerd/Makefile
#sed -i -e '39,42d' -e '45d' feeds/packages/utils/dockerd/Makefile

# Add additional packages
rm -rf feeds/packages/net/{xray-core,v2ray-core,sing-box}
rm -rf feeds/luci/applications/{luci-app-ssr-plus,luci-app-passwall,luci-app-passwall2,luci-app-ddns-go}
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go.git package/luci-app-ddns-go
#git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/openwrt-passwall-packages

# Update Go Version
rm -rf feeds/packages/lang/golang && git clone -b 24.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# Remove snapshot tags
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i "s,OPENWRT_RELEASE=\"[^\"]*\",OPENWRT_RELEASE=\"%D %V $(date +"%y/%m/%d %H:%M")\",g" package/base-files/files/usr/lib/os-release

# Some adjust
sed -i  "19a\\
#uci set firewall.@defaults[0].flow_offloading='1'\n\
#uci set firewall.@defaults[0].flow_offloading_hw='0'\n\
#uci commit firewall\n\n\
uci delete network.@globals[0].ula_prefix\n\
#uci delete network.@globals[0].packet_steering='1'\n\
#uci delete network.@globals[0].steering_flows='128'\n\n\
#uci del network.wan\n\
uci commit network\n\n\
#/etc/init.d/packet_steering disable\n\
#/etc/init.d/packet_steering stop\n\
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
#/etc/init.d/ttyd disable\n\
#/etc/init.d/ttyd stop\n\n\
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
" package/emortal/default-settings/files/99-default-settings
