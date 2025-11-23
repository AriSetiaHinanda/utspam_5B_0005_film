import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinebook/presentation/providers/film_provider.dart';
import 'package:cinebook/presentation/pages/films/film_detail_page.dart';
import 'package:cinebook/presentation/widgets/films/film_card.dart';

class FilmListPage extends StatefulWidget {
  final bool isGridView;
  
  const FilmListPage({super.key, this.isGridView = true});

  @override
  _FilmListPageState createState() => _FilmListPageState();
}

class _FilmListPageState extends State<FilmListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedGenre = 'Semua';
  List<String> _genres = ['Semua'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFilms();
    });
  }

  void _loadFilms() async {
    final filmProvider = context.read<FilmProvider>();
    await filmProvider.loadAllFilms();
    
    // Get unique genres
    final genres = filmProvider.films
        .map((film) => film.genre)
        .toSet()
        .toList()
      ..sort();
    
    setState(() {
      _genres = ['Semua', ...genres];
    });
  }

  List<dynamic> get _filteredFilms {
    final filmProvider = context.watch<FilmProvider>();
    var films = filmProvider.films;

    // Filter by genre
    if (_selectedGenre != 'Semua') {
      films = films.where((film) => film.genre == _selectedGenre).toList();
    }

    // Filter by search
    if (_searchController.text.isNotEmpty) {
      films = films.where((film) => 
        film.title.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    return films;
  }

  @override
  Widget build(BuildContext context) {
    final filmProvider = context.watch<FilmProvider>();

    return filmProvider.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Cari film berdasarkan judul...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),

              // Genre Filter Chips
              SizedBox(
                height: 45,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _genres.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final genre = _genres[index];
                    final isSelected = _selectedGenre == genre;
                    return FilterChip(
                      label: Text(genre),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedGenre = genre;
                        });
                      },
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      backgroundColor: Colors.grey[200],
                      checkmarkColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Films Display
              Expanded(
                child: _filteredFilms.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada film yang ditemukan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      )
                    : widget.isGridView
                        ? GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                            itemCount: _filteredFilms.length,
                            itemBuilder: (context, index) {
                              final film = _filteredFilms[index];
                              return FilmCard(
                                film: film,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FilmDetailPage(film: film),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredFilms.length,
                            itemBuilder: (context, index) {
                              final film = _filteredFilms[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Card(
                                  elevation: 2,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FilmDetailPage(film: film),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        children: [
                                          // Poster
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: film.posterUrl.startsWith('http')
                                                ? Image.network(
                                                    film.posterUrl,
                                                    width: 80,
                                                    height: 120,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        width: 80,
                                                        height: 120,
                                                        color: Colors.grey[300],
                                                        child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                                                      );
                                                    },
                                                  )
                                                : Container(
                                                    width: 80,
                                                    height: 120,
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.movie, size: 40, color: Colors.grey),
                                                  ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Film Info
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  film.title,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue.withValues(alpha: 0.1),
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    film.genre,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${film.duration} min',
                                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    const Icon(Icons.star, size: 14, color: Colors.amber),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${film.rating}',
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  'Rp ${film.price.toStringAsFixed(0)}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}