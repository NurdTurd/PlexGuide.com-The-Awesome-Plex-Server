################# Install Plex
echo -n "Do you want to Install PlexDrive? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;
    clear

## Create the PlexDrive4 Service
tee "/etc/systemd/system/plexdrive4.service" > /dev/null <<EOF
## Create the PlexDrive4 Service
[Unit]
Description=PlexDrive4 Service
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/plexdrive4 --uid=0 --gid=0 --fuse-options=allow_other allow_non_empty_mount --refresh-interval=1m /mnt/plexdrive4
TimeoutStopSec=20
KillMode=process
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

## Enables the PlexDrive Service
systemctl daemon-reload
systemctl enable plexdrive4.service

    clear
    cd /tmp
    wget https://github.com/dweidenfeld/plexdrive/releases/download/4.0.0/plexdrive-linux-amd64
    mv plexdrive-linux-amd64 plexdrive4
    mv plexdrive4 /usr/bin/
    cd /usr/bin/
    chown root:root /usr/bin/plexdrive4
    chmod 755 /usr/bin/plexdrive4
    clear
    plexdrive4 --uid=0 --gid=0 -o allow_other nonempty -v 2 --refresh-interval=1m /mnt/plexdrive4
    clear
    ## USER Will Have To Reboot Once PlexDrive Is Finished!
else
    echo No
    clear
    echo Not Installed - PlexDrive
    echo
fi
