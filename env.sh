#!/bin/sh

for i in $(env | grep APP_)
do
    key=$(echo $i | cut -d '=' -f 1)
    value=$(echo $i | cut -d '=' -f 2-)

    find /usr/share/nginx/html -type f -name 'index.html' -exec sed -i "s|${key}=null|${key}=\"${value}\"|g" '{}' +
done
