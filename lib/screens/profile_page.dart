import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<UserProvider>(context, listen: false).profile;
    _nameController = TextEditingController(text: profile?.name ?? '');
    _contactController = TextEditingController(text: profile?.emergencyContact ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty || _contactController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields correctly'),
          backgroundColor: Color(0xFFE91E63),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    await Provider.of<UserProvider>(context, listen: false).saveProfile(
      name: _nameController.text.trim(),
      emergencyContact: _contactController.text.trim(),
    );

    setState(() {
      _isEditing = false;
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated ✓'),
          backgroundColor: Color(0xFF43A047),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final profile = userProvider.profile;

        return Scaffold(
          backgroundColor: const Color(0xFFFCE4EC),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE91E63),
            foregroundColor: Colors.white,
            title: const Text(
              'My Profile',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            actions: [
              if (!_isEditing)
                IconButton(
                  icon: const Icon(Icons.edit_rounded),
                  onPressed: () => setState(() => _isEditing = true),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Pink header section
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: Text(
                              profile != null && profile.name.isNotEmpty
                                  ? profile.name[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          profile?.name ?? 'No Name',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SheSafe Member',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Profile fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF880E4F),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Name
                        _buildField(
                          icon: Icons.person_outline,
                          label: 'Name',
                          controller: _nameController,
                          enabled: _isEditing,
                        ),
                        const SizedBox(height: 16),

                        // Emergency Contact
                        _buildField(
                          icon: Icons.phone_outlined,
                          label: 'Emergency Contact',
                          controller: _contactController,
                          enabled: _isEditing,
                          keyboardType: TextInputType.phone,
                        ),

                        if (_isEditing) ...[
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    _nameController.text = profile?.name ?? '';
                                    _contactController.text = profile?.emergencyContact ?? '';
                                    setState(() => _isEditing = false);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey[600],
                                    side: BorderSide(color: Colors.grey[300]!),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _isSaving ? null : _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE91E63),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                  ),
                                  child: _isSaving
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Emergency info card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE53935).withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Color(0xFFE53935), size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your emergency contact will receive a WhatsApp alert with your location when you press the SOS button.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildField({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool enabled,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: const Color(0xFFE91E63), size: 20),
        filled: true,
        fillColor: enabled
            ? const Color(0xFFFCE4EC).withOpacity(0.5)
            : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
