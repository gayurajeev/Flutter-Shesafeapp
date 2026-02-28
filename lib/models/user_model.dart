class UserProfile {
  final String name;
  final String emergencyContact; // phone number with country code
  final String? photoPath;

  UserProfile({
    required this.name,
    required this.emergencyContact,
    this.photoPath,
  });
}
