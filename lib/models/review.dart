class Review {
  final String id;
  final String facilityId;
  final bool isSafe;
  final List<String> issues;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.facilityId,
    required this.isSafe,
    this.issues = const [],
    required this.timestamp,
  });
}
