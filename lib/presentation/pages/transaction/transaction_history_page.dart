import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinebook/presentation/providers/auth_provider.dart';
import 'package:cinebook/presentation/providers/transaction_provider.dart';
import 'package:cinebook/presentation/providers/film_provider.dart';
import 'package:cinebook/presentation/pages/transaction/transaction_detail_page.dart';
import 'package:cinebook/presentation/pages/home/home_page.dart';
import 'package:cinebook/presentation/widgets/transactions/transaction_card.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTransactions();
    });
  }

  void _loadTransactions() {
    final authProvider = context.read<AuthProvider>();
    final transactionProvider = context.read<TransactionProvider>();
    final filmProvider = context.read<FilmProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser != null) {
      filmProvider.loadAllFilms(); // Load films first
      transactionProvider.loadUserTransactions(currentUser.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final transactionProvider = context.watch<TransactionProvider>();
    final currentUser = authProvider.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('Anda harus login terlebih dahulu'));
    }

    return Scaffold(
      body: transactionProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactionProvider.transactions.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long_outlined,
                        size: 100,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum Ada Transaksi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Yuk, pesan tiket film favoritmu!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[400]
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1976D2).withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Switch to Film tab (index 0)
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(initialIndex: 0),
                                ),
                              );
                            },
                            icon: const Icon(Icons.movie, size: 22),
                            label: const Text(
                              'Lihat Daftar Film',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              shadowColor: Colors.transparent,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    _loadTransactions();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactionProvider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactionProvider.transactions[index];
                      return TransactionCard(
                        transaction: transaction,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailPage(
                                transactionId: transaction.id!,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }
}