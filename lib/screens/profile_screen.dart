import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:green_stack/constants/colors.dart';
import '../services/auth_service.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userId = '';
  String mobile = '';
  String userType = 'user';
  String name = 'User Name';
  String email = 'user@example.com';
  String profileUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? 'N/A';
      mobile = prefs.getString('mobile') ?? 'N/A';
      userType = prefs.getString('userType') ?? 'user';
      name = prefs.getString('name') ?? 'User Name';
      email = prefs.getString('email') ?? 'user@example.com';
      profileUrl = prefs.getString('profileUrl') ?? '';
    });
  }

  Future<void> _toggleUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final newType = userType == 'user' ? 'farmer' : 'user';
    await prefs.setString('userType', newType);
    setState(() {
      userType = newType;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Switched to $newType mode')));
  }

  Future<void> _handleLogout() async {
    await AuthService.logoutUser();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/join', (route) => false);
  }

  void _goToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          name: name,
          email: email,
          mobile: mobile,
          profileUrl: profileUrl,
        ),
      ),
    );

    if (result == true) {
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = profileUrl.isNotEmpty && File(profileUrl).existsSync()
        ? FileImage(File(profileUrl))
        : const AssetImage('images/default_profile.png') as ImageProvider;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Header with Gradient and Avatar
          Stack(
            children: [
              Container(
                height: 180,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.paleGreen,
                      Color.fromARGB(255, 221, 223, 225),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                bottom: -40,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageProvider,
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Name & Email
          Text(
            name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(email, style: const TextStyle(fontSize: 15, color: Colors.grey)),
          const SizedBox(height: 20),

          // Info Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    _infoTile(Icons.phone, 'Mobile', mobile),
                    const Divider(),
                    _infoTile(Icons.badge, 'User ID', userId),
                    const Divider(),
                    _infoTile(
                      Icons.verified_user,
                      'Current Mode',
                      userType.toUpperCase(),
                      valueColor: userType == 'user'
                          ? const Color.fromARGB(255, 48, 128, 70)
                          : Colors.green,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _toggleUserType,
                      icon: const Icon(
                        Icons.switch_account,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Switch to ${userType == 'user' ? 'Farmer' : 'User'} Mode",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Edit & Logout Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _goToEditProfile,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[700],
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  onPressed: _handleLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey[700]),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.black,
          ),
        ),
      ],
    );
  }
}
