import 'package:flutter/material.dart';

import 'package:rashtraveer/feature/main_application/chat/data/chat_store.dart';
import 'chat_screen.dart';
import 'groups/create_group_screen.dart';
import 'widgets/chat_list_item.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key, required this.store});

  /// The store is passed in from MainAppScreen so there's no InheritedWidget
  /// and no import ambiguity anywhere.
  final ChatStore store;

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primary = Color(0xFF5F55E7);
  static const Color _screenBg = Color(0xFFFAFAF8);
  static const Color _surfaceMuted = Color(0xFFF3F3F6);
  static const Color _textDark = Color(0xFF1E1E2F);

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Listen to tab changes so FAB visibility updates
    _tabController.addListener(() {
      if (!mounted) return;
      setState(() {});
    });

    // Listen to store changes so the lists rebuild when a group is added
    widget.store.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    if (!mounted) return;
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.store.removeListener(_onStoreChanged);
    super.dispose();
  }

  bool get _onGroupsTab => _tabController.index == 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _screenBg,
      appBar: AppBar(
        backgroundColor: _screenBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Chats',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        centerTitle: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: _primary,
          unselectedLabelColor: Colors.black45,
          indicatorColor: _primary,
          indicatorWeight: 3,
          labelStyle: theme.textTheme.titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: theme.textTheme.titleSmall,
          tabs: [
            const Tab(text: 'Chats'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Groups'),
                  if (widget.store.groups.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${widget.store.groups.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _onGroupsTab
          ? FloatingActionButton.extended(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.group_add_rounded),
        label: const Text(
          'New Group',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        onPressed: () => _openCreateGroup(context),
      )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _surfaceMuted,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                  _onGroupsTab ? 'Search groups...' : 'Search experts...',
                  hintStyle: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.black45),
                  prefixIcon:
                  const Icon(Icons.search_rounded, color: Colors.black38),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ChatsList(chats: widget.store.chats),
                _GroupsList(groups: widget.store.groups),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreateGroup(BuildContext context) async {
    final navigator = Navigator.of(context);
    final store = widget.store;

    final result = await Navigator.push<GroupResult>(
      context,
      MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
    );

    if (result == null) return;

    // addGroup() calls _notify() → _onStoreChanged() → setState() → rebuild
    store.addGroup(
      name: result.name,
      memberCount: result.members.length,
    );

    navigator.push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          title: result.name,
          subtitle:
          '${result.members.length} member${result.members.length == 1 ? '' : 's'}',
          isGroup: true,
        ),
      ),
    );
  }
}

// ── Chats tab ────────────────────────────────────────────────────────────────

class _ChatsList extends StatelessWidget {
  const _ChatsList({required this.chats});
  final List<ChatEntry> chats;

  @override
  Widget build(BuildContext context) {
    if (chats.isEmpty) {
      return const _EmptyState(
        icon: Icons.chat_bubble_outline_rounded,
        message: 'No conversations yet.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final item = chats[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ChatListItem(
            name: item.name,
            lastMessage: item.lastMessage,
            timeLabel: item.timeLabel,
            unreadCount: item.unreadCount,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  title: item.name,
                  subtitle: 'Online',
                  isGroup: false,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Groups tab ───────────────────────────────────────────────────────────────

class _GroupsList extends StatelessWidget {
  const _GroupsList({required this.groups});
  final List<ChatEntry> groups;

  static const Color _primary = Color(0xFF5F55E7);
  static const Color _primaryLight = Color(0xFFE9E7FF);

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return const _EmptyState(
        icon: Icons.group_outlined,
        message: 'No groups yet.\nTap "New Group" to create one.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final item = groups[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _GroupListItem(
            entry: item,
            primary: _primary,
            primaryLight: _primaryLight,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  title: item.name,
                  subtitle: item.memberCount > 0
                      ? '${item.memberCount} members'
                      : 'Group',
                  isGroup: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Group list item ──────────────────────────────────────────────────────────

class _GroupListItem extends StatelessWidget {
  const _GroupListItem({
    required this.entry,
    required this.primary,
    required this.primaryLight,
    required this.onTap,
  });

  final ChatEntry entry;
  final Color primary;
  final Color primaryLight;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: primaryLight,
                    child: Text(
                      entry.initials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Icon(Icons.group, color: Colors.white, size: 9),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            entry.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E1E2F),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Group',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry.timeLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black45,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (entry.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5F55E7),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${entry.unreadCount}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.message});
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: Colors.black12),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.black38),
          ),
        ],
      ),
    );
  }
}