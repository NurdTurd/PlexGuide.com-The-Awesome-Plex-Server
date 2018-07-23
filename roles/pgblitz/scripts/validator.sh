#!/bin/bash
#
# [Ansible Role]
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705 & FlickerRate
# URL:      https://plexguide.com
#
# PlexGuide Copyright (C) 2018 PlexGuide.com
# Licensed under GNU General Public License v3.0 GPL-3 (in short)
#
#   You may copy, distribute and modify the software as long as you track
#   changes/dates in source files. Any modifications to our software
#   including (via compiler) GPL-licensed code must also be made available
#   under the GPL along with build & install instructions.
#
#################################################################################
echo "INFO - PGBlitz: Starting Valadiation Process" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

while read p; do
  echo $p > /tmp/pg.key.validator

echo "INFO - PGBlitz: Valadating $p" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh

rm -r /root/.config/rclone/rclone.tmp 1>/dev/null 2>&1

tee "/root/.config/rclone/rclone.tmp" > /dev/null <<EOF
[GDSA1]
type = drive
client_id =
client_secret =
scope = drive
root_folder_id =
service_account_file = /opt/appdata/pgblitz/keys/unprocessed/$p
team_drive =
EOF

mkdir -p /tmp/pgblitz
echo "" > /tmp/pgblitz/$p

rclone move --tpslimit 6 --checkers=20 \
  --config /root/.config/rclone/rclone.tmp \
  --transfers=8 \
  --log-file=/opt/appdata/pgblitz/rclone.log --log-level INFO --stats 10s \
  --exclude="**partial~" --exclude="**_HIDDEN~" \
  --exclude=".unionfs-fuse/**" --exclude=".unionfs/**" \
  --drive-chunk-size=32M \
  /tmp/pgblitz/$p $p:

rm -r touch /tmp/pgblitz/$p

done </tmp/pg.keys.temp

######################## REMOVE BELOW
sleep 10000

ls -la /opt/appdata/pgblitz/keys/unprocessed | awk '{ print $9}' | tail -n +4 > /tmp/pg.keys.temp

bash validator.sh

ls -la /opt/appdata/pgblitz/keys/processed | awk '{ print $9}' | tail -n +4 > /tmp/pg.keys.unprocessed.count

#rm -r /opt/appdata/pgblitz/keys/unprocessed/* 1>/dev/null 2>&1
rm -r /opt/appdata/pgblitz/keys/processed/* 1>/dev/null 2>&1
rm -r /opt/appdata/pgblitz/keys/originalnames/* 1>/dev/null 2>&1

rm -r /tmp/pg.keys.processed.count 1>/dev/null 2>&1
while read p; do
  p=${p:4}
  echo $p >> /tmp/pg.keys.processed.count
done </tmp/pg.keys.unprocessed.count

while read p; do
  let "number++"
  until [ "$break" == "1" ]; do
    check=$(grep -w "$number" /tmp/pg.keys.processed.counti)
    if [ "$check" == "$number" ]; then
        break=0
        let "number++"
        echo "INFO - PGBlitz: GDSA$number Exists - Skipping" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
      else
        break=1
    fi
  done

  mv /opt/appdata/pgblitz/keys/unprocessed/$p /opt/appdata/pgblitz/keys/processed/GDSA$number
  echo "/opt/appdata/pgblitz/keys/unprocessed/$p" > /opt/appdata/pgblitz/keys/originalname/GDSA$number
  echo "INFO - PGBlitz: GDSA$number Established" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh
done </tmp/pg.keys.temp

echo "INFO - PGBlitz: JSON Building Process List Complete" > /var/plexguide/pg.log && bash /opt/plexguide/roles/log/log.sh