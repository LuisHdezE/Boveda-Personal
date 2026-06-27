import 'dart:math';

class SimulationData {
  final double initialBalance;
  final double monthlySavings;
  final double annualRate;
  final int years;
  final String currency;

  SimulationData({
    required this.initialBalance,
    required this.monthlySavings,
    required this.annualRate,
    required this.years,
    required this.currency,
  });

  int get months => years * 12;
  double get monthlyRate => (annualRate / 100) / 12;

  double get totalSaved => initialBalance + (monthlySavings * months);
  
  double get finalBalance {
    if (monthlyRate == 0) return totalSaved;
    final compoundInitial = initialBalance * pow(1 + monthlyRate, months);
    final compoundSavings = monthlySavings * ((pow(1 + monthlyRate, months) - 1) / monthlyRate);
    return compoundInitial + compoundSavings;
  }

  double get estimatedInterests => finalBalance - totalSaved;

  double balanceAtMonth(int month) {
    if (monthlyRate == 0) return initialBalance + (monthlySavings * month);
    final compoundInitial = initialBalance * pow(1 + monthlyRate, month);
    final compoundSavings = monthlySavings * ((pow(1 + monthlyRate, month) - 1) / monthlyRate);
    return compoundInitial + compoundSavings;
  }

  double interestAtMonth(int month) {
    if (month == 0) return 0;
    final prevBalance = balanceAtMonth(month - 1);
    return prevBalance * monthlyRate;
  }
}
