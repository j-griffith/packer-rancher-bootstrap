#!//bin/bash

cat <<EOF > /root/serve-rancher.sh
#!/bin/bash

docker run -d -p 80:80 -p 443:443 rancher/rancher
EOF

cat <<EOF > /etc/init.d/serve-rancher
#!/bin/bash
#
# Demonstrate creating your own init scripts
# chkconfig: 2345 92 65

### BEGIN INIT INFO
# Provides: Welcome
# Required-Start: $local_fs $all
# Required-Stop:
# Default-Start: 2345
# Default-Stop:
# Short-Description: Display a welcome message
# Description: Just display a message. Not much else.

### END INIT INFO
# Source function library.
. /etc/init.d/functions


##Service start/stop functions##
start() {
    echo "Starting up bootstrap Rancher Server"
    docker run -d -p 80:80 -p 443:443 rancher/rancher
    sleep 2
}

stop () {
    echo "Service shutting down"
    docker stop $(docker ps -aq)
    sleep 2
}

status () {
    echo "Everything looks good"
}

##case statement to be used to call functions##
case "$1" in
start)
start
;;
stop)
stop
;;
status)
status
;;
*)
echo $"Usage: $0 {start|stop|status}"
exit 5
esac
exit $?
EOF

chmod 755 /etc/init.d/serve-rancher
chown root:root /etc/init.d/serve-rancher

update-rc.d serve-rancher defaults
update-rc.d serve-rancher enable
