import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  static const String routeName = "/help-support";

  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: const Color(0xFF6A66FF),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 🔥 FAQ SECTION
          const Text(
            "FAQs",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          _FaqItem(
            question: "How do I start a workout?",
            answer: "Go to Home → select today's plan → start workout.",
          ),

          _FaqItem(
            question: "How is BMI calculated?",
            answer:
                "BMI is calculated using your height and weight during onboarding.",
          ),

          _FaqItem(
            question: "How to upload certificate?",
            answer:
                "Go to Certificates → Upload → select file and submit.",
          ),

          _FaqItem(
            question: "How do I contact a coach?",
            answer:
                "Use the chat feature from home screen to connect with experts.",
          ),

          const SizedBox(height: 30),

          /// 🔥 CONTACT SUPPORT
          const Text(
            "Contact Support",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          _ContactTile(
            icon: Icons.email,
            title: "Email Support",
            subtitle: "support@rashtraveer.com",
          ),

          _ContactTile(
            icon: Icons.phone,
            title: "Call Support",
            subtitle: "+91 9876543210",
          ),

          _ContactTile(
            icon: Icons.chat,
            title: "Live Chat",
            subtitle: "Chat with our support team",
          ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(question),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(answer),
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6A66FF)),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {
        // TODO: add actions (email / call / chat)
      },
    );
  }
}