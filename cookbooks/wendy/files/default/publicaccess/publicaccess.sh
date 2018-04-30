#!/bin/bash -x

publicaccess_apps="Samba AFP NFS"
publicaccess_services="smbd netatalk nfs-server"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

process_apps () {
    for app in ${publicaccess_apps}; do
        if [ "$1" = "insert" ]; then
            ufw allow ${app}
        elif [ "$1" = "delete" ]; then
            ufw delete allow ${app}
        fi
    done
    for service in ${publicaccess_services}; do
        if [ "$1" = "insert" ]; then
            systemctl start ${service}
        elif [ "$1" = "delete" ]; then
            systemctl stop ${service}
        fi
    done
}

if [ "$1" = "deny" ]; then
    process_apps delete
    # if [ -e "$2" ]; then
    #     rm "$2"
    # fi
else
    if [ -z "$1" ]; then
        minutes=30
    else
        minutes="$1"
    fi
    process_apps insert
    echo "$0 deny > /tmp/publicaccess.sh.log 2>&1" | at now + ${minutes} minutes
    echo "Public access granted for $minutes minutes"
fi
