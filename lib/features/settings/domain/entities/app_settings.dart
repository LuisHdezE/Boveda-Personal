class AppSettings {
  const AppSettings({
    required this.userId,
    required String primaryCurrencyCode,
    required this.locale,
    required this.biometricsEnabled,
    required this.autoLockDuration,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
  }) : _primaryCurrencyCode = primaryCurrencyCode;

  static const singletonId = 1;

  final String userId;
  final String _primaryCurrencyCode;
  final String locale;
  final bool biometricsEnabled;
  final Duration? autoLockDuration;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get primaryCurrencyCode => _primaryCurrencyCode.toUpperCase();

  AppSettings copyWith({
    String? primaryCurrencyCode,
    String? locale,
    bool? biometricsEnabled,
    Duration? autoLockDuration,
    bool clearAutoLockDuration = false,
    bool? onboardingCompleted,
    DateTime? updatedAt,
  }) {
    return AppSettings(
      userId: userId,
      primaryCurrencyCode: primaryCurrencyCode ?? this.primaryCurrencyCode,
      locale: locale ?? this.locale,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      autoLockDuration:
          clearAutoLockDuration ? null : autoLockDuration ?? this.autoLockDuration,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettings &&
        other.userId == userId &&
        other.primaryCurrencyCode == primaryCurrencyCode &&
        other.locale == locale &&
        other.biometricsEnabled == biometricsEnabled &&
        other.autoLockDuration == autoLockDuration &&
        other.onboardingCompleted == onboardingCompleted &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        userId,
        primaryCurrencyCode,
        locale,
        biometricsEnabled,
        autoLockDuration,
        onboardingCompleted,
        createdAt,
        updatedAt,
      );
}
