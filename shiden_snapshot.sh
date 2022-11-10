#!/bin/bash

###### VARIABLES ###########################################################################################

#### chain vars #####
CHAIN_ID="shiden"
CHAIN_ID2="kusama"
SNAP_PATH="$HOME/shiden_snaps"
LOG_PATH="$HOME/shiden_snaps/snapshot_log.txt"
DATA_PATH="$HOME/.local/share/astar-collator/chains/shiden/db/full/"
DATA_PATH2="$HOME/.local/share/astar-collator/polkadot/chains/ksmcc3/db/full/"
SERVICE_NAME="shiden.service"
SHIDEN_RPC_ENDPOINT="http://localhost:29833"
KUSAMA_METRICS_ENDPOINT="https://localhost:38616/metrics"
SNAP_NAME=$(echo "${CHAIN_ID}_$(date '+%Y-%m-%d').tar")
SNAP_NAME2=$(echo "${CHAIN_ID2}_$(date '+%Y-%m-%d').tar")
OLD_SNAP=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID}.*tar")
OLD_SNAP2=$(ls ${SNAP_PATH} | egrep -o "${CHAIN_ID2}.*tar")
SHIDEN_BLOCK_HEIGHT=$(($(curl -sH "Content-Type:application/json;charset=utf-8" -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}' ${SHIDEN_RPC_ENDPOINT} | jq -r .result)))
KUSAMA_BLOCK_HEIGHT=$(curl -s ${KUSAMA_METRICS_ENDPOINT} | grep substrate_block_height{status=\"finalized\"\,chain=\"ksmcc3\"} | awk '{print $2}')

#### alerting vars ####
TOKEN=YYYYYYYYY:XXXXXXXX-Xxx_xXXXXXXXX
CHAT_ID=-10000000000
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
MESSAGE="${CHAIN_ID} snapshot has been created. Archive size is $(du -hs ${SNAP_PATH}/${SNAP_NAME} | cut -f1 -d$'\t').\nURL: https://snapshots.stakecraft.com/$SNAP_NAME"

############################################################################################################

### Functions ####
now_date() {
    echo -n $(TZ=":Europe/Rome" date '+%Y-%m-%d_%H:%M:%S')
}


log_this() {
    YEL='\033[1;33m' # yellow
    NC='\033[0m'     # No Color
    local logging="$@"
    printf "|$(now_date)| $logging\n" | tee -a ${LOG_PATH}
}

############################################################################################################

log_this "$CHAIN_ID block height is ${SHIDEN_BLOCK_HEIGHT} ${KUSAMA_BLOCK_HEIGHT}"

log_this "Stopping ${SERVICE_NAME}"
sudo systemctl stop ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

log_this "Creating new snapshot"
time tar cf ${HOME}/${SNAP_NAME} -C ${DATA_PATH} . &>>${LOG_PATH}
time tar cf ${HOME}/${SNAP_NAME2} -C ${DATA_PATH2} . &>>${LOG_PATH}

log_this "Starting ${SERVICE_NAME}"
sudo systemctl start ${SERVICE_NAME}; echo $? >> ${LOG_PATH}

log_this "Removing old snapshot(s):"
cd ${SNAP_PATH}
rm -fv ${OLD_SNAP} &>>${LOG_PATH}
rm -fv ${OLD_SNAP2} &>>${LOG_PATH}

log_this "Moving new snapshot to ${SNAP_PATH}"
mv ${HOME}/${CHAIN_ID}*tar ${SNAP_PATH} &>>${LOG_PATH}
mv ${HOME}/${CHAIN_ID2}*tar ${SNAP_PATH} &>>${LOG_PATH}

du -hs ${SNAP_PATH} | tee -a ${LOG_PATH}

log_this "Done\n---------------------------\n"

### inserting block_height and snapshot url into html file ###
sed -i -e "s/\(<div id=\"shiden\" class=\"number_shiden\">\).*\(<\/div>\)/<div id=\"shiden\" class=\"number\_shiden\">$SHIDEN_BLOCK_HEIGHT<\/div>/g" $HOME/astar_snaps/index.html
sed -i -e "s/\(<button data-id=\"astar\" data-link=\"\).*\(\" class=\"button\_astar w\-button\">\).*\(<\/button>\)/<button data-id=\"astar\" data-link=\"https:\/\/snapshots.stakecraft.com\/$SNAP_NAME\" class=\"button\_astar w\-button\">copy url<\/button>/g" $HOME/astar_snaps/index.html

### sending a message to telegram channel
curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$(echo -e $MESSAGE)"