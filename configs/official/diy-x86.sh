#!/bin/bash
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

#sing-box
cp -rf $GITHUB_WORKSPACE/diy/singbox/files/ package/openwrt-passwall-packages/sing-box/
sed -i '135,150d' package/openwrt-passwall-packages/sing-box/Makefile
cat << "EOF" >> package/openwrt-passwall-packages/sing-box/Makefile
define Package/sing-box/conffiles
/etc/config/sing-box
/etc/sing-box/
endef

define Package/sing-box/install
	$(call GoPackage/Package/Install/Bin,$(1))

	$(INSTALL_DIR) $(1)/etc/sing-box
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/release/config/config.json $(1)/etc/sing-box

	$(INSTALL_DIR) $(1)/etc/config/
	$(INSTALL_CONF) ./files/sing-box.conf $(1)/etc/config/sing-box
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) ./files/sing-box.init $(1)/etc/init.d/sing-box
endef

$(eval $(call GoBinPackage,sing-box))
$(eval $(call BuildPackage,sing-box))
EOF

# Update Go Version
rm -rf feeds/packages/lang/golang && git clone -b 22.x https://github.com/sbwml/packages_lang_golang feeds/packages/lang/golang

# Remove snapshot tags
sed -i 's,-SNAPSHOT,,g' include/version.mk
sed -i 's,-SNAPSHOT,,g' package/base-files/image-config.in
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION='Sil'/g" package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='OpenWrt-23.05 $(date +%Y-%m-%d) (by Sil)' /g" package/base-files/files/etc/openwrt_release
cp -f package/extra/banner/Sil  package/base-files/files/etc/banner

sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config

# dockerd去版本验证
#sed -i 's/^\s*$[(]call\sEnsureVendoredVersion/#&/' feeds/packages/utils/dockerd/Makefile

# Dnsmasq switch to 2.90 version
#sed -i "s/2.89/2.90/g" package/network/services/dnsmasq/Makefile
#sed -i "s/02bd230.*/8e50309bd837bfec9649a812e066c09b6988b73d749b7d293c06c57d46a109e4/g" package/network/services/dnsmasq/Makefile
#cp -f $GITHUB_WORKSPACE/diy/patches/200-ubus_dns.patch package/network/services/dnsmasq/patches/200-ubus_dns.patch

# Modify localtime
# sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm

# Change default config
#cp -f $GITHUB_WORKSPACE/diy/Makefile feeds/packages/lang/golang/golang/Makefile
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

# Add network interface
sed -i  "37a\\
uci add_list network.@device[0].ports='eth2'\n\
uci add_list network.@device[0].ports='eth3'
" package/extra/default-settings/files/99-default-settings-chinese

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
