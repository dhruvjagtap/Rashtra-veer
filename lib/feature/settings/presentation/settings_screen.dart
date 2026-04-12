import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/profile/presentation/edit_profile_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/help_support_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/widgets/setting_item.dart';
import 'package:rashtraveer/feature/settings/presentation/widgets/logout_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rashtraveer/feature/auth/presentation/login_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/certificate_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/activity_settings_screen.dart';
import 'package:rashtraveer/feature/settings/presentation/health_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: const Color(0xFF6A66FF),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        children: [
          // const SizedBox(height: 10),

          /// PROFILE
          // const ProfileTile(),
          const SizedBox(height: 10),

          /// SETTINGS ITEMS
          SettingItem(
            icon: Icons.person,
            title: "Account",
            subtitle: "Edit profile, change number",
            onTap: () {
              Navigator.pushNamed(context, EditProfileScreen.routeName);
            },
          ),

          SettingItem(
            icon: Icons.favorite,
            title: "Health & Preferences",
            subtitle: "Height, weight, goals",
            onTap: () {
              Navigator.pushNamed(context, HealthPreferencesScreen .routeName);
            },
          ),

          SettingItem(
            icon: Icons.directions_run,
            title: "Activity & Tracking",
            subtitle: "GPS, activity settings",
            onTap: () {
              Navigator.pushNamed(context, ActivitySettingsScreen.routeName);
            },
          ),

          const SettingItem(
            icon: Icons.payment,
            title: "Subscription & Payments",
            subtitle: "Plans, transactions",
            onTap: null,
          ),

          SettingItem(
            icon: Icons.verified,
            title: "Certificates",
            subtitle: "Upload & view certificates",
            onTap: () {
              Navigator.pushNamed(context, CertificateScreen.routeName);
            },
          ),

          SettingItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "FAQs, contact support",
             onTap: () {
              Navigator.pushNamed(context, HelpSupportScreen.routeName);
            },
          ),

          const SizedBox(height: 20),

          LogoutTile(onTap: () => _showLogoutDialog(context)),
        ],
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Log Out',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6A66FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
          },
          child: const Text('Log Out', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );
}
