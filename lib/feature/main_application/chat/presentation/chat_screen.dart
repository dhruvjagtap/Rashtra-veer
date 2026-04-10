import 'package:flutter/material.dart';
import 'package:rashtraveer/feature/main_application/chat/presentation/groups/group_members_screen.dart';

/// A fully-featured 1-on-1 chat window.
/// Replace the static [_mockMessages] list with real data / a BLoC/provider
/// when you wire up the backend.
class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.title,
    this.avatarText,
    this.subtitle,
    this.isGroup = false,
  });

  final String title;
  final String? avatarText;
  final String? subtitle; // e.g. "Online" or "Coach · NCA certified"
  final bool isGroup;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // ── Design tokens (matching the rest of the app) ─────────────────────────
  static const Color _primary = Color(0xFF5F55E7);
  static const Color _primaryLight = Color(0xFFE9E7FF);
  static const Color _screenBg = Color(0xFFFAFAF8);
  // static const Color _bubbleSent = Color(0xFF5F55E7);
  // static const Color _bubbleReceived = Color(0xFFEFEFEF);
  static const Color _textDark = Color(0xFF1E1E2F);

  // ── State ─────────────────────────────────────────────────────────────────
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _showSendButton = false;

  final List<_Message> _messages = [
    _Message(
      text: 'Hey! How did the morning session go?',
      isMine: false,
      time: '10:02 AM',
    ),
    _Message(
      text: 'It went really well! Finished 5 km without stopping 💪',
      isMine: true,
      time: '10:04 AM',
    ),
    _Message(
      text:
          'Great progress! Remember to stretch for at least 10 minutes after.',
      isMine: false,
      time: '10:05 AM',
    ),
    _Message(
      text: 'Will do. Should I increase the distance tomorrow?',
      isMine: true,
      time: '10:06 AM',
    ),
    _Message(
      text:
          'Let\'s keep it at 5 km for the rest of this week and focus on pace instead. Aim for under 6 min/km.',
      isMine: false,
      time: '10:08 AM',
    ),
    _Message(text: 'Sounds like a plan 👍', isMine: true, time: '10:09 AM'),
  ];

  @override
  void initState() {
    super.initState();
    _inputController.addListener(() {
      final hasText = _inputController.text.trim().isNotEmpty;
      if (hasText != _showSendButton) {
        setState(() => _showSendButton = hasText);
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text: text, isMine: true, time: _nowLabel()));
      _inputController.clear();
    });

    // Scroll to the bottom after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _nowLabel() {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final m = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  // ── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = widget.avatarText ?? _initialsFromName(widget.title);

    return Scaffold(
      backgroundColor: _screenBg,

      // ── AppBar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: _screenBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 40,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: _textDark,
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: _primaryLight,
              child: Text(
                initials,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: _primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  if (widget.subtitle != null)
                    Text(
                      widget.subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.black45,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            color: _primary,
            onPressed: () {},
          ),

          if (widget.isGroup)
            IconButton(
              icon: const Icon(Icons.info_outline), // or more_vert
              color: _textDark,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GroupMembersScreen()),
                );
              },
            ),

          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            color: _textDark,
            onPressed: () {},
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────────────────────
      body: Column(
        children: [
          // Divider
          Container(height: 1, color: Colors.black.withValues(alpha: 0.06)),

          // Message list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final prevIsMine =
                    index > 0 && _messages[index - 1].isMine == msg.isMine;
                return _ChatBubble(message: msg, groupWithPrev: prevIsMine);
              },
            ),
          ),

          // ── Input bar ─────────────────────────────────────────────────────
          _InputBar(
            controller: _inputController,
            focusNode: _focusNode,
            showSendButton: _showSendButton,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }

  String _initialsFromName(String value) {
    final parts = value.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    return parts.take(2).map((p) => p[0]).join().toUpperCase();
  }
}

// ── Bubble ─────────────────────────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message, this.groupWithPrev = false});

  static const Color _bubbleSent = Color(0xFF5F55E7);
  static const Color _bubbleReceived = Color(0xFFEFEFEF);

  final _Message message;
  final bool groupWithPrev;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.isMine;

    return Padding(
      padding: EdgeInsets.only(top: groupWithPrev ? 4 : 12),
      child: Row(
        mainAxisAlignment: isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine) const SizedBox(width: 8),
          Column(
            crossAxisAlignment: isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isMine ? _bubbleSent : _bubbleReceived,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMine ? 18 : 4),
                      bottomRight: Radius.circular(isMine ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isMine ? Colors.white : const Color(0xFF1E1E2F),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message.time,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
          if (isMine) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// ── Input bar ──────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.showSendButton,
    required this.onSend,
  });

  static const Color _primary = Color(0xFF5F55E7);

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool showSendButton;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFFFAFAF8),
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? 10
            : MediaQuery.of(context).padding.bottom + 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attachment icon
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: IconButton(
              icon: const Icon(Icons.attach_file_rounded),
              color: Colors.black45,
              iconSize: 22,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),

          // Text field
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 120),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF1E1E2F),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Type a message…',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black38,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  onSubmitted: (_) => onSend(),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send / Mic button
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: showSendButton
                ? _CircleAction(
                    key: const ValueKey('send'),
                    icon: Icons.send_rounded,
                    color: _primary,
                    onTap: onSend,
                  )
                : _CircleAction(
                    key: const ValueKey('mic'),
                    icon: Icons.mic_none_rounded,
                    color: Colors.black45,
                    filled: false,
                    onTap: () {},
                  ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.filled = true,
  });

  final IconData icon;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? color : Colors.transparent,
        ),
        child: Icon(icon, color: filled ? Colors.white : color, size: 22),
      ),
    );
  }
}

// ── Data model ─────────────────────────────────────────────────────────────

class _Message {
  const _Message({
    required this.text,
    required this.isMine,
    required this.time,
  });

  final String text;
  final bool isMine;
  final String time;
}
