#!/bin/bash
#

# Add EEE Patches
ls -d target/linux/x86/patches-*/ | xargs -I {} cp -rf "$GITHUB_WORKSPACE/diy/disable-eee/996-intel-igc-i225-i226-disable-eee.patch" "{}"
find target/linux/x86/patches-*/ -name "996-intel-igc-i225-i226-disable-eee.patch" 2>/dev/null

echo "::group::Print 6.12 kernelBBR patch info..."
if [ -d "target/linux/generic/backport-6.12/" ]; then
    echo "检测到 6.12 内核目录，正在应用 BBR3 补丁..."
    cp -rf "$GITHUB_WORKSPACE/diy/bbr3/"* target/linux/generic/backport-6.12/
    find target/linux/generic/backport-6.12/ -iname "*-00*" 2>/dev/null
else
    echo "跳过 6.12 内核补丁（目录不存在）"
fi
echo "::endgroup::"

echo "::group::Print 6.18 kernelBBR patch info..."
if [ -d "target/linux/generic/backport-6.18/" ]; then
    echo "检测到 6.18 内核目录，正在应用 BBR6.18 补丁..."
    cp -rf "$GITHUB_WORKSPACE/diy/bbr6.18/"* target/linux/generic/backport-6.18/
    find target/linux/generic/backport-6.18/ -iname "*bbr3*" 2>/dev/null
else
    echo "跳过 6.18 内核补丁（目录不存在）"
fi
echo "::endgroup::"

# Add BBR Patches 6.12.x
#ls -d target/linux/generic/backport-6.12/ | xargs -I {} sh -c "cp -rf $GITHUB_WORKSPACE/diy/bbr3/* {}"
#find target/linux/generic/backport-6.12/ -iname "*-00*" 2>/dev/null

# Add BBR Patches 6.18.x
#ls -d target/linux/generic/backport-6.18/ | xargs -I {} sh -c "cp -rf $GITHUB_WORKSPACE/diy/bbr6.18/* {}"
#find target/linux/generic/backport-6.18/ -iname "*bbr3*" 2>/dev/null

# PPPoE RPS
#ls -d package/network/config/netifd/files/etc/hotplug.d/iface/ | xargs -I {} cp -rf "$GITHUB_WORKSPACE/diy/pppoe-rps/99-pppoe-rps" "{}"
#find package/network/config/netifd/files/etc/hotplug.d/iface/ -name "99-pppoe-rps" 2>/dev/null

#find target/linux/x86/patches-6.12/ -name "996-intel-igc-i225-i226-disable-eee.patch"
#find target/linux/x86/patches-6.18/ -name "996-intel-igc-i225-i226-disable-eee.patch"
#cp -f $GITHUB_WORKSPACE/diy/disable-eee/996-intel-igc-i225-i226-disable-eee.patch target/linux/x86/patches-6.12/
#cp -f $GITHUB_WORKSPACE/diy/disable-eee/996-intel-igc-i225-i226-disable-eee.patch target/linux/x86/patches-6.18/

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

#ls target/linux/generic/hack-6.6/

#find target/linux/generic/hack-6.6/ -name "600-net-enable-fraglist-GRO-by-default.patch"

#test -e target/linux/generic/hack-6.6/600-net-enable-fraglist-GRO-by-default.patch && echo "File exists" || echo "File deleted"

#stat target/linux/generic/hack-6.6/600-net-enable-fraglist-GRO-by-default.patch
