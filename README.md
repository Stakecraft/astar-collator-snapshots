# Astar-collator-snapshots

Pruned database snapshot service for Astar Network collators

Our snapshots are more suatable for collators node rather than RPC nodes because pruning 1000 is set.

You have to follow the plan below to configure your own snapshot service:
1) Install necessary packages
2) Install astar node
3) Create snapshot path
4) Configure astar service, you can an example in astar.service
5) Edit astar_snapshot.sh variables section to change with your data
6) Set a crobjob


## Install packages

As a part of preparation of snapshot service, you'll have to preinstall necessary linux packages:

    `sudo apt-get update && sudo apt-get install jq tar -y`


## Install astar node

You have to install latest astar node release by next command: 

    `wget $(curl -s https://api.github.com/repos/AstarNetwork/Astar/releases/latest | grep "tag_name" | awk '{print "https://github.com/AstarNetwork/Astar/releases/download/" substr($2, 2, length($2)-3) "/astar-collator-v" substr($2, 3, length($2)-4) "-ubuntu-x86_64.tar.gz"}') && tar -xvf astar-collator*.tar.gz && sudo cp astar-collator*/astar-collator /usr/local/bin/astar-collator`

## Create snapshot path

Make sure snapshot directory `$HOME/astar-snaps` is present, otherwise create this directory by next command: `mkdir -p $HOME/astar-snaps`

## Service file

Most important flags are:
- `--pruning` parameter is set to 1000, which will save you some disk space.
- `--rpc-port` is required by the snapshot script, that's how astar block height will be detected.
- `--prometheus-port` is required by the snapshot script, that's how polkadot block height will be detected.


## Snapshot script configuration

You will find 2 types of variables that can be adjusted.
* Chain varibables - variables related to node configs. Some of these variables should/could be adjusted as you like:
  * SNAP_PATH - snapshot directory path
  * LOG_PATH - snapshot logs path
  * DATA_PATH - astar database path
  * DATA_PATH2 - polkadot database path
  * ASTAR_RPC_ENDPOINT - astar local rpc endpont url
  * POLKADOT_METRICS_ENDPOINT - polkadot metrics endport url
* Alerting variables - telegram alerting configuration:
  * TOKEN - telegram bot token
  * CHAT_ID - telegram chat for alerts
  * MESSAGE - telegram message, can be changes as you need


## Cron configuration

Crontab should configured for overnight snapshot generation. 
Usually it is happening at 3:00AM UTC in our case. An example of a cronjob is 

    `00 3 * * * /bin/bash -c '/home/snapshot/astar-snaps/astar_snapshot.sh'`.



# Shiden-collator-snapshots

Pruned database snapshot service for Shiden Network collators

Our snapshots are more suatable for collators node rather than RPC nodes because pruning 1000 is set.

You have to follow the plan below to configure your own snapshot service:
1) Install necessary packages
2) Install shiden node
3) Create snapshot path
4) Configure shiden service, you can an example in shiden.service
5) Edit shiden_snapshot.sh variables section to change with your data
6) Set a crobjob


## Install packages

As a part of preparation of snapshot service, you'll have to preinstall necessary linux packages:

    `sudo apt-get update && sudo apt-get install jq tar -y`


## Install shiden node

You have to install latest shiden node release by next command: 

    `wget $(curl -s https://api.github.com/repos/AstarNetwork/Astar/releases/latest | grep "tag_name" | awk '{print "https://github.com/AstarNetwork/Astar/releases/download/" substr($2, 2, length($2)-3) "/astar-collator-v" substr($2, 3, length($2)-4) "-ubuntu-x86_64.tar.gz"}') && tar -xvf astar-collator*.tar.gz && sudo cp astar-collator*/astar-collator /usr/local/bin/astar-collator`

## Create snapshot path

Make sure snapshot directory `$HOME/shiden-snaps` is present, otherwise create this directory by next command: `mkdir -p $HOME/shiden-snaps`

## Service file

Most important flags are:
- `--pruning` parameter is set to 1000, which will save you some disk space.
- `--rpc-port` is required by the snapshot script, that's how shiden block height will be detected.
- `--prometheus-port` is required by the snapshot script, that's how polkadot block height will be detected.


## Snapshot script configuration

You will find 2 types of variables that can be adjusted.
* Chain varibables - variables related to node configs. Some of these variables should/could be adjusted as you like:
  * SNAP_PATH - snapshot directory path
  * LOG_PATH - snapshot logs path
  * DATA_PATH - shiden database path
  * DATA_PATH2 - polkadot database path
  * SHIDEN_RPC_ENDPOINT - shiden local rpc endpont url
  * KUSAMA_METRICS_ENDPOINT - polkadot metrics endport url
* Alerting variables - telegram alerting configuration:
  * TOKEN - telegram bot token
  * CHAT_ID - telegram chat for alerts
  * MESSAGE - telegram message, can be changes as you need


## Cron configuration

Crontab should configured for overnight snapshot generation. 
Usually it is happening at 3:00AM UTC in our case. An example of a cronjob is 

    `00 3 * * * /bin/bash -c '/home/snapshot/shiden-snaps/shiden_snapshot.sh'`.