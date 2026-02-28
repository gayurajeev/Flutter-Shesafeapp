import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _saveAndContinue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    await Provider.of<UserProvider>(context, listen: false).saveProfile(
      name: _nameController.text.trim(),
      emergencyContact: _contactController.text.trim(),
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF48FB1).withOpacity(0.25),
                    spreadRadius: 4,
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar Icon
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE4EC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add_rounded,
                        size: 48,
                        color: Color(0xFFE91E63),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      "Set Up Your Profile",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF880E4F),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Add an emergency contact who can be\nalerted when you need help",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFAD1457),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFFE91E63)),
                        filled: true,
                        fillColor: const Color(0xFFFCE4EC).withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Emergency Contact Field
                    TextFormField(
                      controller: _contactController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Emergency Contact (with country code)',
                        hintText: 'e.g. 919876543210',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                        prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFFE91E63)),
                        filled: true,
                        fillColor: const Color(0xFFFCE4EC).withOpacity(0.5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 1.5),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an emergency contact number';
                        }
                        if (value.trim().length < 10) {
                          return 'Enter a valid phone number with country code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveAndContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shadowColor: const Color(0xFFE91E63).withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                "Save & Continue",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
