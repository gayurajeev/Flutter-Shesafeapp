import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/facility_provider.dart';
import 'add_review_screen.dart';

class FacilityDetailScreen extends StatelessWidget {
  final String facilityId;

  const FacilityDetailScreen({super.key, required this.facilityId});

  @override
  Widget build(BuildContext context) {
    // Listen to changes so the detail screen updates when a review is added
    final provider = Provider.of<FacilityProvider>(context);
    final facility = provider.getFacilityById(facilityId);

    final score = facility.safetyScore;
    Color scoreColor = Colors.red;
    if (score >= 80) scoreColor = Colors.green;
    else if (score >= 50) scoreColor = Colors.orange;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE91E63)),
        title: const Text(
          "Details",
          style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Image/Hero
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withOpacity(0.05),
              ),
              child: Center(
                child: Icon(
                  Icons.wash, // Washroom icon roughly
                  size: 80,
                  color: const Color(0xFFE91E63).withOpacity(0.3),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              facility.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              facility.address,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Score Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: scoreColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: scoreColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "${score.toInt()}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Safe",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Stats overview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn("Total tags", facility.totalReviews.toString()),
                      _buildStatColumn("Marked safe", facility.safeCount.toString(), color: Colors.green),
                      _buildStatColumn("Marked unsafe", facility.unsafeCount.toString(), color: Colors.red),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  const Text(
                    "Flagged Issues",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (facility.issueCounts.isEmpty)
                    const Text("No issues flagged yet.", style: TextStyle(color: Colors.grey))
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: facility.issueCounts.entries.map((entry) {
                        return Chip(
                          label: Text("${entry.key} (${entry.value})"),
                          backgroundColor: Colors.red.withOpacity(0.1),
                          labelStyle: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        );
                      }).toList(),
                    ),
                    
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddReviewScreen(facilityId: facility.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Add a Tag",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, {Color color = Colors.black87}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
