import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cinebook/presentation/providers/auth_provider.dart';
import 'package:cinebook/presentation/providers/transaction_provider.dart';
import 'package:cinebook/core/utils/validators.dart';
import 'package:cinebook/data/models/transaction_model.dart';
import 'package:cinebook/core/constants/app_constants.dart';
import 'package:cinebook/presentation/providers/film_provider.dart';
import 'package:cinebook/data/models/film_model.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const EditTransactionPage({super.key, required this.transaction});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _cardNumberController = TextEditingController();
  String _paymentMethod = AppConstants.paymentCash;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.transaction.quantity.toString();
    _paymentMethod = widget.transaction.paymentMethod;
    _cardNumberController.text = widget.transaction.cardNumber ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final filmProvider = context.read<FilmProvider>();
    final film = filmProvider.films.firstWhere(
      (f) => f.id == widget.transaction.filmId,
      orElse: () => Film(
        title: 'Loading...',
        genre: '',
        price: 0,
        posterUrl: '',
      ),
    );

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final totalAmount = quantity * film.price;

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
            title: const Text(
              'Edit Transaksi',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _isLoading ? null : _saveChanges,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Film Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: film.posterUrl.startsWith('http')
                          ? Image.network(
                              film.posterUrl,
                              width: 60,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 60,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.movie, color: Colors.grey),
                                );
                              },
                            )
                          : Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.movie, color: Colors.grey),
                            ),
                    ),
                    const SizedBox(width: 16),
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
                          ),
                          const SizedBox(height: 4),
                          Text(
                            film.genre,
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Harga: Rp ${film.price}',
                            style: TextStyle(
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: widget.transaction.buyerName,
                decoration: const InputDecoration(
                  labelText: 'Nama Pembeli',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Tiket',
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateQuantity,
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: widget.transaction.purchaseDate,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pembelian',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              Text(
                'Metode Pembayaran:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _paymentMethod,
                items: const [
                  DropdownMenuItem(
                    value: AppConstants.paymentCash,
                    child: Text('Cash'),
                  ),
                  DropdownMenuItem(
                    value: AppConstants.paymentCard,
                    child: Text('Kartu Debit/Kredit'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              if (_paymentMethod == AppConstants.paymentCard) ...[
                TextFormField(
                  controller: _cardNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Nomor Kartu Debit/Kredit',
                    prefixIcon: Icon(Icons.credit_card),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: Validators.validateCardNumber,
                ),
                const SizedBox(height: 16),
              ],
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF1976D2).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Pembayaran:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Rp ${totalAmount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _cancel,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(0, 50),
                            ),
                            child: const Text('Simpan'),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final authProvider = context.read<AuthProvider>();
      final transactionProvider = context.read<TransactionProvider>();
      final filmProvider = context.read<FilmProvider>();
      final currentUser = authProvider.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus login terlebih dahulu'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final film = filmProvider.films.firstWhere(
        (f) => f.id == widget.transaction.filmId,
      );

      final updatedTransaction = widget.transaction.copyWith(
        quantity: int.parse(_quantityController.text),
        paymentMethod: _paymentMethod,
        cardNumber: _paymentMethod == AppConstants.paymentCard ? _cardNumberController.text : null,
        totalAmount: (int.parse(_quantityController.text) * film.price).toDouble(),
        updatedAt: DateTime.now(),
      );

      final success = await transactionProvider.updateTransaction(updatedTransaction);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perubahan berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menyimpan perubahan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _cancel() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }
}