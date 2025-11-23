class DatabaseConstants {
  // Table Names
  static const String tableUsers = 'users';
  static const String tableFilms = 'films';
  static const String tableSchedules = 'schedules';
  static const String tableTransactions = 'transactions';
  
  // User Columns
  static const String columnId = 'id';
  static const String columnFullName = 'full_name';
  static const String columnEmail = 'email';
  static const String columnAddress = 'address';
  static const String columnPhoneNumber = 'phone_number';
  static const String columnUsername = 'username';
  static const String columnPassword = 'password';
  static const String columnCreatedAt = 'created_at';
  
  // Film Columns
  static const String columnTitle = 'title';
  static const String columnGenre = 'genre';
  static const String columnPrice = 'price';
  static const String columnPosterUrl = 'poster_url';
  static const String columnDescription = 'description';
  static const String columnDuration = 'duration';
  static const String columnRating = 'rating';
  
  // Schedule Columns
  static const String columnFilmId = 'film_id';
  static const String columnShowDate = 'show_date';
  static const String columnShowTime = 'show_time';
  static const String columnAvailableSeats = 'available_seats';
  
  // Transaction Columns
  static const String columnUserId = 'user_id';
  static const String columnScheduleId = 'schedule_id';
  static const String columnBuyerName = 'buyer_name';
  static const String columnQuantity = 'quantity';
  static const String columnPurchaseDate = 'purchase_date';
  static const String columnTotalAmount = 'total_amount';
  static const String columnPaymentMethod = 'payment_method';
  static const String columnCardNumber = 'card_number';
  static const String columnStatus = 'status';
  static const String columnUpdatedAt = 'updated_at';
}