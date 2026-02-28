class Facility {
  final String id;
  final String name;
  final String type; // e.g. Washroom
  final String address;
  final double latitude;
  final double longitude;
  double? distanceInMeters;

  final int safeCount;
  final int unsafeCount;
  final Map<String, int> issueCounts;

  Facility({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.distanceInMeters,
    this.safeCount = 0,
    this.unsafeCount = 0,
    this.issueCounts = const {},
  });

  int get totalReviews => safeCount + unsafeCount;

  // Score from 0.0 to 100.0
  double get safetyScore {
    if (totalReviews == 0) return 0.0;
    return (safeCount / totalReviews) * 100;
  }
}
