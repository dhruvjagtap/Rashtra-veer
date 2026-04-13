// Pure Dart — no Flutter imports, so this file causes zero ambiguity
// when imported alongside any widget file.

/// A single chat entry (works for both 1-on-1 and group chats).
class ChatEntry {
  ChatEntry({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.isGroup,
    this.unreadCount = 0,
    this.memberCount = 0,
  });

  final String id;
  final String name;
  String lastMessage;
  String timeLabel;
  final bool isGroup;
  int unreadCount;
  final int memberCount;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }
}

/// Lightweight observable store — no Flutter dependency at all.
/// ChatHomeScreen subscribes via addListener() in initState().
class ChatStore {
  ChatStore() {
    _seedInitialData();
  }

  final List<ChatEntry> _chats = [];
  final List<ChatEntry> _groups = [];
  final List<void Function()> _listeners = [];

  List<ChatEntry> get chats => List.unmodifiable(_chats);
  List<ChatEntry> get groups => List.unmodifiable(_groups);

  void addListener(void Function() cb) => _listeners.add(cb);
  void removeListener(void Function() cb) => _listeners.remove(cb);
  void dispose() => _listeners.clear();

  void _notify() {
    for (final cb in List.of(_listeners)) {
      cb();
    }
  }

  /// Adds a new group to the top of the groups list and notifies listeners.
  void addGroup({required String name, required int memberCount}) {
    _groups.insert(
      0,
      ChatEntry(
        id: 'g_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        lastMessage: 'Group created',
        timeLabel: _nowLabel(),
        isGroup: true,
        memberCount: memberCount,
      ),
    );
    _notify();
  }

  void _seedInitialData() {
    _chats.addAll([
      ChatEntry(
        id: 'c1',
        name: 'Coach Vikram Singh',
        lastMessage: 'Your macro ratios look perfect today.',
        timeLabel: '12:45 PM',
        isGroup: false,
        unreadCount: 2,
      ),
      ChatEntry(
        id: 'c2',
        name: 'Dr. Ananya Iyer',
        lastMessage: 'The inflammation test results are in.',
        timeLabel: '10:20 AM',
        isGroup: false,
      ),
      ChatEntry(
        id: 'c3',
        name: 'Rohan (Team Alpha)',
        lastMessage: 'Shared the morning run stats in the group.',
        timeLabel: 'Yesterday',
        isGroup: false,
      ),
      ChatEntry(
        id: 'c4',
        name: 'Neha Wellness',
        lastMessage: 'Remember your mobility drills this evening.',
        timeLabel: 'Mon',
        isGroup: false,
        unreadCount: 1,
      ),
      ChatEntry(
        id: 'c5',
        name: 'Nutrition Desk',
        lastMessage: 'New meal template uploaded for this week.',
        timeLabel: 'Wed',
        isGroup: false,
        unreadCount: 3,
      ),
    ]);

    _groups.addAll([
      ChatEntry(
        id: 'g1',
        name: 'Weekend Warriors',
        lastMessage: 'Ready for Saturday hike? Confirm your slot.',
        timeLabel: 'Tue',
        isGroup: true,
        memberCount: 8,
      ),
    ]);
  }

  String _nowLabel() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }
}