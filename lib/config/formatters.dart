class AppFormatters {
  // Formatea un monto con separador de miles en punto (formato colombiano)
  static String amount(double value) {
    final parts = value.toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    final reversed = parts.reversed.toList();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) buffer.write('.');
      buffer.write(reversed[i]);
    }

    return '\$${buffer.toString().split('').reversed.join()}';
  }
}