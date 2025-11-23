import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinebook/presentation/providers/film_provider.dart';
import 'package:cinebook/presentation/pages/transaction/purchase_form_page.dart';
import 'package:cinebook/presentation/widgets/films/schedule_card.dart';

class FilmDetailPage extends StatefulWidget {
  final dynamic film;

  const FilmDetailPage({super.key, required this.film});

  @override
  _FilmDetailPageState createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FilmProvider>().loadFilmSchedules(widget.film.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filmProvider = context.watch<FilmProvider>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: Text(
              widget.film.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Film Poster and Basic Info
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: widget.film.posterUrl.startsWith('http')
                  ? Image.network(
                      widget.film.posterUrl,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.movie,
                            size: 80,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    )
                  : Container(
                      width: double.infinity,
                      height: 300,
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.movie,
                        size: 80,
                        color: Colors.grey[600],
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.film.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.film.genre,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[400]
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 4),
                Text('${widget.film.duration} menit'),
                const SizedBox(width: 16),
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${widget.film.rating}'),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Deskripsi:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.film.description ?? 'Tidak ada deskripsi',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Jadwal Tayang:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            filmProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filmProvider.schedules.isEmpty
                    ? Text(
                        'Tidak ada jadwal tersedia',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      )
                    : Column(
                        children: filmProvider.schedules.map((schedule) {
                          return ScheduleCard(
                            schedule: schedule,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PurchaseFormPage(
                                    film: widget.film,
                                    schedule: schedule,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
          ],
        ),
      ),
    );
  }
}