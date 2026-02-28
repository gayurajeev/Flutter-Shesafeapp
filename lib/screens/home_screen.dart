import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/facility_provider.dart';
import '../providers/user_provider.dart';
import '../models/facility.dart';
import 'facility_detail_screen.dart';
import 'profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _categories = [
    'All',
    'Hotel',
    'Petrol Pump',
    'Public Restroom',
    'Mall',
    'Hospital',
    'Bus Stand',
    'Beach',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FacilityProvider>(context, listen: false).fetchUserLocationAndSort();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getCategoryStyle(String type) {
    switch (type) {
      case 'Hotel':
        return {'icon': Icons.hotel, 'color': const Color(0xFF1565C0), 'bg': const Color(0xFFE3F2FD)};
      case 'Petrol Pump':
        return {'icon': Icons.local_gas_station, 'color': const Color(0xFFE65100), 'bg': const Color(0xFFFFF3E0)};
      case 'Mall':
        return {'icon': Icons.shopping_bag, 'color': const Color(0xFF7B1FA2), 'bg': const Color(0xFFF3E5F5)};
      case 'Hospital':
        return {'icon': Icons.local_hospital, 'color': const Color(0xFF2E7D32), 'bg': const Color(0xFFE8F5E9)};
      case 'Bus Stand':
        return {'icon': Icons.directions_bus, 'color': const Color(0xFFF9A825), 'bg': const Color(0xFFFFFDE7)};
      case 'Beach':
        return {'icon': Icons.beach_access, 'color': const Color(0xFF00838F), 'bg': const Color(0xFFE0F7FA)};
      default:
        return {'icon': Icons.wc, 'color': const Color(0xFFD81B60), 'bg': const Color(0xFFFCE4EC)};
    }
  }

  Future<void> _triggerSOS(Facility facility) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final profile = userProvider.profile;

    if (profile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set up your profile with an emergency contact first.'),
          backgroundColor: Color(0xFFE53935),
        ),
      );
      return;
    }

    // Confirm dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Color(0xFFE53935), size: 28),
            const SizedBox(width: 8),
            const Text('Send SOS Alert?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'This will open WhatsApp and send an emergency message to ${profile.emergencyContact} with your current location.',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final phone = profile.emergencyContact;
    final locationUrl = 'https://maps.google.com/?q=${facility.latitude},${facility.longitude}';
    final message = Uri.encodeComponent(
      '🚨 I need help! I\'m near ${facility.name}, ${facility.address}.\n\nMy location: $locationUrl',
    );
    final whatsappUrl = 'https://wa.me/$phone?text=$message';

    final uri = Uri.parse(whatsappUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not open WhatsApp. Please check if it\'s installed.'),
            backgroundColor: Color(0xFFE53935),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FacilityProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFFE91E63),
            actions: [
              // Profile icon
              IconButton(
                icon: const Icon(Icons.person_rounded, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                "SheSafe · TVM",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF48FB1), Color(0xFFC2185B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      top: -20,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      right: 50,
                      bottom: -40,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white.withOpacity(0.05),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 16.0, right: 60.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Hello,\nFind safe spaces nearby 💜",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                            if (provider.isLoadingLocation)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                                ),
                              )
                            else if (provider.locationStatus.isNotEmpty)
                              Flexible(
                                child: Text(
                                  provider.locationStatus,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    provider.searchByLocation(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search area... (e.g. Technopark, Kovalam)',
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFE91E63)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              provider.searchByLocation('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
          ),

          // Category Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = provider.selectedCategory == cat;
                  final style = _getCategoryStyle(cat);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      selected: isSelected,
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (cat != 'All')
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                style['icon'] as IconData,
                                size: 14,
                                color: isSelected ? Colors.white : style['color'] as Color,
                              ),
                            ),
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF555555),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.white,
                      selectedColor: const Color(0xFFE91E63),
                      checkmarkColor: Colors.white,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? const Color(0xFFE91E63) : Colors.grey.shade300,
                        ),
                      ),
                      onSelected: (_) {
                        provider.filterByCategory(cat);
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          // Results count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                provider.selectedArea.isNotEmpty
                    ? '${provider.facilities.length} washrooms near ${provider.selectedArea}'
                    : '${provider.facilities.length} washrooms in Trivandrum',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Facility List
          Consumer<FacilityProvider>(
            builder: (context, provider, child) {
              final facilities = provider.facilities;

              if (facilities.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 12),
                        Text(
                          "No washrooms found nearby.",
                          style: TextStyle(color: Colors.grey[500], fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Try a different area or category.",
                          style: TextStyle(color: Colors.grey[400], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildFacilityCard(context, facilities[index]);
                    },
                    childCount: facilities.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityCard(BuildContext context, Facility facility) {
    final score = facility.safetyScore;
    Color scoreColor = const Color(0xFFE53935);
    Color lightScoreColor = const Color(0xFFFFEBEE);
    String statusText = "Unsafe";

    if (score >= 80) {
      scoreColor = const Color(0xFF43A047);
      lightScoreColor = const Color(0xFFE8F5E9);
      statusText = "Safe";
    } else if (score >= 50) {
      scoreColor = const Color(0xFFFB8C00);
      lightScoreColor = const Color(0xFFFFF3E0);
      statusText = "Moderate";
    }

    int totalIssues = facility.issueCounts.values.fold(0, (sum, count) => sum + count);
    final catStyle = _getCategoryStyle(facility.type);

    String distanceText = '';
    if (facility.distanceInMeters != null) {
      if (facility.distanceInMeters! < 1000) {
        distanceText = '${facility.distanceInMeters!.toInt()} m away';
      } else {
        distanceText = '${(facility.distanceInMeters! / 1000).toStringAsFixed(1)} km away';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FacilityDetailScreen(facilityId: facility.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score Indicator
                Container(
                  width: 65,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: lightScoreColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: scoreColor.withOpacity(0.3), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${score.toInt()}%",
                        style: TextStyle(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        statusText,
                        style: TextStyle(
                          color: scoreColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        facility.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2C3E50),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 13, color: Colors.grey[500]),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              facility.address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      if (distanceText.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Row(
                            children: [
                              Icon(Icons.directions_walk, size: 13, color: Colors.grey[400]),
                              const SizedBox(width: 3),
                              Text(
                                distanceText,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Bottom row: type pill + issues + SOS button
                      Row(
                        children: [
                          // Type pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: catStyle['bg'] as Color,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  catStyle['icon'] as IconData,
                                  size: 11,
                                  color: catStyle['color'] as Color,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  facility.type,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: catStyle['color'] as Color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Issues
                          if (totalIssues > 0)
                            Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, size: 13, color: Colors.orange),
                                const SizedBox(width: 3),
                                Text(
                                  "$totalIssues issues",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          else
                            const Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 13, color: Colors.green),
                                SizedBox(width: 3),
                                Text(
                                  "Clean",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                          const Spacer(),

                          // 🚨 SOS Button
                          SizedBox(
                            height: 32,
                            child: ElevatedButton.icon(
                              onPressed: () => _triggerSOS(facility),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935),
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shadowColor: const Color(0xFFE53935).withOpacity(0.4),
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.sos_rounded, size: 14),
                              label: const Text(
                                'SOS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
