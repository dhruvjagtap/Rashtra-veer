import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/onboarding/presentation/on_boarding_screen3.dart';
import 'package:rashtraveer/feature/onboarding/widgets/top_section.dart';

class OnBoardingScreen2 extends StatefulWidget {
  static const routeName = '/onBoardingScreen2';
  const OnBoardingScreen2({super.key});

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingSreen2State();
}

class _OnBoardingSreen2State extends State<OnBoardingScreen2> {
  bool hasDisease = false;
  String selectedDisease = "";
  TextEditingController otherController = TextEditingController();

  bool isValid() {
    if (!hasDisease) return true;
    if (selectedDisease.isEmpty) return false;
    if (selectedDisease == "Other" && otherController.text.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: SafeArea(
        child: Column(
          children: [
            const TopSection(),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildContent(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: isValid() ? _handleNext : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text("Next"),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Do you have any medical condition?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildYesNoButton("Yes", true)),
              const SizedBox(width: 10),
              Expanded(child: _buildYesNoButton("No", false)),
            ],
          ),

          const SizedBox(height: 20),

          if (hasDisease) ...[
            _buildDiseaseOption("Cancer"),
            _buildDiseaseOption("Diabetes"),
            _buildDiseaseOption("Other"),

            if (selectedDisease == "Other")
              TextField(
                controller: otherController,
                decoration: const InputDecoration(hintText: "Specify disease"),
              ),

            const SizedBox(height: 20),

            _buildUploadSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildYesNoButton(String text, bool value) {
    final isSelected = hasDisease == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          hasDisease = value;
          selectedDisease = "";
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.2),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseOption(String type) {
    final isSelected = selectedDisease == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDisease = type;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 10),
            Text(type),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Fitness Certificate",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: () {
            // file picker later
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 30),
                  SizedBox(height: 8),
                  Text("Upload PDF or Image"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleNext() {
    if (hasDisease && selectedDisease.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a disease")));
      return;
    }

    if (hasDisease &&
        selectedDisease == "Other" &&
        otherController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please specify disease")));
      return;
    }
    // Handle Certificate Upload
    // Navigate next
    Navigator.pushNamed(context, OnBoardingScreen3.routeName);
  }
}
