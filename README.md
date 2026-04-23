# Skenain 
**Aplikasi e-commerce penyedia aksesoris dengan gaya alternatif sesuai style-mu!**

Skenain adalah platform *fullstack* belanja online yang dikhususkan untuk pencinta gaya skena dan alternatif. Aplikasi ini dibangun dengan performa tinggi menggunakan Flutter di sisi *frontend* dan Go (Golang) di sisi *backend*.

---

## ✨ Fitur Utama
- **Multi-Method Authentication**: Login aman menggunakan Google Sign-In atau Email/Password melalui Firebase.
- **Email Verification**: Menjaga keamanan akun dengan sistem verifikasi email otomatis.
- **Dynamic Product Catalog**: Tampilan produk berbasis *Grid* yang responsif.
- **Smart Filtering**: Mencari aksesoris berdasarkan kategori (Cincin, Kalung, dll) secara instan.
- **Product Detail**: Informasi lengkap produk termasuk deskripsi mendalam dan stok *real-time*.
- **Upcoming Features**: 🛒 Keranjang Belanja, Tab Akun, dan Sistem Checkout Terintegrasi.

---

## Stack Teknologi

### Frontend
- **Framework**: Flutter 3.85.5
- **State Management**: Provider
- **Networking**: Dio
- **Storage**: Flutter Secure Storage
- **Environment**: Flutter Dotenv

### Backend
- **Language**: Go 1.26.1
- **Framework**: Gin Gonic
- **Database**: MySQL with GORM (Object Relational Mapping)
- **Auth SDK**: Firebase Admin SDK

---

## Persiapan & Instalasi

### 1. Prasyarat
Pastikan sudah terpasang:
- Flutter 3.85.5
- Go 1.26.1
- MySQL Server (Laragon/XAMPP)

### 2. Konfigurasi Backend (Go)
1. Buat database bernama `skenain_db`.
2. Masukkan file `serviceAccountKey.json` dari Firebase ke folder `config/`.
3. Buat file `.env` di root folder backend:
   ```env
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=root
   DB_PASS=
   DB_NAME=skenain_db
   FIREBASE_CREDENTIALS_PATH=config/serviceAccountKey.json
   PORT=8080 ```
4. Jalankan server
    ```go run main.go```

### 3. Konfigurasi Front-End
1. Buat file `.env`
2. Pastikan file `.env` sudah terdaftar di `pubspec.yaml`
3. Jalankan aplikasi `flutter run`