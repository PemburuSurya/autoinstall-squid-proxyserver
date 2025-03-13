# Auto Install Squid Proxy Server

Skrip ini digunakan untuk menginstal dan mengonfigurasi Squid Proxy Server secara otomatis di sistem Linux. Skrip ini cocok untuk pengguna yang ingin menyiapkan proxy server dengan cepat.

---

## **Fitur**
- Menginstal Squid dan dependensi yang diperlukan.
- Mengonfigurasi Squid dengan pengaturan dasar.
- Membuka port proxy di firewall (jika `ufw` terinstal).
- Menyiapkan autentikasi pengguna.
- Menjalankan Squid secara otomatis setelah instalasi.

---

## **Cara Menggunakan**

1. **Clone Repositori ini dan Jalankan Skrip:**
   Salin dan jalankan perintah berikut di terminal Anda:
   ```bash
   curl -s https://raw.githubusercontent.com/PemburuSurya/autoinstall-squid-proxyserver/main/squid.sh -o squid.sh && chmod +x squid.sh && sudo ./squid.sh
