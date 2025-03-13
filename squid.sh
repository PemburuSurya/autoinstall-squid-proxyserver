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
request_header_access X-Forwarded-For deny all
request_header_access Via deny all
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

# Mendapatkan IP public secara otomatis
IP_PUBLIC=$(curl -s ipinfo.io/ip)

# Menambahkan IP public ke file konfigurasi Squid
sudo bash -c "cat > /etc/squid/conf.d/ip1.conf <<EOF
http_port $IP_PUBLIC:12323
EOF"

# Menampilkan pesan sukses
echo "File /etc/squid/conf.d/ip1.conf telah diperbarui dengan IP publik: $IP_PUBLIC"

# Buka port 12323 di firewall
sudo ufw allow 12323/tcp
sudo ufw reload

# Uji konfigurasi Squid
sudo squid -k parse

# Restart Squid
sudo systemctl restart squid

# Output completion message with separators and blue color
echo -e "${BLUE}/////////////////////////////////////////////////////////////////////////////${RESET}"
echo -e "${BLUE}Squid telah berhasil dikonfigurasi${RESET}"
echo -e "${BLUE}Akses Proxy melalui${RESET}"
echo -e "${BLUE}(curl -s ipinfo.io/ip):12323${RESET}"
echo -e "${BLUE}Username: egan${RESET}"
echo -e "${BLUE}Password: rumiyah123${RESET}"
echo -e "${BLUE}/////////////////////////////////////////////////////////////////////////////${RESET}"
