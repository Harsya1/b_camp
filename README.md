# BCamp

**BCamp** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan pencarian dan booking *camp* (asrama) bagi siswa Brilliant English Course di Pare, Kediri. Aplikasi ini dikembangkan menggunakan **framework Flutter** dan **bahasa pemrograman Dart**.

## Fitur Utama

- **Booking Camp**  
  Pengguna dapat mencari dan memesan camp (asrama) sesuai kebutuhan mereka saat proses belajar di Brilliant English Course.

- **Login dan Pendaftaran Diri**  
  Sebelum melakukan booking, pengguna harus melakukan login dan melengkapi data diri dengan benar.

- **Feed Acara**  
  Pengguna dapat melihat berbagai acara yang diselenggarakan oleh Brilliant, seperti seminar, lomba, dan event sosial lainnya.

## Teknologi yang Digunakan

- Flutter (Frontend Mobile Development)
- Dart (Programming Language)
- Laravel (Backend API)
- MySQL (Database)

## Cara Install dan Menjalankan

1. Clone repositori ini:
   ```bash
   git clone https://github.com/Harsya1/b_camp.git
   ```
2. Masuk ke direktori project:
   ```bash
   cd b_camp
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Struktur Project
- `/lib` - berisi source code utama
- `/lib/screen` - halaman-halaman seperti Login, Booking, Feed, profile
- `/lib/assets` - komponen-komponen UI reusable
- `/lib/services` - API service atau authentication service

## Tujuan Aplikasi

- Membantu siswa Brilliant English Course menemukan asrama dengan mudah.
- Memberikan informasi terkini tentang acara dan kegiatan di Brilliant.
- Mempercepat proses registrasi dan booking secara digital.