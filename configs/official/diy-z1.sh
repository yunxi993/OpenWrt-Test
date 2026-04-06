#!/bin/bash
#

# Add EEE Patches
ls -d target/linux/x86/patches-*/ | xargs -I {} cp -rf "$GITHUB_WORKSPACE/diy/disable-eee/996-intel-igc-i225-i226-disable-eee.patch" "{}"
find target/linux/x86/patches-*/ -name "996-intel-igc-i225-i226-disable-eee.patch" 2>/dev/null

# Add BBR Patches 6.12
ls -d target/linux/generic/backport-6.12/ | xargs -I {} sh -c "cp -rf $GITHUB_WORKSPACE/diy/bbr3/* {}"
find target/linux/generic/backport-6.12/ -iname "*bbr*" 2>/dev/null

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
