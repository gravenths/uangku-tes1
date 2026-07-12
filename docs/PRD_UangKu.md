# Product Requirements Document (PRD)
# UangKu — Aplikasi Manajemen Keuangan Pribadi (Web & Mobile)

| | |
|---|---|
| **Versi Dokumen** | 1.2 |
| **Status** | Draft untuk direview |
| **Stack Teknis** | Laravel 13.19.0 · MySQL 8.0.30 · Flutter 3.44.4 / Dart 3.12.2 |
| **Frontend Web** | Laravel + Inertia.js + Vue 3 (final) |
| **Referensi** | `uangku-tes1.sql` (skema & data lama); proyek sebelumnya github.com/gravenths/uas-dw-uangku (PHP native) |
| **Repo saat ini** | github.com/gravenths/uangku-tes1 (skeleton Laravel kosong, belum ada Inertia/Vue) |

---

## 1. Ringkasan Eksekutif

UangKu adalah aplikasi pencatatan dan manajemen keuangan pribadi: mencatat pemasukan/pengeluaran dari berbagai akun (tunai, bank, e-wallet), mengelompokkan lewat kategori/sub-kategori, memberi tag, serta melihat ringkasan dan laporan keuangan.

- **Backend API**: Laravel 13.19.0 (satu sumber kebenaran)
- **Web app**: Laravel + Inertia.js + Vue 3
- **Mobile app**: Flutter 3.44.4 / Dart 3.12.2 (Android/iOS), konsumsi REST API yang sama (Sanctum)
- **Database**: MySQL 8.0.30

## 2. Latar Belakang & Konteks

Skema lama (`uangku-tes1.sql`) sudah punya domain model matang: multi-akun per user, kategori & sub-kategori, tagging many-to-many, audit log via trigger, laporan tahunan via MySQL `EVENT`, stored procedure ringkasan, dan view siap pakai.

> **PENTING:** Kolom `PASSWORD` pada tabel `user` lama bertipe `VARCHAR(8)` dan tersimpan plaintext (mis. `1234`). Ini wajib diganti hashing (bcrypt) di implementasi baru.

## 3. Tujuan Produk

1. Cara cepat & mudah mencatat transaksi dari HP (Flutter) maupun browser (web).
2. Visibilitas kesehatan keuangan: saldo per akun, tren pemasukan/pengeluaran, distribusi pengeluaran per kategori.
3. Mempertahankan fitur inti versi lama (multi-akun, kategori/sub-kategori, tag, audit log, laporan tahunan) dengan arsitektur aman & teruji.
4. Laravel sebagai single source of truth dipakai bersama web (Inertia/Vue) dan mobile (API).
5. Memperbaiki kelemahan keamanan & desain data versi lama.

**Non-goals v1**: multi-currency, integrasi bank/e-wallet langsung, shared household budget, investasi/aset.

## 4. Target Pengguna & Persona

| Persona | Kebutuhan Utama |
|---|---|
| Mahasiswa/pekerja muda | Input cepat, ringkasan per kategori, riwayat |
| Freelancer (pemasukan tidak tetap) | Tagging fleksibel, filter, laporan per akun |
| Pengguna mobile-first | Input ≤3 tap, notifikasi pengingat (Phase 2) |
| Pengguna analitis | Laporan tahunan, grafik, audit log |

## 5. Ruang Lingkup

### 5.1 MVP (Rilis 1)
- Autentikasi (register/login/logout, token mobile)
- CRUD Akun dengan saldo awal & saldo berjalan otomatis
- CRUD Kategori & Sub-kategori (seed dari data lama)
- CRUD Transaksi (pemasukan/pengeluaran) + tag many-to-many
- Dashboard: total saldo, ringkasan bulan berjalan, transaksi terbaru
- Riwayat transaksi + filter (tanggal, akun, kategori, tipe, tag) + pencarian
- Ringkasan per akun & per kategori (ganti stored procedure lama)
- Audit trail dasar

### 5.2 Phase 2
- Laporan tahunan otomatis (scheduled job, ganti MySQL EVENT) + grafik tren
- Ekspor CSV/PDF
- Kategori & tag kustom milik user
- Notifikasi push (pengingat, saldo rendah)
- Mode offline mobile

### 5.3 Phase 3
- Budgeting per kategori/bulan + alert
- Shared household
- Biometric login mobile
- Widget home-screen input cepat

## 6. Asumsi & Batasan

- **Frontend web**: Laravel + Inertia.js + Vue 3 — routing/controller tetap di Laravel, UI terasa SPA tanpa reload halaman. Build step Vite untuk aset Vue.
- **Auth**: Laravel Sanctum — token untuk Flutter (secure storage), Sanctum SPA session untuk web.
- Satu user bisa punya banyak akun; satu transaksi terikat ke tepat satu akun.
- Lingkungan awal: localhost. Deployment produksi di luar cakupan.
- Mata uang tunggal Rupiah (IDR), tanpa desimal.
- Laravel 13.x butuh PHP 8.3 minimum (8.4 direkomendasikan).

## 7. Arsitektur Sistem

Prinsip: Laravel satu backend untuk dua klien — web (Inertia/Vue, session cookie) dan mobile (Flutter, REST API + Sanctum token). Logika bisnis inti (validasi, saldo, audit) hidup di Service class/Model Observer, dipakai bersama controller Inertia maupun controller API.

**Prinsip kunci:**
- `saldo_sekarang` dihitung via Eloquent Model Observer di dalam `DB::transaction()` (bukan trigger MySQL). Rekonsiliasi berkala via Artisan command.
- Audit log via Model Observer, `data_lama`/`data_baru` disimpan sebagai kolom JSON (bukan string gabungan).
- Laporan tahunan via Laravel Task Scheduling + Artisan Command (bukan MySQL `EVENT`).

## 8. Model Data

### 8.1 Entitas Inti
`users`, `akun`, `kategori`, `sub_kategori`, `transaksi`, `tag`, `transaksi_tag` (pivot), `audit_log`, `laporan_tahunan`.

### 8.2 Perubahan Skema yang Direkomendasikan

| Item Lama | Masalah | Rekomendasi |
|---|---|---|
| Tabel `user` & `users` terpisah | Duplikasi | Konsolidasi ke `users` konvensi Laravel |
| `PASSWORD varchar(8)` plaintext | Keamanan | `Hash::make()`, kolom `varchar(255)` |
| Nama kolom UPPERCASE | Tidak sesuai konvensi Eloquent | Migration baru lowercase snake_case |
| Logika saldo di trigger SQL | Sulit diuji | Eloquent Observer + `DB::transaction()` |
| `audit_log` data sebagai string | Sulit di-query | Kolom `json` |
| `laporan_tahunan` via MySQL EVENT | Sulit diuji/portabel | Laravel Scheduler + Artisan Command |
| Typo `'Pemasukkan'` historis | Tidak ada validasi ketat | `enum`/validasi request |
| Stored procedure & view | Logika terkubur di DB | Eloquent query/Service class |

### 8.3 Seeder Data Awal
9 kategori (4 pemasukan, 5 pengeluaran), 7 sub-kategori, 20 tag — sesuai data di `uangku-tes1.sql`.

## 9. Kebutuhan Fungsional

**9.1 Auth**: FR-1.1 register (password hash); FR-1.2 login web+mobile (Sanctum token); FR-1.3 logout (cabut token); FR-1.4 (Phase 2) edit profil.

**9.2 Akun**: FR-2.1 CRUD akun; FR-2.2 `saldo_sekarang` read-only (dihitung otomatis); FR-2.3 hapus akun berisi transaksi wajib konfirmasi eksplisit.

**9.3 Kategori/Sub-kategori**: FR-3.1 list bawaan per tipe; FR-3.2 sub-kategori opsional; FR-3.3 (Phase 2) kategori kustom user.

**9.4 Transaksi**: FR-4.1 tambah (akun, tipe, kategori, sub-kategori opsional, tanggal, jumlah, keterangan, tag); FR-4.2 edit/hapus + audit log; FR-4.3 update saldo atomik termasuk pindah akun; FR-4.4 filter kombinasi + pencarian; FR-4.5 validasi (jumlah>0, tanggal tidak masa depan, tipe konsisten dengan kategori).

**9.5 Tag**: FR-5.1 many-to-many; FR-5.2 filter by tag.

**9.6 Dashboard**: FR-6.1 total saldo; FR-6.2 ringkasan bulan berjalan; FR-6.3 transaksi terbaru; FR-6.4 ringkasan per akun; FR-6.5 grafik distribusi kategori; FR-6.6 grafik tren bulanan.

**9.7 Laporan**: FR-7.1 per kategori; FR-7.2 laporan lengkap gabungan; FR-7.3 laporan tahunan otomatis; FR-7.4 (Phase 2) ekspor CSV/PDF.

**9.8 Audit Log**: FR-8.1 catat aksi/data lama/data baru/waktu/pelaku; FR-8.2 user bisa lihat riwayat perubahan transaksi.

**9.9 Mobile khusus**: FR-9.1 input ≤3 tap; FR-9.2 dashboard ringkas mobile; FR-9.3 (Phase 2) push notification; FR-9.4 (Phase 2) mode offline.

## 10. Kebutuhan Non-Fungsional

- **Keamanan**: password hashed, token Sanctum bisa dicabut, validasi input semua endpoint, rate limiting login, HTTPS saat produksi.
- **Performa**: paginasi transaksi (20–50/halaman), index FK dimanfaatkan.
- **Konsistensi data**: `DB::transaction()` + `lockForUpdate()` untuk update saldo.
- **Usability**: UI Bahasa Indonesia, mobile ikuti Material/Cupertino.
- **Kompatibilitas**: PHP 8.3+ (8.4 disarankan), MySQL 8.0.30, Flutter 3.44.4/Dart 3.12.2.
- **Testability**: logika bisnis di Service class/Artisan command yang unit-testable.

## 11. Gambaran Desain API

| Endpoint | Metode | Deskripsi |
|---|---|---|
| `/api/register`, `/api/login`, `/api/logout` | POST | Autentikasi |
| `/api/akun` | GET/POST/PUT/DELETE | CRUD akun |
| `/api/kategori`, `/api/kategori/{id}/sub-kategori` | GET | Daftar kategori/sub |
| `/api/transaksi` | GET/POST/PUT/DELETE | CRUD transaksi + filter query |
| `/api/tag` | GET | Daftar tag |
| `/api/dashboard/summary` | GET | Ringkasan dashboard |
| `/api/laporan/per-akun`, `/per-kategori`, `/tahunan/{tahun}` | GET | Laporan |
| `/api/transaksi/{id}/audit-log` | GET | Riwayat perubahan transaksi |

*Catatan: web (Inertia/Vue) mengakses logika yang sama lewat Service class internal (props Inertia), bukan lewat HTTP call ke `/api/*` miliknya sendiri.*

## 12. Alur Pengguna Utama

**Flow A**: dashboard → tap tambah → pilih akun/kategori/sub-kategori/tanggal/jumlah/tag → simpan → saldo & dashboard update seketika.
**Flow B**: login web → menu Laporan → filter → tabel + grafik → (Phase 2) ekspor.
**Flow C**: detail transaksi → "Riwayat perubahan" → lihat siapa/kapan/nilai lama vs baru.

## 13. Roadmap Ringkas

| Rilis | Fokus |
|---|---|
| v0.1 | Setup Laravel + migration/seeder, auth Sanctum, CRUD akun/kategori (backend saja) |
| v1.0 (MVP) | Transaksi, tag, dashboard, ringkasan, audit log — web + mobile |
| v1.1 | Laporan tahunan otomatis, ekspor, kategori/tag kustom |
| v1.2 | Notifikasi push, mode offline mobile |
| v2.0 | Budgeting, shared household, biometric login |

## 14. Metrik Keberhasilan

Transaksi/user/minggu, waktu rata-rata tambah transaksi (<15 detik mobile), retensi D7/D30, rasio edit setelah dibuat, nol insiden ketidakcocokan saldo.

## 15. Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| Migrasi data lama berantakan | Migration+seeder khusus, uji staging |
| Race condition update saldo | `DB::transaction()` + `lockForUpdate()` |
| Tim belum familiar Vue/Inertia | Alokasi waktu belajar di v0.1 |
| Scope creep Phase 2/3 masuk MVP | Pertahankan batas Bagian 5.1 ketat |

## 16. Lampiran — Pemetaan Fitur Lama → Baru

| Objek Lama | Pengganti Baru |
|---|---|
| `sp_ringkasan_akun` | `AkunService::ringkasan()` / `/api/laporan/per-akun` |
| `sp_transaksi_per_kategori` | Query Eloquent + `/api/laporan/per-kategori` |
| `sp_transaksi_per_user` | Otomatis terscope `user_id` login |
| `trg_transaksi_*` | `TransaksiObserver` + DB transaction |
| `evt_laporan_keuangan_tahunan` | Laravel Scheduler + Artisan Command |
| `v_transaksi_kategori` | `/api/laporan/per-kategori` |
| `v_transaksi_lengkap` | `/api/transaksi` dengan eager-loading relasi |
| `v_transaksi_user` | Otomatis lewat scope user login |
| Tabel `user` (custom) | Konsolidasi ke `users` (password hashed) |