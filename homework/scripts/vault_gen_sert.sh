#!/bin/bash

   # Обозначим переменные
   read login < /home/vagrant/scripts/2.txt
   key=/home/vagrant/scripts/keys.txt
   ssl_dir=/etc/nginx/ssl

   # Перейдем в папку в которую будет сформирован сертификат
   cd  /home/vagrant/scripts &&

   # Распечатем Vault c помощью 3 ключей из файла
   for h in $(cat $key)
       do
           vault operator unseal $h &> /dev/null
           sleep 1
   done &&

   # Авторизуемся в Vault
   vault login $login &> /dev/null &&

   # Сгенерируем сертификат сроком на 1 месяц
   vault write -format=json pki_int/issue/dev-net-server \
       common_name="vault.dev-net.local" \
       alt_names="vault.dev-net.local" \
       ttl="720h" > dev-net.local.crt &&

   # Сохраним сертификат в нужном формате
   cat dev-net.local.crt | jq -r .data.certificate > dev-net.local.pem &&
   cat dev-net.local.crt | jq -r .data.issuing_ca >> dev-net.local.pem &&
   cat dev-net.local.crt | jq -r .data.private_key > dev-net.local.key &&

   # Переместим файлы в дирректорию с ключами
   mv -f dev-net.local.pem dev-net.local.key $ssl_dir &&

   # Перезапустим nginx и запечатаем Vault
   systemctl restart nginx  &&
   vault operator seal &&
   echo "Смена ключей произведена"
