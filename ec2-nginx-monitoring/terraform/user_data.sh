#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y nginx
systemctl enable nginx
systemctl start nginx

cat <<'EOF' > /usr/local/bin/monitor.sh
${monitor_content}
EOF

chmod +x /usr/local/bin/monitor.sh
/usr/local/bin/monitor.sh > /var/www/html/report.txt 2>&1
chmod 644 /var/www/html/report.txt