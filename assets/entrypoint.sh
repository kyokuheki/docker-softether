#!/bin/sh
set -ex

if [ "x$1" = 'x/usr/vpnserver/vpnserver' ]; then

    # Linking Logs
    for d in server_log security_log packet_log;
    do
        if [ ! -L /usr/vpnserver/$d ]; then
          mkdir -p /var/log/vpnserver/$d
          ln -s /var/log/vpnserver/$d /usr/vpnserver/$d
        fi
    done

    # Allow app to use ports < 1024 without root
    #chown -R softether:softether /usr/vpnserver
    setcap 'cap_net_bind_service=+ep' /usr/vpnserver/vpnserver

    # Starting
    echo "Starting SoftEther VPN Server"
    exec "$@"
elif [ "x$1" = 'xvpncmd' ]; then
    exec /usr/vpnserver/vpncmd
elif [ "x$1" = 'xconfig' ]; then
    exec /usr/vpnserver/vpncmd localhost /server
elif [ "x$1" = 'xtools' ]; then
    exec /usr/vpnserver/vpncmd /tools
else
    exec "$@"
fi
