#!bin/bash
echo "Start copying data"

source 'check-input.sh'


FILE=/config/id_rsa.pub
if [ ! -f "$FILE" ]; then
    echo "Generating key"
    ssh-keygen -f /config/id_rsa.pub -b 2048 -t rsa -q -N ""
fi

#echo "Connecting to VPN server"
#source 'vpn-connect.sh'
#echo "Connected"

echo "Start copying data"
source 'copy-data.sh'
echo "Finished copying data"


#echo "Disconnecting from VPN server"
#source 'vpn-disconnect.sh'
#echo "Disconnected"

echo "Finished"