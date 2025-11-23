import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cinebook.db');
    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      // Drop and recreate all tables to update film descriptions to Indonesian
      await db.execute('DROP TABLE IF EXISTS transactions');
      await db.execute('DROP TABLE IF EXISTS schedules');
      await db.execute('DROP TABLE IF EXISTS films');
      await db.execute('DROP TABLE IF EXISTS users');
      
      // Recreate all tables with updated data
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    // Users Table
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        address TEXT NOT NULL,
        phone_number TEXT NOT NULL,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    // Films Table
    await db.execute('''
      CREATE TABLE films(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        genre TEXT NOT NULL,
        price REAL NOT NULL,
        poster_url TEXT NOT NULL,
        description TEXT,
        duration INTEGER,
        rating REAL,
        created_at TEXT
      )
    ''');

    // Schedules Table
    await db.execute('''
      CREATE TABLE schedules(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        film_id INTEGER NOT NULL,
        show_date TEXT NOT NULL,
        show_time TEXT NOT NULL,
        available_seats INTEGER NOT NULL,
        created_at TEXT,
        FOREIGN KEY(film_id) REFERENCES films(id) ON DELETE CASCADE
      )
    ''');

    // Transactions Table
    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        film_id INTEGER NOT NULL,
        schedule_id INTEGER NOT NULL,
        buyer_name TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        purchase_date TEXT NOT NULL,
        total_amount REAL NOT NULL,
        payment_method TEXT NOT NULL,
        card_number TEXT,
        status TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
        FOREIGN KEY(film_id) REFERENCES films(id),
        FOREIGN KEY(schedule_id) REFERENCES schedules(id)
      )
    ''');

    // Insert dummy data
    await _insertDummyData(db);
  }

  Future<void> _insertDummyData(Database db) async {
    // ACTION GENRE - 6 Films
    await db.insert('films', {
      'title': 'John Wick: Chapter 4',
      'genre': 'Action',
      'price': 50000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/vZloFAK7NmvMGKE7VkF5UHaz0I.jpg',
      'description': 'John Wick mengungkap jalan untuk mengalahkan The High Table. Tapi sebelum dia bisa mendapatkan kebebasannya, Wick harus berhadapan dengan musuh baru dengan aliansi kuat di seluruh dunia dan kekuatan yang mengubah teman lama menjadi musuh.',
      'duration': 147,
      'rating': 7.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Batman',
      'genre': 'Action',
      'price': 48000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg',
      'description': 'Ketika seorang pembunuh berantai mulai membunuh tokoh-tokoh politik terkemuka di Gotham, Batman terpaksa menyelidiki korupsi yang tersembunyi di kota itu dan mempertanyakan keterkaitan keluarganya.',
      'duration': 176,
      'rating': 7.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Top Gun: Maverick',
      'genre': 'Action',
      'price': 47000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/62HCnUTziyWcpDaBO2i1DX17ljH.jpg',
      'description': 'Setelah lebih dari tiga puluh tahun bertugas sebagai salah satu penerbang angkatan laut terbaik, Pete "Maverick" Mitchell berada di posisi yang dia hindari, mendorong batasan sebagai pilot uji coba yang berani.',
      'duration': 131,
      'rating': 8.2,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Black Panther: Wakanda Forever',
      'genre': 'Action',
      'price': 49000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
      'description': 'Ratu Ramonda, Shuri, M\'Baku, Okoye dan Dora Milaje berjuang melindungi negara mereka dari campur tangan kekuatan dunia setelah kematian Raja T\'Challa.',
      'duration': 161,
      'rating': 7.3,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Avatar: The Way of Water',
      'genre': 'Action',
      'price': 52000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      'description': 'Lebih dari satu dekade setelah peristiwa film pertama, Avatar: The Way of Water mulai menceritakan kisah keluarga Sully dan kesulitan yang mereka hadapi di planet Pandora.',
      'duration': 192,
      'rating': 7.6,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Spider-Man: No Way Home',
      'genre': 'Action',
      'price': 50000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg',
      'description': 'Dengan identitas Spider-Man terungkap, Peter meminta bantuan Doctor Strange. Ketika mantra salah, musuh berbahaya dari dunia lain mulai muncul.',
      'duration': 148,
      'rating': 8.2,
      'created_at': DateTime.now().toIso8601String()
    });

    // COMEDY GENRE - 6 Films
    await db.insert('films', {
      'title': 'Everything Everywhere All at Once',
      'genre': 'Comedy',
      'price': 45000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/w3LxiVYdWWRvEVdn5RYq6jIqkb1.jpg',
      'description': 'Seorang ibu Tionghoa-Amerika yang sedang kewalahan terhubung dengan versi dirinya yang hidup di alam semesta paralel untuk menghentikan ancaman jahat yang ingin menghancurkan multiverse.',
      'duration': 139,
      'rating': 7.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Super Mario Bros. Movie',
      'genre': 'Comedy',
      'price': 42000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/qNBAXBIQlnOThrVvA6mA2B5ggV6.jpg',
      'description': 'Ketika bekerja di bawah tanah untuk memperbaiki pipa air, Mario dan Luigi secara ajaib dipindahkan melalui pipa misterius dan berpisah di kerajaan ajaib yang berbeda.',
      'duration': 92,
      'rating': 7.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Free Guy',
      'genre': 'Comedy',
      'price': 40000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/xmbU4JTUm8rsdtn7Y3Fcm30GpeT.jpg',
      'description': 'Seorang teller bank yang menemukan bahwa dia sebenarnya adalah karakter latar belakang dalam video game brutal yang memutuskan untuk menjadi pahlawan dalam ceritanya sendiri.',
      'duration': 115,
      'rating': 7.1,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Ghostbusters: Afterlife',
      'genre': 'Comedy',
      'price': 43000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/sg4xJaufDiQl7caFEskBtQXfD4x.jpg',
      'description': 'Ketika seorang ibu tunggal dan dua anaknya tiba di kota kecil, mereka mulai menemukan hubungan mereka dengan Ghostbusters asli.',
      'duration': 124,
      'rating': 7.1,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Bad Guys',
      'genre': 'Comedy',
      'price': 38000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/7qop80YfuO0BwJa1uXk1DXUUEwv.jpg',
      'description': 'Sekelompok penjahat hewan yang lihai akan mencoba penipuan paling menantang mereka - menjadi warga negara yang baik.',
      'duration': 100,
      'rating': 6.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Hangover',
      'genre': 'Comedy',
      'price': 41000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/uluhlXubGu1VxU63X9VHCLWDAYP.jpg',
      'description': 'Tiga teman bangun dari pesta pernikahan di Las Vegas tanpa memori malam sebelumnya dan harus menemukan mempelai pria yang hilang sebelum pernikahan dimulai. Petualangan gila mereka mengungkap malam yang tak terlupakan.',
      'duration': 118,
      'rating': 6.4,
      'created_at': DateTime.now().toIso8601String()
    });

    // DRAMA GENRE - 6 Films
    await db.insert('films', {
      'title': 'The Whale',
      'genre': 'Drama',
      'price': 46000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/jQ0gylJMxWSL490sy0RrPj1Lj7e.jpg',
      'description': 'Seorang guru bahasa Inggris yang tertutup dan gemuk mencoba untuk berhubungan kembali dengan putri remajanya yang putus asa.',
      'duration': 117,
      'rating': 8.0,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'A Man Called Otto',
      'genre': 'Drama',
      'price': 44000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/130H1gap9lFfiTF9iDrqNIkFvC9.jpg',
      'description': 'Otto adalah seorang duda pemarah yang memiliki sikap sangat ketat dan prinsip yang tidak tergoyahkan. Hidupnya berubah ketika keluarga yang cerewet pindah bersebelahan.',
      'duration': 126,
      'rating': 7.5,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Shawshank Redemption',
      'genre': 'Drama',
      'price': 45000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg',
      'description': 'Dua orang narapidana menjalin ikatan selama beberapa tahun, menemukan penghiburan dan penebusan akhir melalui tindakan kebaikan umum.',
      'duration': 142,
      'rating': 9.3,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Godfather',
      'genre': 'Drama',
      'price': 43000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      'description': 'Patriark tua dinasti kejahatan organized crime mentransfer kendali imperiumnya kepada putranya yang enggan.',
      'duration': 175,
      'rating': 9.2,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Parasite',
      'genre': 'Drama',
      'price': 44000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg',
      'description': 'Keluarganya yang berencana menganggur mengambil minat yang aneh dan tak terduga pada keluarga kaya yang menggoda dengan banyak uang dan sedikit rasa.',
      'duration': 132,
      'rating': 8.5,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Green Book',
      'genre': 'Drama',
      'price': 45000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/7BsvSuDQuoqhWmU2fL7W2GOcZHU.jpg',
      'description': 'Seorang pesawat bouncer dari klub malam Italia di Bronx bekerja sebagai pengemudi untuk pianis jazz Afrika-Amerika klasik dalam tur melalui Deep South tahun 1960-an.',
      'duration': 130,
      'rating': 8.3,
      'created_at': DateTime.now().toIso8601String()
    });

    // HORROR GENRE - 6 Films
    await db.insert('films', {
      'title': 'Smile',
      'genre': 'Horror',
      'price': 42000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/67Myda9zANAnlS54rRjQF4dHNNG.jpg',
      'description': 'Setelah menyaksikan insiden aneh dan traumatis yang melibatkan seorang pasien, Dr. Rose Cotter mulai mengalami kejadian menakutkan yang tidak dapat dia jelaskan.',
      'duration': 115,
      'rating': 6.7,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'M3GAN',
      'genre': 'Horror',
      'price': 43000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/d9nBoowhjiiYc4FBNtQkPY7c11H.jpg',
      'description': 'Seorang insinyur robotika di perusahaan mainan menggunakan AI untuk mengembangkan M3GAN, boneka yang diprogram secara realistis yang dirancang untuk menjadi sahabat terbaik anak dan sekutu terbaik orang tua.',
      'duration': 102,
      'rating': 6.9,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Get Out',
      'genre': 'Horror',
      'price': 41000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/tFXcEccSQMf3lfhfXKSU9iRBpa3.jpg',
      'description': 'Seorang pria Afrika-Amerika yang berkunjung ke orang tua kulit putih pacarnya menjadi semakin yakin bahwa ada sesuatu yang sangat salah.',
      'duration': 103,
      'rating': 7.7,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Nope',
      'genre': 'Horror',
      'price': 44000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/AcKVlWaNVVVFQwro3nLXqPljcYA.jpg',
      'description': 'Penduduk di lembah terpencil California pedalaman menyaksikan penemuan aneh dan mengerikan yang tidak dapat dijelaskan.',
      'duration': 130,
      'rating': 6.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'A Quiet Place',
      'genre': 'Horror',
      'price': 40000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/nAU74GmpUk7t5iklEp3bufwDq4n.jpg',
      'description': 'Dalam dunia pasca-apokaliptik, sebuah keluarga dipaksa untuk hidup dalam keheningan sambil menyembunyikan diri dari makhluk dengan pendengaran ultra-sensitif.',
      'duration': 102,
      'rating': 7.5,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Hereditary',
      'genre': 'Horror',
      'price': 39000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/4GFPuL14eXi66V96xBWY73Y9PfR.jpg',
      'description': 'Setelah kematian nenek mereka, keluarga Graham mulai mengungkap rahasia mengerikan tentang keturunan mereka yang membawa mereka pada nasib yang menakutkan.',
      'duration': 105,
      'rating': 6.6,
      'created_at': DateTime.now().toIso8601String()
    });

    // ROMANCE GENRE - 6 Films
    await db.insert('films', {
      'title': 'A Star is Born',
      'genre': 'Romance',
      'price': 40000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/wrFpXMNBRj2PBiN4Z5kix51XaIZ.jpg',
      'description': 'Seorang musisi yang karir musiknya memudar menemukan dan jatuh cinta dengan penyanyi berbakat. Dia mengalami kesuksesan spektakuler sementara dia terus berjuang melawan perjuangan pribadi.',
      'duration': 136,
      'rating': 6.4,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Marry Me',
      'genre': 'Romance',
      'price': 38000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/ko1JVbGj4bT8IhCWqjBQ6ZtF2t.jpg',
      'description': 'Superstar musik Kat Valdez akan menikah di hadapan penggemar global. Tapi ketika Kat mengetahui tunangannya selingkuh, dia secara spontan menikahi seorang pria asing dari kerumunan.',
      'duration': 112,
      'rating': 6.6,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Lost City',
      'genre': 'Romance',
      'price': 41000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/neMZH82Stu91d3iqvLdNQfqPPyl.jpg',
      'description': 'Seorang penulis roman petualangan yang kesepian terpaksa bekerja sama dengan model sampul bukunya untuk bertahan hidup di alam liar.',
      'duration': 112,
      'rating': 6.5,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'La La Land',
      'genre': 'Romance',
      'price': 42000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/uDO8zWDhfWwoFdKS4fzkUJt0Rf0.jpg',
      'description': 'Ketika seorang pianis jazz jatuh cinta dengan aktris yang bercita-cita tinggi di Los Angeles, keduanya didorong untuk menghadapi pertanyaan tentang seni, cinta, dan ambisi.',
      'duration': 156,
      'rating': 7.1,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Cyrano',
      'genre': 'Romance',
      'price': 39000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/k2WyDw2NTUIWnuEs5gT7wgrCQg6.jpg',
      'description': 'Cyrano de Bergerac, seorang pria yang di depan zamannya, memukau dengan permainan kata yang ganas maupun dengan permainan pedang yang brilian dalam duel.',
      'duration': 123,
      'rating': 6.4,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Fire of Love',
      'genre': 'Romance',
      'price': 40000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/wrFpXMNBRj2PBiN4Z5kix51XaIZ.jpg',
      'description': 'Kisah cinta sejati tentang dua ahli vulkanologi Prancis yang mencurahkan hidup mereka untuk mengeksplorasi gunung berapi di seluruh dunia.',
      'duration': 115,
      'rating': 7.6,
      'created_at': DateTime.now().toIso8601String()
    });

    // SCI-FI GENRE - 6 Films
    await db.insert('films', {
      'title': 'Avatar: The Way of Water',
      'genre': 'Sci-Fi',
      'price': 52000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
      'description': 'Lebih dari satu dekade setelah peristiwa film pertama, Jake Sully dan keluarganya menghadapi ancaman baru yang memaksa mereka mencari perlindungan di antara suku Metkayina.',
      'duration': 192,
      'rating': 7.6,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Dune',
      'genre': 'Sci-Fi',
      'price': 48000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg',
      'description': 'Paul Atreides, seorang pemuda cerdas dan berbakat yang lahir untuk menghadapi takdir yang lebih besar daripada yang dapat dia pahami, harus melakukan perjalanan ke planet paling berbahaya di alam semesta.',
      'duration': 155,
      'rating': 8.0,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Doctor Strange in the Multiverse of Madness',
      'genre': 'Sci-Fi',
      'price': 47000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/9Gtg2DzBhmYamXBS1hKAhiwbBKS.jpg',
      'description': 'Dr. Stephen Strange melemparkan mantra terlarang yang membuka pintu gerbang ke multiverse, termasuk versi alternatif dari dirinya sendiri, yang ancamannya baru mulai disadari manusia.',
      'duration': 126,
      'rating': 7.3,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'The Matrix Resurrections',
      'genre': 'Sci-Fi',
      'price': 46000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/8c4a8kE7PizaGQQnditMmI1xbRp.jpg',
      'description': 'Diganggu oleh kenangan aneh, kehidupan Neo berubah tak terduga ketika dia menemukan dirinya kembali ke dalam Matrix.',
      'duration': 148,
      'rating': 6.7,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Nope',
      'genre': 'Sci-Fi',
      'price': 44000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/AcKVlWaNVVVFQwro3nLXqPljcYA.jpg',
      'description': 'Penduduk di lembah terpencil California pedalaman menyaksikan penemuan aneh dan mengerikan yang tidak dapat dijelaskan.',
      'duration': 130,
      'rating': 6.8,
      'created_at': DateTime.now().toIso8601String()
    });

    await db.insert('films', {
      'title': 'Everything Everywhere All at Once',
      'genre': 'Sci-Fi',
      'price': 45000.0,
      'poster_url': 'https://image.tmdb.org/t/p/w500/w3LxiVYdWWRvEVdn5RYq6jIqkb1.jpg',
      'description': 'Seorang imigran Tionghoa yang menua terseret ke dalam petualangan gila, di mana hanya dia yang dapat menyelamatkan apa yang penting baginya dengan terhubung ke kehidupan yang bisa dia jalani.',
      'duration': 139,
      'rating': 7.8,
      'created_at': DateTime.now().toIso8601String()
    });

    // Get film IDs
    List<Map<String, dynamic>> films = await db.query('films');
    
    // Random generator for seats and times
    final random = DateTime.now().millisecondsSinceEpoch;
    
    // Time slots untuk jadwal random
    final timeSlots = [
      '13:30', '14:00', '14:30', '15:00', '15:30', '16:00', '16:30',
      '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00',
      '20:30', '21:00', '21:30', '22:00', '22:30'
    ];
    
    // Insert random schedules for each film (3 jadwal berbeda per film)
    for (var i = 0; i < films.length; i++) {
      final film = films[i];
      
      // Pilih 3 waktu random untuk setiap film
      final seed = random + i;
      final selectedTimes = <String>[];
      // Jadwal 1
      final time1Index = (seed * 7 + i * 3) % timeSlots.length;
      selectedTimes.add(timeSlots[time1Index]);
      
      // Jadwal 2 (berbeda dari jadwal 1)
      final time2Index = (seed * 11 + i * 5 + 7) % timeSlots.length;
      selectedTimes.add(timeSlots[time2Index]);
      
      // Jadwal 3 (berbeda dari jadwal 1 dan 2)
      final time3Index = (seed * 13 + i * 7 + 13) % timeSlots.length;
      selectedTimes.add(timeSlots[time3Index]);
      
      // Insert 3 schedules dengan kursi random
      for (var j = 0; j < selectedTimes.length; j++) {
        // Random seats: 30-100 kursi
        final availableSeats = 30 + ((seed + i * 10 + j * 20) % 71);
        
        await db.insert('schedules', {
          'film_id': film['id'],
          'show_date': '2025-11-25',
          'show_time': selectedTimes[j],
          'available_seats': availableSeats,
          'created_at': DateTime.now().toIso8601String()
        });
      }
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }
}