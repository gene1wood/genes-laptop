#!/bin/bash

#############################################################
# Linux Client UnInstaller Script
#############################################################

# variables defined in install.defaults
# APP_BASENAME = human-readable application name
# DIR_BASENAME = dir name
# DOWNLOAD_HOST = where to get the jre

SCRIPT_DIR=`dirname $0`
if [ ! -f "${SCRIPT_DIR}/install.defaults" ] ; then
    echo "${SCRIPT_DIR}/install.defaults MISSING!"
    exit 1
fi

. "$SCRIPT_DIR/install.defaults"

REQDBINS="grep sed cpio gzip cut head tail who"

TARGETDIR="/usr/local/$DIR_BASENAME"
BINSDIR=/usr/local/bin
MANIFESTDIR="/usr/local/var/$DIR_BASENAME"
INITDIR=/etc/init.d
RUNLEVEL=`who -r | sed -e 's/^.*\(run-level [0-9]\).*$/\1/' | cut -d \  -f 2`
RUNLVLDIR=/etc/rc${RUNLEVEL}.d

SRC_USER=$SUDO_USER
if [[ -z $SRC_USER ]]; then
    SRC_USER=$USER
fi

USERNAME="`id -un`"

# A quiet install causes some messages not to print; used when calling this script again w/sudo
QUIET=1

# Location where the client is installed; must be provided
INSTALLDIR=""

while getopts "qi:" OPT; do
  case $OPT in
    q)
      QUIET=0
      ;;
    i)
      INSTALLDIR="$OPTARG"
      ;;
    ?)
      echo "Usage: uninstall.sh <-q> -i installation_dir"
      exit 1
      ;;
  esac
done

_cleanAppSupport() {
    appSupportFolder="$1"
    # Leave non-empty backupArchives or PROServer folders.
    for file in `ls -A "$appSupportFolder"`; do
        deleteFile=true
        if [ "manifest" == "$file" ] || [ "backupArchives" == "$file" ]; then
            # If folder has data, do not delete it
            if [ 0 -lt `ls -lA "$appSupportFolder/$file" | wc -l` ]; then
                deleteFile=false
            fi
        fi
        if [ "true" = "$deleteFile" ]; then
            rm -Rfv "$appSupportFolder/$file"
        fi
    done
    # If our AppSupp folder is empty, we can delete it outright
    if [ 0 -eq `ls -lA "$appSupportFolder" | wc -l` ]; then
        rm -Rfv "$appSupportFolder"
    fi
}

# required installation directory parameter
if [[ -z "$INSTALLDIR" ]] ; then
    echo ""
    echo "Usage: uninstall.sh <-q> -i installation_dir"
    echo ""
    echo "Please specify where $APP_BASENAME was installed."
    exit 1
fi

# check for the install.vars file
if [[ ! -f "$INSTALLDIR/install.vars" ]] ; then
    echo ""
    echo "$APP_BASENAME was not found at $INSTALLDIR.  Please specify where $APP_BASENAME was installed."
    exit 1
fi

if [[ ! $QUIET ]] ; then
    echo ""
    echo "$APP_BASENAME Uninstaller."
    echo ""
    echo -n "Press enter to continue. "
    read ENTER
fi

# required binaries
for BIN in $REQDBINS ; do

    BIN_PATH=`which $BIN 2> /dev/null`
    if [[ $? != 0 ]]; then
        echo "ERROR: $BIN not found and is required for uninstall. Exiting"
        exit 1
    fi
done

# check for root permissions
if [[ $USERNAME != "root" ]]; then
    echo ""
    echo "NOTE: You are apparently not uninstalling as root. If $APP_BASENAME"
    echo "was installed as root you will need root permissions to clean up"
    echo "all of the $APP_BASENAME files."
    echo ""
    echo -n "Would you like to switch users and uninstall as root? (y/n) [y] "
    read YN
    if [[ -z $YN ]]; then
        YN="y"
    fi
    
    if [[ $YN == "y" ]]; then
        echo "  switching to root"
        sudo $0 -q -i "$INSTALLDIR"
        exit 0
    else
        echo "  uninstalling as $USERNAME"
        
        TARGETDIR="$HOME/$DIR_BASENAME"
        BINSDIR=
        MANIFESTDIR="$HOME/$DIR_BASENAME/manifest"
        INITDIR=
        RUNLVLDIR=
    fi
else
    echo "  detected root permissions"
fi

echo ""
echo "============================================================================"
echo "Software Removal - WARNING WARNING WARNING" 
echo "============================================================================"
echo "This portion of the uninstall will remove ${APP_BASENAME} software and configuration"
echo "information.  Backup archives will not be touched.  Automatic backup will cease."
echo ""
echo -n "Are you sure you wish to continue? (yes/no) [no] "
read YN
if [[ $YN == "yes" ]]; then
    echo "Uninstalling ${APP_BASENAME} ... "
    . "$INSTALLDIR/install.vars"
    if [[ -z "$TARGETDIR" ]]; then
        echo "ERROR: Conf file not loaded correctly."
        exit 1
    fi
    HERE=`pwd`
    cd "$TARGETDIR"
    "$TARGETDIR/bin/${APP_BASENAME}Engine" stop
    if [[ -n $BINSDIR ]]; then
        rm -f "$RUNLVLDIR/S99${DIR_BASENAME}"
        rm -f "$INITDIR/${DIR_BASENAME}"        
        rm -f "$BINSDIR/${APP_BASENAME}Desktop"
    fi
    cd ${HERE}
    _cleanAppSupport "${TARGETDIR}"
    
    # check for the desktop launcher and take that too
    if [[ -f "/home/$SRC_USER/Desktop/${APP_BASENAME}.desktop" ]]; then
        rm -rf "/home/$SRC_USER/Desktop/${APP_BASENAME}.desktop"
    fi
    
    # strip out the keys
    user="false"
    identityFile="/var/lib/${DIR_BASENAME}/.identity"
    if [[ ! -f "$identityFile" ]]; then
      identityFile="/home/${SRC_USER}/.${DIR_BASENAME}/.identity"
      user="true"
    fi
    if [ -f "$identityFile" ] ; then
        sed -e '/dataKey/ d' -e '/secureDataKey/ d' -e '/privateKey/ d' -e '/publicKey/ d' -e '/securityKeyType/ d' -e '/offlinePasswordHash/ d' "$identityFile" > "${identityFile}.tmp"
        mv "${identityFile}.tmp" "$identityFile"
        chmod 600 "$identityFile"
        if [ "${user}" == "true" ] ; then
            chown ${SRC_USER}:${SRC_USER} ${identityFile}
        fi
    fi
    
    echo "${APP_BASENAME} uninstalled."
    
    echo ""
    echo ""
    echo "The backup data was NOT removed.  It is located in ${MANIFESTDIR}."
    echo "If you reinstall ${APP_BASENAME}, you will need to note that as the location"
    echo "where you would like to store your backups if you wish to start where"
    echo "you left off."
else
    echo "Your choice, ${YN}, was not recognized as yes."
    echo "CrashPlan was not uninstalled."
fi

