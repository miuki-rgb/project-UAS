# BusKet

**Solusi Terintegrasi Manajemen dan Pemesanan Tiket Bus Antar Kota**

BusKet adalah platform komprehensif yang dirancang untuk memodernisasi industri transportasi bus. Platform ini menjembatani kesenjangan antara operator bus dan penumpang melalui dua komponen utama: Dashboard Admin berbasis Web untuk manajemen operasional yang efisien, dan Aplikasi Mobile untuk pengalaman pemesanan tiket yang mudah bagi penumpang.

---

## Tentang Proyek

Industri transportasi bus seringkali menghadapi tantangan dalam manajemen inventaris tiket secara real-time dan kemudahan akses bagi penumpang. BusKet hadir untuk menyelesaikan masalah tersebut dengan menyediakan:

* **Sentralisasi Data:** Pengelolaan jadwal, armada, dan manifest penumpang dalam satu database terpusat.
* **Aksesibilitas:** Memungkinkan penumpang memesan tiket kapan saja dan di mana saja tanpa harus datang ke terminal/agen.
* **Transparansi:** Informasi ketersediaan kursi dan harga yang transparan secara real-time.

---

## Arsitektur Sistem

Proyek ini dibagi menjadi dua repositori atau modul utama:

1.  **BusKet Admin (Web):** Portal untuk staf operasional dan manajemen PO Bus.
2.  **BusKet Mobile (App):** Antarmuka pengguna akhir (penumpang) untuk Android/iOS.
3.  **BusKet API (Backend):** Server pusat yang menghubungkan kedua antarmuka di atas.

---

## Fitur Utama

### 1. Dashboard Admin (Web)

Dirancang untuk administrator, agen, dan manajer operasional.

* **Manajemen Armada:** Menambah, mengedit, dan memantau status fisik bus (aktif, perawatan, rusak) beserta fasilitas yang tersedia.
* **Manajemen Rute & Jadwal:** Pengaturan rute keberangkatan, rute tujuan, titik penjemputan (pool), dan jam keberangkatan.
* **Manajemen Tiket:** Memantau penjualan tiket, pembatalan, dan *reschedule* oleh admin.
* **Visualisasi Kursi:** Pengaturan tata letak kursi (seat layout) berdasarkan tipe bus (Executive, Sleeper, Ekonomi).
* **Laporan & Analitik:** Laporan pendapatan harian/bulanan, tingkat okupansi penumpang, dan performa rute terlaris.
* **Verifikasi Tiket:** Fitur untuk memindai atau memvalidasi tiket penumpang saat boarding.

### 2. Aplikasi Penumpang (Mobile)

Dirancang untuk kemudahan pengguna akhir.

* **Pencarian Cerdas:** Mencari bus berdasarkan kota asal, tujuan, dan tanggal keberangkatan.
* **Filter & Sortir:** Menyaring hasil berdasarkan harga, waktu berangkat, kelas bus, atau fasilitas.
* **Pemilihan Kursi Real-time:** Memilih kursi yang diinginkan secara visual agar tidak tumpang tindih dengan penumpang lain.
* **E-Ticket:** Tiket elektronik dengan QR Code untuk boarding tanpa kertas.
* **Riwayat Perjalanan:** Melihat riwayat pemesanan yang sudah selesai atau yang akan datang.
