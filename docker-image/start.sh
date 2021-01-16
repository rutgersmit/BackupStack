#!bin/bash
echo "Start copying data"

echo "Connecting to VPN server"
source 'vpn-connect.sh'
echo "Connected"


echo "Copying data"
source 'vpn-connect.sh'
echo "Finished copying data"


echo "Disconnecting from VPN server"
source 'vpn-disconnect.sh'
echo "Disconnected"

echo "Finished copying data"