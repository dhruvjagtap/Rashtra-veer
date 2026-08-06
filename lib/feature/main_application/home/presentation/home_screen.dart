import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/daily_task/data/models/daily_task_model.dart';
import 'package:rashtraveer/feature/daily_task/data/repositories/daily_task_repository.dart';
// import 'package:rashtraveer/feature/daily_task/data/services/daily_task_service.dart';

import 'widgets/header_section.dart';
import 'widgets/plan_section.dart';
import 'widgets/resources_section.dart';
import 'widgets/todays_task_section.dart';

/// Fitness app dashboard home screen.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with FirebaseAuth.instance.currentUser!.uid
    const String userId = "lTIpDPNQ41T5kM3x1HEbj66C1Dr1";

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      body: Column(
        children: [
          const HeaderSection(),

          Expanded(
            child: StreamBuilder<List<DailyTaskModel>>(
              stream: DailyTaskRepository().streamTodayTasks(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                final tasks = snapshot.data ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 20, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Today's Tasks (Now comes from Firestore)
                      TodaysTaskSection(tasks: tasks),

                      const SizedBox(height: 24),

                      const PlanSection(),

                      const SizedBox(height: 24),

                      const ResourcesSection(),
                    ],
                  ),
                );
              },
            ),
          ),

          // ===============================
          // Dummy Task Generation (Testing)
          // ===============================

          // ElevatedButton(
          //   onPressed: () async {
          //     final service = DailyTaskService();
          //
          //     await service.seedDummyTasks(
          //       userId: userId,
          //       trainerId: "trainer_demo",
          //     );
          //
          //     debugPrint("Dummy Tasks Created");
          //   },
          //   child: const Text("Generate Dummy Tasks"),
          // ),

          // ===============================
          // Fetch Today's Tasks (Testing)
          // ===============================

          // ElevatedButton(
          //   onPressed: () async {
          //     final service = DailyTaskService();
          //
          //     final tasks = await service.getTodayTasks(userId);
          //
          //     for (final task in tasks) {
          //       debugPrint(task.toString());
          //     }
          //   },
          //   child: const Text("Fetch Today's Tasks"),
          // ),
        ],
      ),
    );
  }
}
