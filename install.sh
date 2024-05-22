#!/bin/bash

sudo apt install openssl wget curl htop -y

wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib" | sudo tee /etc/apt/sources.list.d/virtualbox.list

sudo apt update && sudo apt upgrade -y && sudo apt install VirtualBox-7.0 -y

VB_VERSION=$(vboxmanage -v | cut -dr -f1)

wget https://download.virtualbox.org/virtualbox/$VB_VERSION/Oracle_VM_VirtualBox_Extension_Pack-$VB_VERSION.vbox-extpack

echo "y" | sudo vboxmanage extpack install Oracle_VM_VirtualBox_Extension_Pack-$VB_VERSION.vbox-extpack

sudo useradd -m -d /home/vbox -g vboxusers -s /bin/false -p $(openssl passwd -1 password) vbox

sudo touch /etc/default/virtualbox

sudo cat <<EOF>> /etc/default/virtualbox
VBOXWEB_USER=vbox 
VBOXWEB_PASSWD=password 
VBOXWEB_HOST=0.0.0.0 
VBOXWEB_TIMEOUT=0
EOF

sudo systemctl restart vboxweb-service
sudo systemctl status vboxweb-service


