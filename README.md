# UangKu — Aplikasi Manajemen Keuangan Pribadi

UangKu adalah aplikasi pencatatan keuangan pribadi dengan multi-akun, kategori, dan tag. Proyek ini dibangun di atas Laravel 13 (Backend API & Web) dengan Inertia.js + Vue 3, serta Flutter 3.44.4 (Mobile App).

---

## 🛠️ Stack Teknis

- **Backend / Web**: Laravel 13.19.0 (PHP 8.3+) & MySQL 8.0.30
- **Web Frontend**: Inertia.js + Vue 3 (Composition API) & Tailwind CSS v4
- **Mobile Frontend**: Flutter 3.44.4 / Dart 3.12.2
- **Auth**: Laravel Sanctum (SPA Session Cookie untuk Web, Personal Access Token untuk Mobile)

---

## 🚀 Cara Menjalankan Secara Lokal

### 1. Prasyarat
Pastikan Anda memiliki tools berikut terpasang di sistem Anda:
- PHP >= 8.3
- Composer
- Node.js >= 18 & NPM
- MySQL 8.0.30
- Flutter SDK 3.44.4 & Dart SDK 3.12.2

---

### 2. Setup Backend & Web App

1. Klon repositori ini (jika belum).
2. Salin `.env.example` menjadi `.env` dan sesuaikan kredensial database Anda:
   ```bash
   cp .env.example .env
   ```
3. Pasang dependensi PHP:
   ```bash
   composer install
   ```
4. Generate application key:
   ```bash
   php artisan key:generate
   ```
5. Buat database kosong bernama `uangku-tes1` di MySQL Anda, lalu jalankan migrasi database:
   ```bash
   php artisan migrate
   ```
6. Pasang dependensi JavaScript (NPM):
   ```bash
   npm install
   ```
7. Jalankan server Laravel Development:
   ```bash
   php artisan serve
   ```
8. Jalankan server Vite Development untuk kompilasi Vue & Tailwind CSS:
   ```bash
   npm run dev
   ```
9. Buka browser dan akses `http://localhost:8000`. Halaman "UangKu — Setup Berhasil ✅" akan tampil.

---

### 3. Setup Mobile App (Flutter)

1. Masuk ke folder `mobile/`:
   ```bash
   cd mobile
   ```
2. Ambil dependensi Flutter:
   ```bash
   flutter pub get
   ```
3. Hubungkan emulator Android/iOS Anda.
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

---

## 🧪 Linting & Testing

### Backend & Web Linting
- **PHP Code Styling (Laravel Pint)**:
  ```bash
  ./vendor/bin/pint
  ```
- **JavaScript/Vue Linting (ESLint + Prettier)**:
  ```bash
  # Check for errors
  npm run lint
  
  # Auto-format files
  npm run format
  ```

### Mobile Linting
- **Dart Formatter & Analyzer**:
  ```bash
  cd mobile
  flutter format lib/
  flutter analyze
  ```

### Testing
- **Jalankan test suite**:
  ```bash
  php artisan test
  ```

> [!IMPORTANT]  
> **Catatan Pengujian Database (SQLite vs MySQL)**:
> - Test suite diatur menggunakan **SQLite `:memory:`** demi kecepatan dan kebersihan environment pengujian.
> - Karena fitur audit log memanfaatkan kolom tipe **JSON** (`audit_log.data_lama` / `audit_log.data_baru`) dan saldo berjalan menggunakan `lockForUpdate()` pada row level locking, pastikan untuk melakukan **verifikasi manual di database MySQL asli** untuk fungsionalitas tersebut, sebab SQLite memiliki keterbatasan kompatibilitas atas fitur-fitur tersebut.

