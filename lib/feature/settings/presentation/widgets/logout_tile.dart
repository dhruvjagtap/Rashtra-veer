import 'package:flutter/material.dart';

class LogoutTile extends StatelessWidget {
  final VoidCallback onTap;
  const LogoutTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text("Logout"),
      onTap: onTap,
    );
  }
}
