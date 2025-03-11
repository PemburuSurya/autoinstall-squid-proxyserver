#!/bin/bash

# Update dan upgrade sistem
sudo apt update
sudo apt upgrade -y

# Instal Squid dan Apache2-utils untuk autentikasi
sudo apt install squid apache2-utils -y

# Aktifkan Squid
sudo systemctl enable squid

# Konfigurasi Squid
sudo bash -c 'cat > /etc/squid/squid.conf <<EOF
# Port yang akan digunakan oleh Squid
http_port 12323

# Sembunyikan informasi ISP
forwarded_for off
request_header_access Via deny all
request_header_access X-Forwarded-For deny all
reply_header_access Via deny all
via off
header_replace Via ""

# DNS
dns_nameservers 8.8.8.8 8.8.4.4

# Autentikasi
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated

# Default deny all other traffic
http_access allow all

# Cache configuration (opsional)
cache_dir ufs /var/spool/squid 100 16 256
cache_mem 256 MB
maximum_object_size 256 MB

# Logging
access_log /var/log/squid/access.log
cache_log /var/log/squid/cache.log
EOF'

# Buat password untuk autentikasi
echo "rumiyah123" | sudo htpasswd -c -i /etc/squid/passwords egan

# Ubah permission file password
sudo chmod 644 /etc/squid/passwords
sudo chown proxy:proxy /etc/squid/passwords

# Buat direktori cache Squid
sudo systemctl stop squid
sudo rm -f /run/squid.pid
sudo squid -z

# Konfigurasi IP publik Anda
IP_PUBLIC="IP_PUBLIC_ANDA"  # Ganti dengan IP publik Anda
sudo bash -c "cat > /etc/squid/conf.d/ip.conf <<EOF
http_port $IP_PUBLIC:12323
EOF"

# Buka port 12323 di firewall
sudo ufw allow 12323/tcp
sudo ufw reload

# Uji konfigurasi Squid
sudo squid -k parse

# Restart Squid
sudo systemctl restart squid

echo "Squid telah berhasil dikonfigurasi dengan IP publik: $IP_PUBLIC"
echo "Username: $IP_PUBLIC:12323"
echo "Username: egan"
echo "Password: rumiyah123"
