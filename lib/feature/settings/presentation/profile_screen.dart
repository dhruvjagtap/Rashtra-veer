import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = "/profile";

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: const Color(0xFF6A66FF),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 PROFILE IMAGE
            Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: const Color(0xFF6A66FF),
                child: const Icon(Icons.person,
                    size: 40, color: Colors.white),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 PERSONAL INFO
            const Text(
              "Personal Info",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(
                  child: _DisplayCard(
                    label: "First Name",
                    value: "John",
                    icon: Icons.person,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _DisplayCard(
                    label: "Last Name",
                    value: "Doe",
                    icon: Icons.person,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const _DisplayCard(
              label: "Email",
              value: "johndoe@email.com",
              icon: Icons.email,
            ),

            const SizedBox(height: 12),

            const _DisplayCard(
              label: "Phone Number",
              value: "9876543210",
              icon: Icons.phone,
            ),

            const SizedBox(height: 12),

            const _DisplayCard(
              label: "Gender",
              value: "Male",
              icon: Icons.people,
            ),

            const SizedBox(height: 20),

            /// 🔹 HEALTH INFO
            const Text(
              "Health Info",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            Row(
              children: const [
                Expanded(
                  child: _DisplayCard(
                    label: "Height (cm)",
                    value: "175",
                    icon: Icons.height,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _DisplayCard(
                    label: "Weight (kg)",
                    value: "72",
                    icon: Icons.monitor_weight,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const _DisplayCard(
              label: "Blood Group",
              value: "O+",
              icon: Icons.bloodtype,
            ),

            const SizedBox(height: 20),

            /// 🔹 FITNESS INFO
            const Text(
              "Fitness Info",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 12),

            const _DisplayCard(
              label: "Goal",
              value: "Weight Loss",
              icon: Icons.flag,
            ),

            const SizedBox(height: 12),

            const _DisplayCard(
              label: "Level",
              value: "Intermediate",
              icon: Icons.fitness_center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DisplayCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DisplayCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A66FF)),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}