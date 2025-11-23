class Transaction {
  final int? id;
  final int userId;
  final int filmId;
  final int scheduleId;
  final String buyerName;
  final int quantity;
  final String purchaseDate;
  final double totalAmount;
  final String paymentMethod;
  final String? cardNumber;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    this.id,
    required this.userId,
    required this.filmId,
    required this.scheduleId,
    required this.buyerName,
    required this.quantity,
    required this.purchaseDate,
    required this.totalAmount,
    required this.paymentMethod,
    this.cardNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'film_id': filmId,
      'schedule_id': scheduleId,
      'buyer_name': buyerName,
      'quantity': quantity,
      'purchase_date': purchaseDate,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'card_number': cardNumber,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      userId: map['user_id'],
      filmId: map['film_id'],
      scheduleId: map['schedule_id'],
      buyerName: map['buyer_name'],
      quantity: map['quantity'],
      purchaseDate: map['purchase_date'],
      totalAmount: map['total_amount']?.toDouble(),
      paymentMethod: map['payment_method'],
      cardNumber: map['card_number'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
  
  Transaction copyWith({
    int? id,
    int? userId,
    int? filmId,
    int? scheduleId,
    String? buyerName,
    int? quantity,
    String? purchaseDate,
    double? totalAmount,
    String? paymentMethod,
    String? cardNumber,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      filmId: filmId ?? this.filmId,
      scheduleId: scheduleId ?? this.scheduleId,
      buyerName: buyerName ?? this.buyerName,
      quantity: quantity ?? this.quantity,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cardNumber: cardNumber ?? this.cardNumber,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  String get maskedCardNumber {
    if (cardNumber == null || cardNumber!.isEmpty) {
      return '-';
    }
    return '**** **** **** ${cardNumber!.substring(12)}';
  }
}