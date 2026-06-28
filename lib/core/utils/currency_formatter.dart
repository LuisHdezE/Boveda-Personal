class CurrencyFormatter {
  static String formatAmount(double amount, {String? currencyCode}) {
    String formattedAmount;
    final absAmount = amount.abs();
    
    if (absAmount >= 1000000) {
      formattedAmount = '${(absAmount / 1000000).toStringAsFixed(2)}M';
    } else {
      final amountParts = absAmount.toStringAsFixed(2).split('.');
      final integerPart = amountParts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      final decimalPart = amountParts.length > 1 ? amountParts[1] : '00';
      formattedAmount = '$integerPart.$decimalPart';
    }
    
    final sign = amount < 0 ? '-' : (amount > 0 ? '+' : '');
    
    if (currencyCode != null) {
      final symbol = currencyCode == 'USD' ? 'USD ' : '\$';
      return '$sign$symbol$formattedAmount';
    } else {
      return '$sign$formattedAmount';
    }
  }

  static String formatAmountNeutral(double amount, {String? currencyCode}) {
    String formattedAmount;
    final absAmount = amount.abs();
    
    if (absAmount >= 1000000) {
      formattedAmount = '${(absAmount / 1000000).toStringAsFixed(2)}M';
    } else {
      final amountParts = absAmount.toStringAsFixed(2).split('.');
      final integerPart = amountParts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      final decimalPart = amountParts.length > 1 ? amountParts[1] : '00';
      formattedAmount = '$integerPart.$decimalPart';
    }
    
    final sign = amount < 0 ? '-' : '';
    
    if (currencyCode != null) {
      final symbol = currencyCode == 'USD' ? 'USD ' : '\$';
      return '$sign$symbol$formattedAmount';
    } else {
      return '$sign$formattedAmount';
    }
  }
}
