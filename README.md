# CineBook - Aplikasi Pembelian Tiket Film

**UTS Pemrograman Aplikasi Mobile**  
**Nama: Ari Setia Hinanda**  
**Kelas: 5B**  
**NIM: 3012310005**

## 📱 Deskripsi Aplikasi

CineBook adalah aplikasi mobile untuk pembelian tiket film yang dibangun menggunakan Flutter. Aplikasi ini memungkinkan pengguna untuk melihat daftar film, jadwal tayang, melakukan pembelian tiket, dan mengelola transaksi mereka.

## ✨ Fitur Utama

### 1. Autentikasi
- **Login** - Login dengan email/username dan password
- **Register** - Registrasi akun baru dengan validasi lengkap
- Sistem autentikasi menggunakan SQLite database

### 2. Manajemen Film
- **Daftar Film** - Tampilan grid/list film dengan poster, genre, rating, harga
- **Detail Film** - Informasi lengkap film (sinopsis, durasi, genre, rating)
- **Jadwal Tayang** - Lihat jadwal film dengan ketersediaan kursi
- **Pencarian Film** - Cari film berdasarkan judul
- **Filter Genre** - Filter film berdasarkan kategori (Action, Drama, Comedy, dll)

### 3. Transaksi
- **Pembelian Tiket** - Form pembelian dengan validasi
  - Pilih jumlah tiket
  - Pilih metode pembayaran (Cash/Kartu)
  - Auto-calculate total pembayaran
- **Riwayat Transaksi** - Lihat semua transaksi yang pernah dilakukan
- **Detail Transaksi** - Informasi lengkap transaksi termasuk:
  - Detail film dan jadwal
  - Informasi pembeli
  - Metode pembayaran
  - Status transaksi
- **Edit Transaksi** - Ubah jumlah tiket dan metode pembayaran
- **Batalkan Transaksi** - Batalkan transaksi yang sudah dibuat

### 4. Profile
- **Lihat Profile** - Tampilkan informasi user (username, email, alamat, telepon)
- **Edit Profile** - Update informasi profil
- **Ubah Password** - Ganti password dengan validasi
- **Dark Mode** - Toggle tema terang/gelap
- **Logout** - Keluar dari aplikasi

## 🛠️ Teknologi yang Digunakan

- **Flutter** - Framework UI
- **Dart** - Bahasa pemrograman
- **Provider** - State Management
- **SQLite (sqflite)** - Database lokal
- **Material Design 3** - Design system

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  sqflite: ^2.3.0
  path: ^1.8.3
```

## 🗂️ Struktur Project

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── database_constants.dart
│   ├── themes/
│   │   └── app_theme.dart
│   └── utils/
│       └── validators.dart
├── data/
│   ├── database/
│   │   ├── database_helper.dart
│   │   └── daos/
│   │       ├── user_dao.dart
│   │       ├── film_dao.dart
│   │       └── transaction_dao.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── film_model.dart
│   │   ├── schedule_model.dart
│   │   └── transaction_model.dart
│   └── repositories/
│       ├── user_repository.dart
│       ├── film_repository.dart
│       └── transaction_repository.dart
├── presentation/
│   ├── pages/
│   │   ├── auth/
│   │   │   ├── login_page.dart
│   │   │   └── register_page.dart
│   │   ├── home/
│   │   │   ├── home_page.dart
│   │   │   └── beranda_page.dart
│   │   ├── films/
│   │   │   ├── film_list_page.dart
│   │   │   └── film_detail_page.dart
│   │   ├── transaction/
│   │   │   ├── purchase_form_page.dart
│   │   │   ├── transaction_history_page.dart
│   │   │   ├── transaction_detail_page.dart
│   │   │   └── edit_transaction_page.dart
│   │   └── profile/
│   │       ├── profile_page.dart
│   │       ├── edit_profile_page.dart
│   │       └── reset_password_page.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── film_provider.dart
│   │   ├── transaction_provider.dart
│   │   └── theme_provider.dart
│   └── widgets/
│       ├── films/
│       │   ├── film_card.dart
│       │   └── schedule_card.dart
│       └── transactions/
│           └── transaction_card.dart
└── main.dart
```

## 🎨 Fitur UI/UX

- **Responsive Design** - Adaptif untuk berbagai ukuran layar
- **Dark Mode** - Tema gelap dan terang
- **Gradient Effects** - Gradient modern pada komponen UI
- **Card Design** - Kartu dengan shadow dan border radius
- **Icon Integration** - Material Icons terintegrasi
- **Loading States** - Indikator loading untuk operasi async
- **Error Handling** - Pesan error yang user-friendly
- **Form Validation** - Validasi input real-time

## 💾 Database Schema

### Users Table
```sql
- id: INTEGER PRIMARY KEY
- username: TEXT UNIQUE
- email: TEXT UNIQUE
- password: TEXT
- full_name: TEXT
- address: TEXT
- phone_number: TEXT
- created_at: TEXT
- updated_at: TEXT
```

### Films Table
```sql
- id: INTEGER PRIMARY KEY
- title: TEXT
- genre: TEXT
- price: REAL
- poster_url: TEXT
- description: TEXT
- duration: INTEGER
- rating: REAL
- created_at: TEXT
```

### Schedules Table
```sql
- id: INTEGER PRIMARY KEY
- film_id: INTEGER
- show_date: TEXT
- show_time: TEXT
- available_seats: INTEGER
- created_at: TEXT
```

### Transactions Table
```sql
- id: INTEGER PRIMARY KEY
- user_id: INTEGER
- film_id: INTEGER
- schedule_id: INTEGER
- buyer_name: TEXT
- quantity: INTEGER
- purchase_date: TEXT
- total_amount: REAL
- payment_method: TEXT
- card_number: TEXT
- status: TEXT
- created_at: TEXT
- updated_at: TEXT
```

## 🚀 Cara Menjalankan Aplikasi

1. Clone repository
```bash
git clone https://github.com/username/utspam_5B_0005_film.git
cd cinebook
```

2. Install dependencies
```bash
flutter pub get
```

3. Jalankan aplikasi
```bash
flutter run
```

## 📱 Testing

Aplikasi telah diuji pada:
- Android (Physical Device - RMX1821)
- Debug Mode
- Hot Reload/Restart berfungsi dengan baik

## Vidio Demo
https://drive.google.com/file/d/1sVK-A1czcfJS1JA8i7wKX-UsIAAwQDtc/view?usp=sharing

isi vidio: 
1. Registrasi dan Login
   <img width="436" height="870" alt="Cuplikan layar 2025-11-24 145314" src="https://github.com/user-attachments/assets/8d4513c5-8717-4d7e-9e69-a3178d69219d" />
   <img width="436" height="868" alt="Cuplikan layar 2025-11-24 150103" src="https://github.com/user-attachments/assets/03e6f4de-0e99-4a59-b6df-34260f900984" />
   
2. Home Dasboard
   <img width="436" height="875" alt="Cuplikan layar 2025-11-24 150329" src="https://github.com/user-attachments/assets/07394884-4cd7-40e5-9994-d3eb8debca74" />

3. Daftar Film dengan Fitur Pencarian
   <img width="428" height="872" alt="Cuplikan layar 2025-11-24 150720" src="https://github.com/user-attachments/assets/5489b5dc-e2a5-4481-a569-ddbb037ac81c" />

4. Pembelian tiket(Pilih Film --> Pilih Jumlah tiket & Jadwal tayang  --> Beli Tiket -->Pembelian Berhasil)
   Pilih Film 
   <img width="427" height="862" alt="Cuplikan layar 2025-11-24 151245" src="https://github.com/user-attachments/assets/b2216f0d-2aff-4113-8be1-6e9eb88bf94e" />
   
   Pilih Jumlah tiket & Jadwal tayang --> Beli Tiket
   <img width="436" height="871" alt="image" src="https://github.com/user-attachments/assets/f584e5a5-eab3-4daa-83e5-7e7bc3e6bc0b" />

   Pembelian Behasil
   <img width="435" height="874" alt="image" src="https://github.com/user-attachments/assets/2a67fa13-7942-4cfc-93bc-6caf33ae8c4a" />

5. Riwayat Transaksi & Detail Transaksi
   <img width="437" height="871" alt="image" src="https://github.com/user-attachments/assets/17767bc3-e3aa-49aa-8181-44369d4c4538" />
   <img width="433" height="869" alt="image" src="https://github.com/user-attachments/assets/fb857d7b-60a8-40c9-831f-ee7ef4052bfc" />
   
6. Informasi Profil dan Logout
   <img width="430" height="869" alt="image" src="https://github.com/user-attachments/assets/18093040-30fd-44be-80bf-fbf9ae10099b" />


## 🎯 Fitur Tambahan

- Auto-populate buyer name dari user yang login
- Masked card number untuk keamanan
- Transaction status management (Completed, Cancelled)
- Real-time total calculation
- Seat availability indicator
- Genre filtering dan search
- Dark mode persistence

## 📝 Catatan Pengembangan

### Challenges & Solutions

1. **State Management** - Menggunakan Provider untuk managing state
2. **Database Persistence** - SQLite untuk data lokal
3. **Form Validation** - Custom validators untuk semua input
4. **Dark Mode** - Theme switching dengan ThemeProvider
5. **Navigation** - MaterialPageRoute dengan proper context

### Best Practices Implemented

- Clean Architecture (Separation of Concerns)
- Repository Pattern
- Provider State Management
- Proper Error Handling
- Input Validation
- Responsive Design
- Code Documentation

## 📄 License

This project is created for educational purposes (UTS PAM).

## 👨‍💻 Developer

**NIM:** 3012310005  
**Kelas:** 5B  
**Mata Kuliah:** Pemrograman Aplikasi Mobile  
**Dosen:** [Moch Nurul Indra Al Fauzan, S.Kom., M.Eng]

3 November 2025  
**Status:** ✅ Completed
