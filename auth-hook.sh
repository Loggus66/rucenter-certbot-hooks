#!/bin/bash

source $(dirname "$0")/creds.txt
ZONE=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')

# match gives empty output for second level domains
if [ -z "$ZONE" ];
then ZONE=$CERTBOT_DOMAIN;
fi

#get token for all methods
TOKEN=$(curl -s -X POST 'https://api.nic.ru/oauth/token' \
-H 'Content-Type: application/x-www-form-urlencoded' \
-d "grant_type=password&username=$USERNAME&password=$PASSWORD&scope=.%2B%3A%2Fdns-master%2Fservices%2F$DNSACCOUNT%2Fzones%2F$ZONE(%2F.%2B)%3F&client_id=$CLIENTID&client_secret=$SECRET" \
| tr '"' ' ' | awk '{print $8}')
echo $TOKEN | tee /tmp/.$ZONE-token

# add _acme-challenge TXT record
curl -s -X PUT "https://api.nic.ru/dns-master/services/$DNSACCOUNT/zones/$ZONE/records" \
-H "Authorization: Bearer $TOKEN" \
-d "
<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<request>
 <rr-list>
  <rr>
   <name>_acme-challenge.$CERTBOT_DOMAIN.</name>
   <ttl>$TTL</ttl>
   <type>TXT</type>
   <txt>
   <string>$CERTBOT_VALIDATION</string>
   </txt>
  </rr>
 </rr-list>
</request>
"
# commit zone records
curl -s -X POST "https://api.nic.ru/dns-master/services/$DNSACCOUNT/zones/$ZONE/commit" \
-H "Authorization: Bearer $TOKEN"

# sleep for the $TTL period of time plus a tad more, so certbot won't go checking records when they aren't there yet
sleep $TTL
sleep 20

