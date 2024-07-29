#!/bin/bash
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

cp -rf $GITHUB_WORKSPACE/diy/disable-eee/996-intel-igc-i225-i226-disable-eee.patch target/linux/x86/patches-6.6/
