#!/bin/sh

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
