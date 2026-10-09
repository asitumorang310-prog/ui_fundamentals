# Course Explorer v2

Aplikasi Course Explorer v2 dibangun dengan menerapkan prinsip *Clean Architecture* dan *Separation of Concerns* menggunakan Flutter dan Provider.

## Identitas Mahasiswa
* **Nama:** Amelia Elsa Syah Fitri Situmorang
* **NIM:** 2415051042

## Tanggung Jawab Struktur Folder (`lib/`)

1. **`models/`**
   - Berisi definisi struktur data (struktur objek data kursus beserta fungsi serialisasi JSON seperti `fromJson`).
   
2. **`services/`**
   - Bertanggung jawab penuh terhadap pengambilan data mentah dari sumber luar (seperti membaca file JSON lokal via `rootBundle` atau mengambil data dari REST API).

3. **`repositories/`**
   - Berperan sebagai lapisan abstraksi antara *Provider* dan *Service*. Menyediakan API data yang bersih sehingga logika bisnis tidak perlu tahu dari mana data tersebut berasal.

4. **`providers/`**
   - Bertindak sebagai *State Holder* (menggunakan `ChangeNotifier`). Mengelola status asinkron (`isLoading`, `error`, `courses`) serta state aplikasi bersama seperti daftar mata kuliah favorit (*shared favorites*).

5. **`screens/`**
   - Berisi komponen antarmuka layar penuh (seperti `HomePage`, `CourseDetailPage`, dan `FavoritesPage`) yang merender data secara reaktif dari *Provider*.

6. **`widgets/`**
   - Berisi komponen UI modular yang dapat digunakan kembali (*reusable components*), seperti `CourseCard`.