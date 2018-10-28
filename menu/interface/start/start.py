#!/usr/bin/python
#
# GitHub:   https://github.com/Admin9705/PlexGuide.com-The-Awesome-Plex-Server
# Author:   Admin9705
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
# https://pypi.org/project/console-menu/

# Import for Menu Interface
from consolemenu import *
from consolemenu.format import *
from consolemenu.items import *

# Call Variables
with open('/var/plexguide/server.ports.status', 'r') as myfile:
    ports=myfile.read().replace('\n', '')

with open('/var/plexguide/pg.edition', 'r') as myfile:
    edition=myfile.read().replace('\n', '')

with open('/var/plexguide/server.id', 'r') as myfile:
    serverid=myfile.read().replace('\n', '')

with open('/var/plexguide/pg.number', 'r') as myfile:
    pgversion=myfile.read().replace('\n', '')

with open('/var/plexguide/server.domain', 'r') as myfile:
    domain=myfile.read().replace('\n', '')

with open('/var/plexguide/ansible.version', 'r') as myfile:
    ansible=myfile.read().replace('\n', '')

def main():
    # Change some menu formatting
    menu_format = MenuFormatBuilder().set_border_style_type(MenuBorderStyleType.HEAVY_BORDER)\
        .set_prompt("SELECT>")\
        .set_title_align('left')\
        .set_subtitle_align('left')\
        .set_left_margin(2)\
        .set_right_margin(2)\
        .show_header_bottom_border(True)

    menu = ConsoleMenu(edition + " - " + pgversion, "Server ID: " + serverid + " | Domain: " + domain + " | Ansible: " + ansible, formatter=menu_format)
    item1 = MenuItem("Item 1", menu)

    # A CommandItem runs a console command
    if edition == 'PG Edition - HD Solo':
        command_item1 = CommandItem("No Data & Transport System", 'cmd /c \"echo this is a shell. Press enter to continue." && set /p=\"')
    elif edition == 'PG Edition - HD Multi':
        command_item1 = CommandItem("Mounts & HD MergerFS", "bash /opt/plexguide/roles/menu-multi/scripts/main.sh")
    else:
        command_item1 = CommandItem("Mounts & Data Transport System", "bash /opt/plexguide/roles/menu-transport/scripts/main.sh")

    command_item2 = CommandItem("Traefik & TLD Deployment       ","bash /opt/plexguide/menu/interface/traefik/main.sh")
    command_item3 = CommandItem("Server Port Guard              " + ports,  "bash /opt/plexguide/roles/menu-ports/scripts/main.sh")
    command_item4 = CommandItem("Applicaiton Guard              ",  "bash /opt/plexguide/roles/menu-appguard/scripts/main.sh")
    command_item5 = CommandItem("Program Suite Installer", "bash /opt/plexguide/menu/interface/apps/main.sh")
    command_item6 = CommandItem("PG Tools & Services", "python3 /opt/plexguide/menu/interface/start/tools.py")
    command_item7 = CommandItem("Settings", "echo 'settings' > /var/plexguide/type.choice && bash /opt/plexguide/menu/core/scripts/main.sh")

    # Once we're done creating them, we just add the items to the menu
    menu.append_item(command_item1)
    menu.append_item(command_item2)
    menu.append_item(command_item3)
    menu.append_item(command_item4)
    menu.append_item(command_item5)
    menu.append_item(command_item6)
    menu.append_item(command_item7)
    # Finally, we call show to show the menu and allow the user to interact
    menu.show()

if __name__ == "__main__":
    main()
# When User Exits Menu; Displays PG Ending
rc = call("/opt/plexguide/roles/ending/ending.sh", shell=True)