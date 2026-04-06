import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF7F7BFF);

  late TabController _tabController;

  final List<_Resource> _workouts = [
    _Resource(title: 'Full Body Warmup', subtitle: '10 min • Beginner', icon: Icons.directions_run_rounded),
    _Resource(title: 'Fat Burn Circuit', subtitle: '20 min • Intermediate', icon: Icons.local_fire_department_rounded),
    _Resource(title: 'Core Strength', subtitle: '15 min • Intermediate', icon: Icons.fitness_center_rounded),
    _Resource(title: 'Yoga Recovery', subtitle: '12 min • All levels', icon: Icons.self_improvement_rounded),
    _Resource(title: 'HIIT Challenge', subtitle: '25 min • Advanced', icon: Icons.bolt_rounded),
  ];

  final List<_Resource> _diet = [
    _Resource(title: 'Keto Meal Plan', subtitle: 'High fat • Low carb', icon: Icons.restaurant_rounded),
    _Resource(title: 'Protein Guide', subtitle: 'Post-workout nutrition', icon: Icons.egg_alt_rounded),
    _Resource(title: 'Intermittent Fasting', subtitle: '16:8 method explained', icon: Icons.access_time_rounded),
    _Resource(title: 'Hydration Tracker', subtitle: 'Daily water goals', icon: Icons.water_drop_rounded),
  ];

  final List<_Resource> _meditation = [
    _Resource(title: 'Morning Breathing', subtitle: '5 min • Energizing', icon: Icons.air_rounded),
    _Resource(title: 'Sleep Meditation', subtitle: '15 min • Calming', icon: Icons.bedtime_rounded),
    _Resource(title: 'Focus Session', subtitle: '10 min • Clarity', icon: Icons.psychology_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF8),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Resources',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF21212E),
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: _primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Workout'),
            Tab(text: 'Diet'),
            Tab(text: 'Meditation'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ResourceList(items: _workouts),
          _ResourceList(items: _diet),
          _ResourceList(items: _meditation),
        ],
      ),
    );
  }
}

class _ResourceList extends StatelessWidget {
  const _ResourceList({required this.items});

  final List<_Resource> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: items.length,
      itemBuilder: (context, index) => _ResourceCard(resource: items[index]),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  const _ResourceCard({required this.resource});

  final _Resource resource;

  static const Color _primary = Color(0xFF7F7BFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(resource.icon, color: _primary, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  resource.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: _primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_arrow_rounded, color: _primary, size: 18),
          ),
        ],
      ),
    );
  }
}

class _Resource {
  const _Resource({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}