#!/bin/bash
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
#sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# Dnsmasq switch to 2.90 version
sed -i "s/2.89/2.90/g" package/network/services/dnsmasq/Makefile
sed -i "s/02bd230*/8e50309bd837bfec9649a812e066c09b6988b73d749b7d293c06c57d46a109e4/g" package/network/services/dnsmasq/Makefile
cp -f $GITHUB_WORKSPACE/diy/patches/200-ubus_dns.patch package/network/services/dnsmasq/patches/200-ubus_dns.patch
