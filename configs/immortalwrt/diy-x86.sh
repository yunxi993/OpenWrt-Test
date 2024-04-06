#!/bin/bash
#

# GCC CFlags
sed -i 's/Os/O2/g' include/target.mk
sed -i 's/O2 -pipe/O2 -pipe -march=x86-64-v2/g' include/target.mk

# Modify default IP
sed -i 's/192.168.1.1/192.168.1.13/g' package/base-files/files/bin/config_generate

# Hostname
sed -i 's/ImmortalWrt/N100/g' package/base-files/files/bin/config_generate

# Modify localtime
#sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S")/g' package/lean/autocore/files/x86/index.htm

# Add additional packages
rm -rf feeds/packages/net/xray-core
rm -rf feeds/packages/net/sing-box
git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages.git package/openwrt-passwall-packages
git clone --depth=1 https://github.com/yunxi993/openwrt-passwall2.git package/openwrt-passwall2
#git clone --depth=1 https://github.com/yunxi993/extra.git package/extra

# sing-box
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

# Add network interface
sed -i  "29a\\
uci del_list network.@device[0].ports='eth0'\n\
uci add_list network.@device[0].ports='eth1'\n\
uci add_list network.@device[0].ports='eth2'\n\
uci add_list network.@device[0].ports='eth3'\n\
uci set network.wan.device='eth0'\n\
uci set network.wan.proto='pppoe'\n\
uci del network.wan6\n\
uci commit network\n\
/etc/init.d/network restart\n\
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config\n\
" package/emortal/default-settings/files/99-default-settings-chinese

# Adjust default model name
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

# Default enable irqbalance
sed -i "s/enabled '0'/enabled '1'/g" feeds/packages/utils/irqbalance/files/irqbalance.config
