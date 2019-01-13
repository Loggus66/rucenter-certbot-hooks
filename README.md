# rucenter-certbot-hooks
Create a file creds.txt in the folder and populate it with following variables:

USERNAME=******/NIC-D # nic.ru username

PASSWORD=******* # nic.ru password

CLIENTID=****

SECRET=****** # API login and password, can be acquired at https://www.nic.ru/manager/oauth.cgi?step=oauth.app_register

DNSACCOUNT=DP****** # DNS-master account ID

ZONE=******.ru # FQDN

TTL=120

Usage is as easy as 'certbot certonly --register-unsafely-without-email --manual --preferred-challenges=dns --manual-auth-hook ./auth-hook.sh --manual-cleanup-hook ./cleanup-hook.sh -d domain -d *.domain'.
