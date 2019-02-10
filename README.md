# rucenter-certbot-hooks
Создайте файл creds.txt в каталоге с хуками:

USERNAME=******/NIC-D # логин от учётки nic.ru

PASSWORD=******* # пароль от учётки nic.ru

CLIENTID=****

SECRET=****** # реквизиты к API, запросить можно по ссылке https://www.nic.ru/manager/oauth.cgi?step=oauth.app_register

DNSACCOUNT=DP****** # Логин от учётки DNS-хостинга Rucenter

TTL=120

Пример использования: 'certbot certonly --register-unsafely-without-email --manual --preferred-challenges=dns --manual-auth-hook ./auth-hook.sh --manual-cleanup-hook ./cleanup-hook.sh -d домен -d *.домен'.

Если вам нужен плагин для acme.sh, он есть здесь: https://bitbucket.org/mr-fedorich/dns_nic
