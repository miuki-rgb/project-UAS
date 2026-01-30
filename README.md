# Busket Mobile - Bus Ticket Booking App 🚌📱

[![Flutter](https://img.shields.io/badge/Framework-Flutter-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Language-Dart-blue)](https://dart.dev)
[![Backend](https://img.shields.io/badge/Backend-Laravel%2012-red)](https://laravel.com)
[![Design](https://img.shields.io/badge/Design-Modern%20%26%20Minimalist-orange)](https://material.io)

**Busket** adalah aplikasi pemesanan tiket bus berbasis mobile yang dirancang dengan antarmuka modern, minimalis, dan sangat mudah digunakan. Aplikasi ini terintegrasi secara real-time dengan Web Admin melalui REST API untuk memberikan pengalaman pemesanan tiket yang mulus, mulai dari mencari jadwal hingga validasi tiket di bus.

---

## ✨ Fitur Utama

- **Antarmuka Modern**: Desain minimalis dengan palet warna premium (`#780000`, `#003049`, `#FDF0D5`).
- **Autentikasi Pengguna**: Login dan Register yang aman dengan sistem token (Laravel Sanctum).
- **Pencarian Tiket Cerdas**: Cari bus berdasarkan Kota Asal, Kota Tujuan, dan Tanggal Keberangkatan menggunakan picker yang interaktif.
- **Carousel Pengumuman**: Dapatkan info terbaru dan promo eksklusif melalui slider pengumuman yang estetik.
- **Transaksi Real-time**: Simulasi pembayaran dengan berbagai metode (Bank, E-Wallet).
- **E-Ticket (QR Code)**: Tiket digital yang dilengkapi dengan QR Code untuk validasi scan saat naik bus.
- **Single-Use Ticket**: Keamanan tingkat tinggi, tiket otomatis nonaktif (pudar) setelah di-scan oleh petugas.
- **Manajemen Profil**: Edit data diri dan ganti foto profil secara instan.
- **Notifikasi Terpadu**: Halaman notifikasi yang memisahkan antara Berita terbaru dan Riwayat Transaksi.

---

## 🛠️ Teknologi & Library

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Networking**: Dio (REST API Client)
- **Animation**: Flutter Animate
- **Utility**:
  - `qr_flutter`: Untuk menghasilkan kode QR.
  - `image_picker`: Untuk mengganti foto profil.
  - `intl`: Untuk format mata uang Rupiah dan tanggal.
  - `google_fonts`: Tipografi yang bersih dan elegan.

---

## 🚀 Instalasi & Persiapan

1. **Clone Repository**
   ```bash
   git clone https://github.com/miuki-rgb/project-UAS.git
   cd project-UAS
   ```

2. **Install Dependensi**
   ```bash
   flutter pub get
   ```

3. **Konfigurasi API**
   Buka file `lib/services/api_service.dart` dan sesuaikan `baseUrl` dengan alamat backend Anda:
   ```dart
   static String get baseUrl => 'https://alamat-api-anda.com/api';
   ```

4. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

---

## 📸 Tampilan Aplikasi

Aplikasi ini menggunakan filosofi desain **Less is More**, memastikan pengguna dapat memesan tiket hanya dalam beberapa ketukan layar. Setiap elemen UI telah dioptimalkan untuk responsivitas dan keindahan visual.

---

## 👨‍💻 Identitas Pengembang

Aplikasi ini dikembangkan oleh:
- **Nama**: Luki Solihin
- **NIM**: 23552011413
- **Kelas**: TIFRP23CNSB
- **Mata Kuliah**: UAS Pemrograman Web (Mobile Integration)

---

## 📄 Lisensi

Project ini berada di bawah lisensi **MIT**.

---
<p align="center">
  <b>@copyright by 23552011413_Luki Solihin_TIFRP23CNSB_UASWEB!</b>
</p>