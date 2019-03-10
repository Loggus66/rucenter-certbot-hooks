#!/bin/bash

source $(dirname "$0")/creds.txt
ZONE=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')

# match gives empty output for second level domains
if [ -z "$ZONE" ];
then ZONE=$CERTBOT_DOMAIN;
fi

test -f /tmp/.$ZONE-token || exit 0 
TOKEN=$(cat /tmp/.$ZONE-token)
# grep all existing TXT _acme-challenge record IDs and delete them
curl -s "https://api.nic.ru/dns-master/services/$DNSACCOUNT/zones/$ZONE/records" \
-H "Authorization: Bearer $TOKEN" \
| grep _acme-challenge | grep TXT | tr '"' ' ' | tr '>' ' ' | tr '<' ' ' | awk '{print $3}'| \
while read rrid
do
echo $rrid
curl -s -X DELETE "https://api.nic.ru/dns-master/services/$DNSACCOUNT/zones/$ZONE/records/$rrid" \
-H "Authorization: Bearer $TOKEN" 
done

# commit zone
curl -s -X POST "https://api.nic.ru/dns-master/services/$DNSACCOUNT/zones/$ZONE/commit" \
-H "Authorization: Bearer $TOKEN"

# remove token
test -f /tmp/.$ZONE-token && rm -f /tmp/.$ZONE-token


