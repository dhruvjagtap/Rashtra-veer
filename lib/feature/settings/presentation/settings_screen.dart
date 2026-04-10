import 'package:flutter/material.dart';
import 'widgets/profile_tile.dart';
import 'widgets/setting_item.dart';
import 'widgets/logout_tile.dart';
import '../../profile/presentation/edit_profile_screen.dart';

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
          const SizedBox(height: 10),

          /// PROFILE
          const ProfileTile(),

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

          const SettingItem(
            icon: Icons.favorite,
            title: "Health & Preferences",
            subtitle: "Height, weight, goals",
            onTap: null,
          ),

          const SettingItem(
            icon: Icons.directions_run,
            title: "Activity & Tracking",
            subtitle: "GPS, activity settings",
            onTap: null,
          ),

          const SettingItem(
            icon: Icons.payment,
            title: "Subscription & Payments",
            subtitle: "Plans, transactions",
            onTap: null,
          ),

          const SettingItem(
            icon: Icons.verified,
            title: "Certificates",
            subtitle: "Upload & view certificates",
            onTap: null,
          ),

          const SettingItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            subtitle: "FAQs, contact support",
            onTap: null,
          ),

          const SizedBox(height: 20),

          const LogoutTile(),
        ],
      ),
    );
  }
}