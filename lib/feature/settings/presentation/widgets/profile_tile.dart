import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/settings/presentation/profile_screen.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Color(0xFF6A66FF),
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: const Text("John Doe"),
      subtitle: const Text("Stay consistent"),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),

      onTap: () {
        Navigator.pushNamed(context, ProfileScreen.routeName);
      },
    );
  }
}
