#!bin/bash
echo "Starting rsync to $REMOTE_HOST (maar nog niet echt)"

#rsync -rz -e "ssh -i /config/id_rsa.pub -p $REMOTE_PORT" --progress /source_data $REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH