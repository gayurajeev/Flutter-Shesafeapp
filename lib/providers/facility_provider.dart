import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import '../models/facility.dart';
import '../models/review.dart';

class FacilityProvider with ChangeNotifier {
  final _uuid = const Uuid();

  bool isLoadingLocation = false;
  String locationStatus = '';
  String selectedArea = '';
  String selectedCategory = 'All';

  // User's known location (Trivandrum, Kerala) as fallback
  static const double _fallbackLat = 8.5468508;
  static const double _fallbackLng = 76.9073820;

  // Predefined TVM area coordinates
  static const Map<String, List<double>> _areaCoordinates = {
    'technopark': [8.5567, 76.8817],
    'kazhakkoottam': [8.5567, 76.8817],
    'kazhakoottam': [8.5567, 76.8817],
    'thampanoor': [8.4895, 76.9497],
    'east fort': [8.4875, 76.9525],
    'eastfort': [8.4875, 76.9525],
    'kovalam': [8.3995, 76.9787],
    'kowdiar': [8.5130, 76.9440],
    'pattom': [8.5250, 76.9360],
    'kesavadasapuram': [8.5190, 76.9290],
    'sreekaryam': [8.5420, 76.9080],
    'ulloor': [8.5350, 76.9150],
    'medical college': [8.5250, 76.9200],
    'palayam': [8.5050, 76.9540],
    'statue': [8.4970, 76.9500],
    'vellayambalam': [8.5100, 76.9510],
    'jagathy': [8.4940, 76.9440],
    'vazhuthacaud': [8.5020, 76.9540],
    'attingal': [8.6950, 76.8150],
    'neyyattinkara': [8.3996, 76.8460],
    'akkulam': [8.5450, 76.8900],
    'lulu mall': [8.5528, 76.8883],
    'shangumughom': [8.4895, 76.9085],
    'varkala': [8.7330, 76.7160],
    'trivandrum': [8.5241, 76.9366],
    'thiruvananthapuram': [8.5241, 76.9366],
    'tvm': [8.5241, 76.9366],
  };

  // All washrooms/facilities across TVM
  final List<Facility> _allFacilities = [
    // === Public Restrooms ===
    Facility(
      id: '1',
      name: 'Technopark Public Washroom',
      type: 'Public Restroom',
      address: 'Phase 1, Technopark, Kazhakkoottam',
      latitude: 8.5567,
      longitude: 76.8817,
      safeCount: 85,
      unsafeCount: 5,
      issueCounts: {'No Tissue': 3},
    ),
    Facility(
      id: '2',
      name: 'East Fort Bus Stand Toilet',
      type: 'Public Restroom',
      address: 'East Fort, Thiruvananthapuram',
      latitude: 8.4875,
      longitude: 76.9525,
      safeCount: 30,
      unsafeCount: 18,
      issueCounts: {'No Water': 8, 'Poor Lighting': 5, 'No Lock': 3},
    ),
    Facility(
      id: '3',
      name: 'KSRTC Bus Terminal Washroom',
      type: 'Bus Stand',
      address: 'Central Bus Station, Thampanoor',
      latitude: 8.4895,
      longitude: 76.9497,
      safeCount: 15,
      unsafeCount: 40,
      issueCounts: {'Dirty': 25, 'No Lock': 18, 'Poor Lighting': 12, 'No Water': 8},
    ),
    Facility(
      id: '4',
      name: 'Palayam Market Public Toilet',
      type: 'Public Restroom',
      address: 'Palayam Market, Trivandrum',
      latitude: 8.5045,
      longitude: 76.9540,
      safeCount: 12,
      unsafeCount: 22,
      issueCounts: {'Dirty': 15, 'No Lock': 10, 'Poor Lighting': 8},
    ),
    Facility(
      id: '5',
      name: 'Shangumughom Beach Restroom',
      type: 'Beach',
      address: 'Shangumughom Beach Rd, Trivandrum',
      latitude: 8.4895,
      longitude: 76.9085,
      safeCount: 10,
      unsafeCount: 8,
      issueCounts: {'Poor Lighting': 5, 'No Water': 3},
    ),
    Facility(
      id: '6',
      name: 'Kovalam Beach Restroom',
      type: 'Beach',
      address: 'Lighthouse Beach, Kovalam',
      latitude: 8.3995,
      longitude: 76.9787,
      safeCount: 20,
      unsafeCount: 35,
      issueCounts: {'Poor Lighting': 20, 'No Lock': 12, 'Dirty': 15},
    ),

    // === Hotels ===
    Facility(
      id: '7',
      name: 'Hotel Residency Tower Restroom',
      type: 'Hotel',
      address: 'Press Rd, Statue, Trivandrum',
      latitude: 8.4960,
      longitude: 76.9510,
      safeCount: 95,
      unsafeCount: 2,
      issueCounts: {},
    ),
    Facility(
      id: '8',
      name: 'Hilton Garden Inn Washroom',
      type: 'Hotel',
      address: 'Punnen Rd, Thampanoor',
      latitude: 8.4870,
      longitude: 76.9510,
      safeCount: 130,
      unsafeCount: 1,
      issueCounts: {},
    ),
    Facility(
      id: '9',
      name: 'Hotel Hycinth Ladies Room',
      type: 'Hotel',
      address: 'Manjalikulam Rd, Thampanoor',
      latitude: 8.4910,
      longitude: 76.9490,
      safeCount: 110,
      unsafeCount: 3,
      issueCounts: {'No Tissue': 1},
    ),
    Facility(
      id: '10',
      name: 'Uday Suites Restroom',
      type: 'Hotel',
      address: 'MG Road, Vellayambalam',
      latitude: 8.5080,
      longitude: 76.9510,
      safeCount: 70,
      unsafeCount: 5,
      issueCounts: {'No Tissue': 2},
    ),
    Facility(
      id: '11',
      name: 'Leela Raviz Hotel Restroom',
      type: 'Hotel',
      address: 'Kovalam Beach Rd, Kovalam',
      latitude: 8.3950,
      longitude: 76.9810,
      safeCount: 140,
      unsafeCount: 0,
      issueCounts: {},
    ),

    // === Petrol Pumps ===
    Facility(
      id: '12',
      name: 'Indian Oil - Pattom',
      type: 'Petrol Pump',
      address: 'Pattom Junction, Trivandrum',
      latitude: 8.5255,
      longitude: 76.9365,
      safeCount: 18,
      unsafeCount: 12,
      issueCounts: {'No Lock': 8, 'Dirty': 5},
    ),
    Facility(
      id: '13',
      name: 'HP Petrol Pump - Kazhakoottam',
      type: 'Petrol Pump',
      address: 'NH66, Kazhakkoottam',
      latitude: 8.5590,
      longitude: 76.8790,
      safeCount: 22,
      unsafeCount: 8,
      issueCounts: {'No Water': 3, 'Poor Lighting': 4},
    ),
    Facility(
      id: '14',
      name: 'BPCL Station - Kesavadasapuram',
      type: 'Petrol Pump',
      address: 'Kesavadasapuram Jn, Trivandrum',
      latitude: 8.5195,
      longitude: 76.9295,
      safeCount: 25,
      unsafeCount: 6,
      issueCounts: {'No Tissue': 3},
    ),
    Facility(
      id: '15',
      name: 'Indian Oil - Sreekaryam',
      type: 'Petrol Pump',
      address: 'Sreekaryam Jn, Trivandrum',
      latitude: 8.5430,
      longitude: 76.9075,
      safeCount: 14,
      unsafeCount: 10,
      issueCounts: {'Dirty': 6, 'No Lock': 4},
    ),

    // === Malls ===
    Facility(
      id: '16',
      name: 'Lulu Mall Ladies Restroom',
      type: 'Mall',
      address: 'Lulu Mall, Akkulam, Trivandrum',
      latitude: 8.5528,
      longitude: 76.8883,
      safeCount: 150,
      unsafeCount: 3,
      issueCounts: {'No Tissue': 2},
    ),
    Facility(
      id: '17',
      name: 'Mall of Travancore Washroom',
      type: 'Mall',
      address: 'Vazhuthacaud, Trivandrum',
      latitude: 8.5025,
      longitude: 76.9545,
      safeCount: 90,
      unsafeCount: 6,
      issueCounts: {'No Tissue': 3},
    ),
    Facility(
      id: '18',
      name: 'Spencer Junction Restroom',
      type: 'Mall',
      address: 'MG Road, Palayam',
      latitude: 8.5060,
      longitude: 76.9550,
      safeCount: 55,
      unsafeCount: 10,
      issueCounts: {'No Water': 3, 'Poor Lighting': 2},
    ),

    // === Hospitals ===
    Facility(
      id: '19',
      name: 'Medical College Hospital Washroom',
      type: 'Hospital',
      address: 'Medical College PO, Trivandrum',
      latitude: 8.5250,
      longitude: 76.9210,
      safeCount: 40,
      unsafeCount: 30,
      issueCounts: {'Dirty': 18, 'No Lock': 8, 'No Water': 5},
    ),
    Facility(
      id: '20',
      name: 'KIMS Hospital Restroom',
      type: 'Hospital',
      address: 'Anayara PO, Trivandrum',
      latitude: 8.4780,
      longitude: 76.9420,
      safeCount: 100,
      unsafeCount: 4,
      issueCounts: {'No Tissue': 2},
    ),
    Facility(
      id: '21',
      name: 'SUT Hospital Ladies Room',
      type: 'Hospital',
      address: 'Pattom, Trivandrum',
      latitude: 8.5240,
      longitude: 76.9340,
      safeCount: 80,
      unsafeCount: 8,
      issueCounts: {'No Tissue': 3, 'No Water': 2},
    ),

    // === Railway Station ===
    Facility(
      id: '22',
      name: 'TVC Railway Station Washroom',
      type: 'Public Restroom',
      address: 'Trivandrum Central, Thampanoor',
      latitude: 8.4890,
      longitude: 76.9510,
      safeCount: 20,
      unsafeCount: 25,
      issueCounts: {'Dirty': 15, 'No Lock': 10, 'Poor Lighting': 8},
    ),

    // === Additional Spots ===
    Facility(
      id: '23',
      name: 'Kowdiar Palace Park Restroom',
      type: 'Public Restroom',
      address: 'Kowdiar, Trivandrum',
      latitude: 8.5135,
      longitude: 76.9445,
      safeCount: 35,
      unsafeCount: 5,
      issueCounts: {'No Tissue': 2},
    ),
    Facility(
      id: '24',
      name: 'Varkala Cliff Restroom',
      type: 'Beach',
      address: 'North Cliff, Varkala',
      latitude: 8.7335,
      longitude: 76.7155,
      safeCount: 18,
      unsafeCount: 14,
      issueCounts: {'Poor Lighting': 8, 'No Water': 5, 'No Lock': 3},
    ),
  ];

  List<Facility> _filteredFacilities = [];
  final List<Review> _reviews = [];

  FacilityProvider() {
    _filteredFacilities = List.from(_allFacilities);
  }

  List<Facility> get facilities => _filteredFacilities;
  List<Review> get reviews => _reviews;

  Facility getFacilityById(String id) {
    return _allFacilities.firstWhere((f) => f.id == id);
  }

  // Search facilities by typed area name
  void searchByLocation(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      // Reset to show all, sorted from user's default location
      selectedArea = '';
      _filteredFacilities = List.from(_allFacilities);
      _calculateAndSort(_fallbackLat, _fallbackLng);
      _applyCategory();
      return;
    }

    // Find matching area
    List<double>? coords;
    for (var entry in _areaCoordinates.entries) {
      if (entry.key.contains(q) || q.contains(entry.key)) {
        coords = entry.value;
        selectedArea = entry.key[0].toUpperCase() + entry.key.substring(1);
        break;
      }
    }

    if (coords != null) {
      // Calculate distances from the searched area
      _filteredFacilities = List.from(_allFacilities);
      _calculateAndSort(coords[0], coords[1]);
      // Filter to within 5 km
      _filteredFacilities = _filteredFacilities
          .where((f) => f.distanceInMeters != null && f.distanceInMeters! <= 1000)
          .toList();
      _applyCategory();
      locationStatus = '📍 Showing near $selectedArea';
    } else {
      // Fallback: text search on name/address
      selectedArea = query.trim();
      _filteredFacilities = _allFacilities
          .where((f) =>
              f.name.toLowerCase().contains(q) ||
              f.address.toLowerCase().contains(q))
          .toList();
      _calculateAndSort(_fallbackLat, _fallbackLng);
      _applyCategory();
      locationStatus = '🔍 Search results for "$selectedArea"';
    }

    notifyListeners();
  }

  void filterByCategory(String category) {
    selectedCategory = category;
    // Re-run search to get unfiltered list, then apply category
    if (selectedArea.isEmpty) {
      _filteredFacilities = List.from(_allFacilities);
      _calculateAndSort(_fallbackLat, _fallbackLng);
    } else {
      searchByLocation(selectedArea);
      return; // searchByLocation already calls notifyListeners
    }
    _applyCategory();
    notifyListeners();
  }

  void _applyCategory() {
    if (selectedCategory != 'All') {
      _filteredFacilities = _filteredFacilities
          .where((f) => f.type == selectedCategory)
          .toList();
    }
  }

  Future<void> fetchUserLocationAndSort() async {
    isLoadingLocation = true;
    locationStatus = 'Checking permissions...';
    notifyListeners();

    double userLat = _fallbackLat;
    double userLng = _fallbackLng;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationStatus = '📍 Trivandrum';
        _calculateAndSort(userLat, userLng);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationStatus = '📍 Trivandrum';
          _calculateAndSort(userLat, userLng);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationStatus = '📍 Trivandrum';
        _calculateAndSort(userLat, userLng);
        return;
      }

      locationStatus = 'Getting current location...';
      notifyListeners();

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
        ),
      );
      userLat = position.latitude;
      userLng = position.longitude;
      locationStatus = '📍 Live location found';
    } catch (e) {
      locationStatus = '📍 Trivandrum';
    }

    _calculateAndSort(userLat, userLng);
  }

  void _calculateAndSort(double userLat, double userLng) {
    for (var facility in _filteredFacilities) {
      double distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        facility.latitude,
        facility.longitude,
      );
      facility.distanceInMeters = distance;
    }

    _filteredFacilities.sort((a, b) {
      if (a.distanceInMeters == null || b.distanceInMeters == null) return 0;
      return a.distanceInMeters!.compareTo(b.distanceInMeters!);
    });

    isLoadingLocation = false;
    notifyListeners();
  }

  void addReview(String facilityId, bool isSafe, List<String> issues) {
    final review = Review(
      id: _uuid.v4(),
      facilityId: facilityId,
      isSafe: isSafe,
      issues: issues,
      timestamp: DateTime.now(),
    );
    _reviews.add(review);

    // Update facility stats in all facilities
    final facilityIndex = _allFacilities.indexWhere((f) => f.id == facilityId);
    if (facilityIndex != -1) {
      final facility = _allFacilities[facilityIndex];
      
      final updatedIssueCounts = Map<String, int>.from(facility.issueCounts);
      for (var issue in issues) {
        updatedIssueCounts[issue] = (updatedIssueCounts[issue] ?? 0) + 1;
      }

      _allFacilities[facilityIndex] = Facility(
        id: facility.id,
        name: facility.name,
        type: facility.type,
        address: facility.address,
        latitude: facility.latitude,
        longitude: facility.longitude,
        distanceInMeters: facility.distanceInMeters,
        safeCount: facility.safeCount + (isSafe ? 1 : 0),
        unsafeCount: facility.unsafeCount + (isSafe ? 0 : 1),
        issueCounts: updatedIssueCounts,
      );

      // Also update in filtered list
      final filteredIndex = _filteredFacilities.indexWhere((f) => f.id == facilityId);
      if (filteredIndex != -1) {
        _filteredFacilities[filteredIndex] = _allFacilities[facilityIndex];
      }
      
      notifyListeners();
    }
  }
}
