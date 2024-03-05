#!/bin/sh

echo '# Put your custom commands here that should be executed once
# the system init finished. By default this file does nothing.

grep "Default string" /tmp/sysinfo/model >> /dev/null
if [ $? -ne 0 ];then
    echo should be fine
else
    echo "Generic_x86" > /tmp/sysinfo/model
fi

sleep 60
nft flowtable inet fw4 ft-bridges { hook ingress priority filter\; devices = { pppoe-wan, br-lan }\;}
nft insert rule inet fw4 forward meta l4proto { tcp, udp } flow add @ft-bridges

exit 0
'> ./package/base-files/files/etc/rc.local
