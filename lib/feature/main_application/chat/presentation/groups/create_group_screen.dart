import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CreateGroupScreen
//
// A two-step "Create Group" flow:
//   Step 1 – Pick members from a contact list
//   Step 2 – Set the group name and confirm
//
// HOW TO USE
// ──────────
// Navigate to this screen from ChatHomeScreen's FAB (or wherever you like):
//
//   final result = await Navigator.push<_GroupResult>(
//     context,
//     MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
//   );
//   if (result != null && context.mounted) {
//     // result.name  → group name string
//     // result.members → List<GroupContact> chosen by the user
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ChatScreen(
//           title: result.name,
//           subtitle: '${result.members.length} members',
//           isGroup: true,
//         ),
//       ),
//     );
//   }
//
// THREAD-SAFETY NOTE
// ──────────────────
// All setState() calls in this file are guarded with `if (!mounted) return;`
// so they are safe even if an async gap occurs before the callback fires.
// No Isolates or compute() calls are used — all work stays on the main thread,
// which is correct for purely UI state like this.
// ─────────────────────────────────────────────────────────────────────────────

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  // ── Design tokens (matches the rest of the app) ───────────────────────────
  static const Color _primary = Color(0xFF5F55E7);
  static const Color _primaryLight = Color(0xFFE9E7FF);
  static const Color _screenBg = Color(0xFFFAFAF8);
  static const Color _textDark = Color(0xFF1E1E2F);

  // ── Step tracking ─────────────────────────────────────────────────────────
  int _step = 1; // 1 = pick members, 2 = name the group

  // ── Step-1 state ──────────────────────────────────────────────────────────
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<GroupContact> _selected = {};

  // Dummy contact list — replace with real data / repository call
  final List<GroupContact> _allContacts = const [
    GroupContact(id: '1', name: 'Coach Vikram Singh'),
    GroupContact(id: '2', name: 'Dr. Ananya Iyer'),
    GroupContact(id: '3', name: 'Rohan Sharma'),
    GroupContact(id: '4', name: 'Neha Patil'),
    GroupContact(id: '5', name: 'Neha Wellness'),
    GroupContact(id: '6', name: 'Nutrition Desk'),
    GroupContact(id: '7', name: 'Arjun Mehta'),
    GroupContact(id: '8', name: 'Priya Kapoor'),
    GroupContact(id: '9', name: 'Siddharth Rao'),
  ];

  // ── Step-2 state ──────────────────────────────────────────────────────────
  final TextEditingController _groupNameController = TextEditingController();
  final FocusNode _groupNameFocus = FocusNode();
  bool _isCreating = false; // guard for async gap (see thread-safety note)

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      // Guard: only call setState if still mounted
      if (!mounted) return;
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _groupNameController.dispose();
    _groupNameFocus.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  List<GroupContact> get _filteredContacts => _allContacts
      .where((c) => c.name.toLowerCase().contains(_searchQuery))
      .toList();

  void _toggleContact(GroupContact contact) {
    setState(() {
      if (_selected.contains(contact)) {
        _selected.remove(contact);
      } else {
        _selected.add(contact);
      }
    });
  }

  void _goToStep2() {
    if (_selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select at least one member to continue.')),
      );
      return;
    }
    setState(() => _step = 2);
    // Auto-focus the name field after the frame is drawn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _groupNameFocus.requestFocus();
    });
  }

  /// Simulates a "create group" async operation (e.g. Firestore write).
  /// Key pattern: capture `mounted` BEFORE the await, then check AFTER.
  Future<void> _createGroup() async {
    final name = _groupNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name.')),
      );
      return;
    }

    // ── Enter loading state ────────────────────────────────────────────────
    setState(() => _isCreating = true);

    try {
      // TODO: replace with your actual backend call, e.g.:
      // await FirebaseFirestore.instance.collection('groups').add({...});
      await Future.delayed(const Duration(milliseconds: 600)); // simulate network

      // ── IMPORTANT: check mounted AFTER every await ─────────────────────
      // This is the fix for the "single core / thread" crash you were seeing.
      // Without this guard, setState() is called on a widget that has already
      // been removed from the tree, which triggers:
      //   "setState() called after dispose()" → crash.
      if (!mounted) return;

      setState(() => _isCreating = false);

      // Pop and return the result to the caller (ChatHomeScreen)
      Navigator.pop(
        context,
        GroupResult(
          name: name,
          members: _selected.toList(),
        ),
      );
    } catch (e) {
      if (!mounted) return; // same guard after catch
      setState(() => _isCreating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create group: $e')),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _screenBg,
      appBar: _buildAppBar(context),
      body: _step == 1 ? _buildStep1() : _buildStep2(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: _screenBg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: 40,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        color: _textDark,
        onPressed: () {
          if (_step == 2) {
            // Go back to step 1 instead of popping entirely
            setState(() => _step = 1);
          } else {
            Navigator.pop(context);
          }
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _step == 1 ? 'Add Members' : 'Name Your Group',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          Text(
            'Step $_step of 2',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
          ),
        ],
      ),
      actions: [
        if (_step == 1)
          TextButton(
            onPressed: _selected.isEmpty ? null : _goToStep2,
            child: Text(
              'Next',
              style: TextStyle(
                color: _selected.isEmpty ? Colors.black38 : _primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STEP 1 — Pick members
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStep1() {
    final theme = Theme.of(context);

    return Column(
      children: [
        // ── Selected chips strip ───────────────────────────────────────────
        if (_selected.isNotEmpty)
          Container(
            height: 64,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: _selected.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final contact = _selected.elementAt(index);
                return _SelectedChip(
                  contact: contact,
                  primary: _primary,
                  primaryLight: _primaryLight,
                  onRemove: () => _toggleContact(contact),
                );
              },
            ),
          ),

        // ── Search bar ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F3F6),
              borderRadius: BorderRadius.circular(23),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search contacts…',
                hintStyle: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.black38),
                prefixIcon:
                const Icon(Icons.search_rounded, color: Colors.black38),
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
        ),

        // ── Contact list ──────────────────────────────────────────────────
        Expanded(
          child: _filteredContacts.isEmpty
              ? Center(
            child: Text(
              'No contacts found.',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: Colors.black38),
            ),
          )
              : ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: _filteredContacts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final contact = _filteredContacts[index];
              final isSelected = _selected.contains(contact);
              return _ContactTile2(
                contact: contact,
                isSelected: isSelected,
                primary: _primary,
                primaryLight: _primaryLight,
                onTap: () => _toggleContact(contact),
              );
            },
          ),
        ),

        // ── Bottom CTA ────────────────────────────────────────────────────
        _BottomBar(
          label: _selected.isEmpty
              ? 'Select members to continue'
              : 'Continue with ${_selected.length} member${_selected.length == 1 ? '' : 's'}',
          enabled: _selected.isNotEmpty,
          isLoading: false,
          primary: _primary,
          onTap: _goToStep2,
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STEP 2 — Name the group
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildStep2() {
    final theme = Theme.of(context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Group icon placeholder ───────────────────────────────
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: _primaryLight,
                        child:
                        const Icon(Icons.group, color: _primary, size: 44),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: _primary,
                          child: const Icon(Icons.camera_alt,
                              color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ── Group name field ─────────────────────────────────────
                Text(
                  'Group Name',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _groupNameController,
                    focusNode: _groupNameFocus,
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: _textDark),
                    decoration: InputDecoration(
                      hintText: 'e.g. Weekend Warriors',
                      hintStyle: theme.textTheme.bodyLarge
                          ?.copyWith(color: Colors.black38),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      counterText: '',
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Members summary ──────────────────────────────────────
                Text(
                  'Members (${_selected.length})',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selected.map((c) {
                    return _SelectedChip(
                      contact: c,
                      primary: _primary,
                      primaryLight: _primaryLight,
                      onRemove: () {
                        setState(() => _selected.remove(c));
                        // If all members removed, step back
                        if (_selected.isEmpty) setState(() => _step = 1);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),

        // ── Bottom CTA ────────────────────────────────────────────────────
        _BottomBar(
          label: 'Create Group',
          enabled: !_isCreating,
          isLoading: _isCreating,
          primary: _primary,
          onTap: _createGroup,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ContactTile2 extends StatelessWidget {
  const _ContactTile2({
    required this.contact,
    required this.isSelected,
    required this.primary,
    required this.primaryLight,
    required this.onTap,
  });

  final GroupContact contact;
  final bool isSelected;
  final Color primary;
  final Color primaryLight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = _initials(contact.name);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: primaryLight,
                child: Text(
                  initials,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  contact.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E2F),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? primary : Colors.black26,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts =
    value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }
}

class _SelectedChip extends StatelessWidget {
  const _SelectedChip({
    required this.contact,
    required this.primary,
    required this.primaryLight,
    required this.onRemove,
  });

  final GroupContact contact;
  final Color primary;
  final Color primaryLight;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstName = contact.name.split(' ').first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            firstName,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: primary,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 14, color: primary),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.label,
    required this.enabled,
    required this.isLoading,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool enabled;
  final bool isLoading;
  final Color primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAF8),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            disabledBackgroundColor: const Color(0xFFD8D6F7),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2.5),
          )
              : Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data models (local — swap out for your real models when wiring backend)
// ─────────────────────────────────────────────────────────────────────────────

class GroupContact {
  const GroupContact({required this.id, required this.name});
  final String id;
  final String name;

  @override
  bool operator ==(Object other) => other is GroupContact && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class GroupResult {
  const GroupResult({required this.name, required this.members});
  final String name;
  final List<GroupContact> members;
}