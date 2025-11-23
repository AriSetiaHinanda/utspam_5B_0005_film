class Schedule {
  final int? id;
  final int filmId;
  final String showDate;
  final String showTime;
  final int availableSeats;
  final DateTime? createdAt;

  Schedule({
    this.id,
    required this.filmId,
    required this.showDate,
    required this.showTime,
    required this.availableSeats,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'film_id': filmId,
      'show_date': showDate,
      'show_time': showTime,
      'available_seats': availableSeats,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      filmId: map['film_id'],
      showDate: map['show_date'],
      showTime: map['show_time'],
      availableSeats: map['available_seats'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
  
  String get displayDateTime {
    return '$showDate $showTime';
  }
}