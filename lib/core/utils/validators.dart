class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email harus diisi';
    }
    if (!value.endsWith('@gmail.com')) {
      return 'Email harus menggunakan @gmail.com';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }
  
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon harus diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor telepon harus berupa angka';
    }
    if (value.length < 10) {
      return 'Nomor telepon minimal 10 digit';
    }
    return null;
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName harus diisi';
    }
    return null;
  }
  
  static String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor kartu harus diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor kartu harus berupa angka';
    }
    if (value.length != 16) {
      return 'Nomor kartu harus 16 digit';
    }
    return null;
  }
  
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah tiket harus diisi';
    }
    final quantity = int.tryParse(value);
    if (quantity == null || quantity <= 0) {
      return 'Jumlah tiket harus angka positif';
    }
    return null;
  }
}