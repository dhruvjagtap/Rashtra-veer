import 'package:flutter/material.dart';

class ActivitySettingsScreen extends StatefulWidget {
  static const String routeName = "/activity-settings";

  const ActivitySettingsScreen({super.key});

  @override
  State<ActivitySettingsScreen> createState() =>
      _ActivitySettingsScreenState();
}

class _ActivitySettingsScreenState
    extends State<ActivitySettingsScreen> {
  bool backgroundTracking = false;
  bool highAccuracy = true;
  bool autoTracking = false;
  bool reminders = true;

  String unit = "KM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Activity & Tracking"),
        backgroundColor: const Color(0xFF6A66FF),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        children: [
          /// 🔥 GPS SECTION
          const _SectionTitle("GPS Settings"),

          SwitchListTile(
            title: const Text("High Accuracy Mode"),
            subtitle:
                const Text("Better tracking but uses more battery"),
            value: highAccuracy,
            onChanged: (val) =>
                setState(() => highAccuracy = val),
          ),

          SwitchListTile(
            title: const Text("Background Tracking"),
            subtitle:
                const Text("Track activity even when app is closed"),
            value: backgroundTracking,
            onChanged: (val) =>
                setState(() => backgroundTracking = val),
          ),

          const Divider(),

          /// 🔥 ACTIVITY SETTINGS
          const _SectionTitle("Activity Preferences"),

          SwitchListTile(
            title: const Text("Auto Tracking"),
            subtitle: const Text("Automatically detect activity"),
            value: autoTracking,
            onChanged: (val) =>
                setState(() => autoTracking = val),
          ),

          ListTile(
            leading: const Icon(Icons.straighten,
                color: Color(0xFF6A66FF)),
            title: const Text("Units"),
            subtitle: Text(unit),
            trailing: const Icon(Icons.arrow_drop_down),
            onTap: () {
              setState(() {
                unit = unit == "KM" ? "Miles" : "KM";
              });
            },
          ),

          ListTile(
            leading: const Icon(Icons.flag,
                color: Color(0xFF6A66FF)),
            title: const Text("Daily Goal"),
            subtitle: const Text("10,000 steps"),
            trailing:
                const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // later → open goal setting screen
            },
          ),

          const Divider(),

          /// 🔥 NOTIFICATIONS
          const _SectionTitle("Notifications"),

          SwitchListTile(
            title: const Text("Activity Reminders"),
            subtitle:
                const Text("Get reminders to stay active"),
            value: reminders,
            onChanged: (val) =>
                setState(() => reminders = val),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}