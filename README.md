# Skenain 
**Aplikasi e-commerce penyedia aksesoris dengan gaya alternatif sesuai style-mu!**

Skenain adalah platform *fullstack* belanja online yang dikhususkan untuk pencinta gaya skena dan alternatif. Aplikasi ini dibangun dengan performa tinggi menggunakan Flutter di sisi *frontend* dan Go (Golang) di sisi *backend*.

Nama dev : Dzidan rafi habibie
NIM      : 1123150045

---

## Demo Video

Lihat video demo aplikasi untuk melihat semua fitur dalam aksi!

[Watch Full Demo on YouTube](https://youtu.be/BlS11I7h-uY)

---

## Fitur Utama
- **Multi-Method Authentication**: Login aman menggunakan Google Sign-In atau Email/Password melalui Firebase.
- **Email Verification**: Menjaga keamanan akun dengan sistem verifikasi email otomatis.
- **Dynamic Product Catalog**: Tampilan produk berbasis *Grid* yang responsif.
- **Smart Filtering**: Mencari aksesoris berdasarkan kategori (Cincin, Kalung, dll) secara instan.
- **Product Detail**: Informasi lengkap produk termasuk deskripsi mendalam dan stok *real-time*.
- **Upcoming Features**: Keranjang Belanja, Tab Akun, dan Sistem Checkout Terintegrasi.

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
1. Buat database bernama `skenain`.
2. Masukkan file `serviceAccountKey.json` dari Firebase ke folder `config/`.
3. Buat file `.env` di root folder backend:
   ```env
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=root
   DB_PASS=
   DB_NAME=skenain_db
   FIREBASE_CREDENTIALS_PATH=config/serviceAccountKey.json
   PORT=8080
4. Download GoLang Backend di [repo ini](https://github.com/KishiEdward/skenain_backend.git)
5. Jalankan server
    ```go run main.go```

### 3. Konfigurasi Front-End
1. Buat file `.env`
2. Pastikan file `.env` sudah terdaftar di `pubspec.yaml`
3. Jalankan aplikasi `flutter run`

---

## 📁 Struktur Folder (Frontend)

```text
lib/
├── core/                       # Inti aplikasi yang dipakai secara global
│   ├── constants/              # Variabel konstan (API url, Warna, Teks)
│   ├── routes/                 # Konfigurasi perpindahan halaman (AuthGuard)
│   ├── services/               # Layanan pihak ketiga (Dio, Secure Storage)
│   └── theme/                  # Pengaturan tema global aplikasi
│
├── features/                   # Modul berdasarkan fitur aplikasi
│   ├── auth/                   # Fitur Autentikasi (Login, Register, Verifikasi)
│   │   ├── data/               # Model data dan komunikasi API
│   │   ├── domain/             # Aturan bisnis dan kontrak repository
│   │   └── presentation/       # Tampilan antarmuka
│   │       ├── pages/          # Halaman layar penuh (Screen)
│   │       ├── providers/      # State Management (Logika UI)
│   │       └── widgets/        # Komponen UI yang bisa dipakai ulang
│   │
│   └── dashboard/              # Fitur Katalog & Produk
│       ├── data/
│       ├── domain/
│       └── presentation/
│           ├── pages/          # Eksplor, Detail, Dashboard
│           ├── providers/
│           └── widgets/
│
├── firebase_options.dart       # Konfigurasi otomatis Firebase
└── main.dart                   # Titik masuk utama aplikasi (Entry point)