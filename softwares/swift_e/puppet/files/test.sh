#!/bin/bash

key=$1
account="system"
username="root"
password="testpass"

swauth-prep -K $key -A https://127.0.0.1:8080/auth/
swauth-add-user -K $key -A https://127.0.0.1:8080/auth/ -a $account $username $password

cd /tmp/swift

apt-get install curl -y

curl -k -v -H "X-Storage-User: $account:$username" -H "X-Storage-Pass: $password" https://127.0.0.1:8080/auth/v1.0 > temp 2>&1
url=`cat temp | grep "X-Storage-Url:" | sed -e "s/.*X-Storage-Url:\s*\(.*\)/\1/"`
token=`cat temp | grep "X-Storage-Token:" | sed -e "s/.*X-Storage-Token:\s*\(.*\)/\1/"`
echo "URL: $url"
echo "TOKEN: $token"

curl -k -v -H "X-Auth-Token: $token" $url

swift -A https://127.0.0.1:8080/auth/v1.0 -U $account:$username -K $password stat
echo "hello world" > testfile
swift -A https://127.0.0.1:8080/auth/v1.0 -U $account:$username -K $password upload myfiles testfile

echo ""
echo "The output of swift list:"
swift -A https://127.0.0.1:8080/auth/v1.0 -U $account:$username -K $password list

echo ""
echo "Download:"
swift -A https://127.0.0.1:8080/auth/v1.0 -U $account:$username -K $password download myfiles testfile -o testfile_downloaded


echo ""
echo "The content of file downloaded:"
cat testfile_downloaded

if [ $? -ne 0 ]; then
    echo "Test failed."
    exit 1
fi

echo "Test finished. It is OK."
