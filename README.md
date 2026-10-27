## REST API

Aplikasi menggunakan REST API latihan untuk Course Data Manager.

- Base URL: `https://course-api-pearl.vercel.app`
- Endpoint GET: `/courses`
- Method: `GET`
- Status Code berhasil: `200 OK`

Contoh field JSON yang digunakan:

```json
{
  "id": 1,
  "code": "MOB01",
  "title": "Git & GitHub",
  "credits": 2,
  "status": "active"
}
```

# Course Data Manager

Aplikasi manajemen mata kuliah berbasis Flutter yang terintegrasi dengan backend database cloud Supabase (PostgreSQL), menerapkan prinsip Clean Architecture, dan State Management menggunakan Provider.

## Identitas Pembuat
- **Nama:** Amelia Elsa Syah Fitri Situmorang
- **NIM:** 2415051042

## Fitur Aplikasi
- **CRUD Operations:** Menampilkan (SELECT), Menambah (INSERT), Mengubah (UPDATE), dan Menghapus (DELETE) data mata kuliah secara permanen ke Supabase.
- **State Handling:** Loading state, Empty state, dan Error state dengan tombol *Retry*.
- **Security & Validation:** Pemanfaatan Row Level Security (RLS) dan Database Constraint (PostgreSQL).

## Arsitektur Singkat
Aplikasi ini memisahkan lapisan secara ketat:
- `models/`: Struktur data objek Course.
- `services/`: Komunikasi data sumber (CourseSupabaseService).
- `repositories/`: Perantara pemanggilan data.
- `providers/`: Pengelolaan state aplikasi (Provider).
- `screens/ & widgets/`: Antarmuka pengguna yang responsif.

## Cara Menjalankan Aplikasi
1. Clone repository ini.
2. Jalankan perintah `flutter pub get` untuk mengunduh dependencies.
3. Pastikan konfigurasi Supabase URL dan Anon Key sudah benar diinisialisasi pada `main.dart`.
4. Jalankan aplikasi menggunakan perintah `flutter run`.