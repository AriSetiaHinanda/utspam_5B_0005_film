class AppConstants {
  static const String appName = 'CineBook';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Aplikasi Pembelian Tiket Film Bioskop';
  
  // Database
  static const String databaseName = 'cinebook.db';
  static const int databaseVersion = 1;
  
  // Routes
  static const String routeHome = '/';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeFilms = '/films';
  static const String routeTransactions = '/transactions';
  static const String routeProfile = '/profile';
  
  // Payment Methods
  static const String paymentCash = 'Cash';
  static const String paymentCard = 'Kartu Debit/Kredit';
  
  // Transaction Status
  static const String statusCompleted = 'completed';
  static const String statusCancelled = 'cancelled';
  static const String statusPending = 'pending';
}