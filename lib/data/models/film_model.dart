class Film {
  final int? id;
  final String title;
  final String genre;
  final double price;
  final String posterUrl;
  final String? description;
  final int? duration;
  final double? rating;
  final DateTime? createdAt;

  Film({
    this.id,
    required this.title,
    required this.genre,
    required this.price,
    required this.posterUrl,
    this.description,
    this.duration,
    this.rating,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'price': price,
      'poster_url': posterUrl,
      'description': description,
      'duration': duration,
      'rating': rating,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory Film.fromMap(Map<String, dynamic> map) {
    return Film(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      price: map['price']?.toDouble(),
      posterUrl: map['poster_url'],
      description: map['description'],
      duration: map['duration'],
      rating: map['rating']?.toDouble(),
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}