#!/bin/bash

cat  > index.html <<EOF

echo "my public ip is `hostname`"
EOF

nohup busybox httpd -f -p ${server_port} &
