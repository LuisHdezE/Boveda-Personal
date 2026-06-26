import 'package:collection/collection.dart';

enum BiometricAvailability {
  unavailable,
  notEnrolled,
  available,
  temporarilyLocked,
  permanentlyLocked,
}

enum BiometricKind { fingerprint, face, iris, strong, weak }

class BiometricStatus {
  factory BiometricStatus({
    required BiometricAvailability availability,
    Set<BiometricKind> supportedTypes = const {},
  }) {
    return BiometricStatus._(
      availability: availability,
      supportedTypes: Set.unmodifiable(supportedTypes),
    );
  }

  const BiometricStatus._({
    required this.availability,
    required this.supportedTypes,
  });

  final BiometricAvailability availability;
  final Set<BiometricKind> supportedTypes;

  bool get canAuthenticate =>
      availability == BiometricAvailability.available &&
      supportedTypes.isNotEmpty;

  bool get canEnroll =>
      availability == BiometricAvailability.notEnrolled ||
      availability == BiometricAvailability.available;

  @override
  bool operator ==(Object other) {
    return other is BiometricStatus &&
        other.availability == availability &&
        const SetEquality<BiometricKind>().equals(
          other.supportedTypes,
          supportedTypes,
        );
  }

  @override
  int get hashCode => Object.hash(
    availability,
    const SetEquality<BiometricKind>().hash(supportedTypes),
  );
}
