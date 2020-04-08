#!/bin/bash
exec &> /var/log/pre_stop.txt
curl -X PUT "localhost:9200/_cluster/settings?pretty" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "primaries"
  }
}'
curl -X POST "localhost:9200/_flush/synced?pretty"
