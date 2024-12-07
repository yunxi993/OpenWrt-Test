#!/bin/bash
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default


#rm -rf target/linux/x86/config-6.6
#cp -f $GITHUB_WORKSPACE/diy/config-6.6 target/linux/x86/
#cat target/linux/x86/config-6.6

#sed -i 's,LINUX_VERSION-6.6 = .54,LINUX_VERSION-6.6 = .52,g' include/kernel-6.6
#sed -i 's,6.6.54 = 5fae86.*,6.6.52 = 1591ab348399d4aa53121158525056a69c8cf0fe0e90935b0095e9a58e37b4b8,g' include/kernel-6.6
#sed -i 's,6.6.54 = ^5fae86.*,6.6.52 = 1591ab348399d4aa53121158525056a69c8cf0fe0e90935b0095e9a58e37b4b8,g' include/kernel-6.6
#cat include/kernel-6.6

#ls target/linux/generic/hack-6.6/

#find target/linux/generic/hack-6.6/ -name "600-net-enable-fraglist-GRO-by-default.patch"

#test -e target/linux/generic/hack-6.6/600-net-enable-fraglist-GRO-by-default.patch && echo "File exists" || echo "File deleted"

#stat target/linux/generic/hack-6.6/600-net-enable-fraglist-GRO-by-default.patch

cp -f $GITHUB_WORKSPACE/diy/disable-eee/996-intel-igc-i225-i226-disable-eee.patch target/linux/x86/patches-6.6/
find target/linux/x86/patches-6.6/ -name "996-intel-igc-i225-i226-disable-eee.patch"
