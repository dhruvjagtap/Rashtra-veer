import 'package:flutter/material.dart';

import 'widgets/header_section.dart';
import 'widgets/plan_section.dart';
import 'widgets/resources_section.dart';
import 'widgets/todays_task_section.dart';

/// Fitness app dashboard home screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: Column(
        children: [
          const HeaderSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 20, bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TodaysTaskSection(),
                  const SizedBox(height: 24),
                  const PlanSection(),
                  const SizedBox(height: 24),
                  const ResourcesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
