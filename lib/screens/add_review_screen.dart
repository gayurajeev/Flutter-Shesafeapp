import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/facility_provider.dart';

class AddReviewScreen extends StatefulWidget {
  final String facilityId;

  const AddReviewScreen({super.key, required this.facilityId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  bool? _isSafe;
  final Set<String> _selectedIssues = {};

  final List<String> _commonIssues = [
    'No Lock',
    'No Water',
    'Poor Lighting',
    'Dirty',
    'No Tissue',
    'Unsafe Area',
    'Creepy Vibe',
  ];

  void _submitReview() {
    if (_isSafe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select if it is safe or unsafe')),
      );
      return;
    }

    Provider.of<FacilityProvider>(context, listen: false).addReview(
      widget.facilityId,
      _isSafe!,
      _selectedIssues.toList(),
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thanks for keeping the community safe! 💜')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final facility = Provider.of<FacilityProvider>(context, listen: false)
        .getFacilityById(widget.facilityId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tag", style: TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE91E63)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Tagging ${facility.name}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(height: 32),
            
            const Text(
              "How was your experience?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSafe = true),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isSafe == true ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                        border: Border.all(
                          color: _isSafe == true ? Colors.green : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: _isSafe == true ? Colors.green : Colors.grey, size: 40),
                          const SizedBox(height: 8),
                          Text("Felt Safe", style: TextStyle(
                            color: _isSafe == true ? Colors.green : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _isSafe = false),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: _isSafe == false ? Colors.red.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                        border: Border.all(
                          color: _isSafe == false ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_rounded, color: _isSafe == false ? Colors.red : Colors.grey, size: 40),
                          const SizedBox(height: 8),
                          Text("Unsafe / Bad", style: TextStyle(
                            color: _isSafe == false ? Colors.red : Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            const Text(
              "Any specific issues? (Optional)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _commonIssues.map((issue) {
                final isSelected = _selectedIssues.contains(issue);
                return FilterChip(
                  label: Text(issue),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedIssues.add(issue);
                      } else {
                        _selectedIssues.remove(issue);
                      }
                    });
                  },
                  selectedColor: const Color(0xFFE91E63).withOpacity(0.2),
                  checkmarkColor: const Color(0xFFE91E63),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFFE91E63) : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  side: BorderSide.none,
                );
              }).toList(),
            ),
            
            const SizedBox(height: 48),
            
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Submit Tag",
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
    );
  }
}
