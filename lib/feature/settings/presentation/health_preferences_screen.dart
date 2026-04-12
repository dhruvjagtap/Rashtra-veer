import 'package:flutter/material.dart';

class HealthPreferencesScreen extends StatefulWidget {
  static const String routeName = "/health-preferences";

  const HealthPreferencesScreen({super.key});

  @override
  State<HealthPreferencesScreen> createState() =>
      _HealthPreferencesScreenState();
}

class _HealthPreferencesScreenState
    extends State<HealthPreferencesScreen> {
  double height = 175; // cm
  double weight = 72; // kg
  int age = 22;

  String gender = "Male";
  String goal = "Weight Loss";
  String level = "Intermediate";
  String activityLevel = "Moderate";

  /// 🔥 BMI CALCULATION
  double get bmi => weight / ((height / 100) * (height / 100));

  String get bmiStatus {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  Color get bmiColor {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24.9) return Colors.green;
    if (bmi < 29.9) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      appBar: AppBar(
        title: const Text("Health & Preferences"),
        backgroundColor: const Color(0xFF6A66FF),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        children: [
          /// 🔹 BODY METRICS
          const _SectionTitle("Body Metrics"),

          _Tile(
            icon: Icons.height,
            title: "Height",
            value: "${height.toInt()} cm",
            onTap: () => _editNumber("Height (cm)", height, (val) {
              setState(() => height = val);
            }),
          ),

          _Tile(
            icon: Icons.monitor_weight,
            title: "Weight",
            value: "${weight.toInt()} kg",
            onTap: () => _editNumber("Weight (kg)", weight, (val) {
              setState(() => weight = val);
            }),
          ),

          /// 🔥 BMI INLINE
          _Tile(
            icon: Icons.favorite,
            title: "BMI",
            value:
                "${bmi.toStringAsFixed(1)} ($bmiStatus)",
            valueColor: bmiColor,
            onTap: () {},
          ),

          _Tile(
            icon: Icons.cake,
            title: "Age",
            value: age.toString(),
            onTap: () => _editNumber("Age", age.toDouble(), (val) {
              setState(() => age = val.toInt());
            }),
          ),

          _Tile(
            icon: Icons.people,
            title: "Gender",
            value: gender,
            onTap: () => _editOptions(
                ["Male", "Female", "Other"], gender, (val) {
              setState(() => gender = val);
            }),
          ),

          const Divider(),

          /// 🔹 FITNESS
          const _SectionTitle("Fitness Preferences"),

          _Tile(
            icon: Icons.flag,
            title: "Goal",
            value: goal,
            onTap: () => _editOptions(
                ["Weight Loss", "Muscle Gain", "Fitness"], goal,
                (val) {
              setState(() => goal = val);
            }),
          ),

          _Tile(
            icon: Icons.fitness_center,
            title: "Level",
            value: level,
            onTap: () => _editOptions(
                ["Beginner", "Intermediate", "Advanced"],
                level, (val) {
              setState(() => level = val);
            }),
          ),

          _Tile(
            icon: Icons.directions_run,
            title: "Activity Level",
            value: activityLevel,
            onTap: () => _editOptions(
                ["Low", "Moderate", "High"],
                activityLevel, (val) {
              setState(() => activityLevel = val);
            }),
          ),
        ],
      ),
    );
  }

  /// 🔥 NUMBER INPUT DIALOG
  void _editNumber(
      String title, double current, Function(double) onSave) {
    final controller =
        TextEditingController(text: current.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              double val = double.tryParse(controller.text) ?? current;
              onSave(val);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  /// 🔥 OPTIONS PICKER
  void _editOptions(List<String> options, String current,
      Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: options
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onSelect(e);
                  Navigator.pop(context);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
class _Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;
  final Color? valueColor;

  const _Tile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6A66FF)),
      title: Text(title),
      subtitle: Text(
        value,
        style: TextStyle(color: valueColor ?? Colors.black),
      ),
      trailing: const Icon(Icons.edit, size: 18),
      onTap: onTap,
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