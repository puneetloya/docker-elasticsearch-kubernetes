#!/bin/bash
exec &> /var/log/post_start.txt
POD_IP=$(hostname -i)
trial=0
num_retries=${INIT_NUM_RETRIES:-30}
until [ "$trial" -ge $num_retries ]
do
  # verify node is added to the cluster
  node_exists=$(curl -X GET "localhost:9200/_cat/nodes?format=json" | jq -e --arg POD_IP "$POD_IP" 'any( .[].ip ; . == $POD_IP )')
  if [[ "$node_exists" == "true" ]]; then
    break
  fi
  trial=$(( trial + 1 ))
  sleep 20
done
curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": null
  }
}'
