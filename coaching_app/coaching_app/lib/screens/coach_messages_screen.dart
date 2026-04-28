import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../widgets/nav_bar.dart';

/// CoachMessagesScreen — Screen #8
/// ─────────────────────────────────────────────────────────────────────────
/// Two-panel messaging screen (like WhatsApp Web):
///   LEFT  — list of clients
///   RIGHT — chat conversation with selected client
///
/// On mobile (narrow screen), only one panel shows at a time.
/// We detect screen width using MediaQuery.
///
/// StatefulWidget because:
///   - selected client changes when you tap a name
///   - new messages are added when you type and send
class CoachMessagesScreen extends StatefulWidget {
  const CoachMessagesScreen({super.key});

  @override
  State<CoachMessagesScreen> createState() => _CoachMessagesScreenState();
}

class _CoachMessagesScreenState extends State<CoachMessagesScreen> {
  // Currently selected client (null = no selection)
  AssignedClient? _selectedClient;

  // Local copy of conversations so we can add new messages
  // Map<clientId, List<ChatMessage>>
  late Map<String, List<ChatMessage>> _conversations;

  // Controller for the text input field
  final _inputController = TextEditingController();

  // ScrollController lets us auto-scroll to the bottom when a new message arrives
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Deep copy conversations so we don't mutate const MockData
    _conversations = {
      for (final entry in MockData.conversations.entries)
        entry.key: List<ChatMessage>.from(entry.value),
    };
    // Default select first client
    if (MockData.assignedClients.isNotEmpty) {
      _selectedClient = MockData.assignedClients.first;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Send a message ───────────────────────────────────────────────────────
  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty || _selectedClient == null) return;

    final now = TimeOfDay.now();
    final timeStr =
        '${now.hourOfPeriod}:${now.minute.toString().padLeft(2, '0')} '
        '${now.period == DayPeriod.am ? 'AM' : 'PM'}';

    setState(() {
      _conversations
          .putIfAbsent(_selectedClient!.id, () => [])
          .add(ChatMessage(sender: 'coach', text: text, time: timeStr));
    });

    _inputController.clear();

    // Scroll to bottom after build completes
    // WidgetsBinding.instance.addPostFrameCallback runs after the frame is built
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

  @override
  Widget build(BuildContext context) {
    // MediaQuery gives us the screen width so we can adapt the layout
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      appBar: AppNavBar(
        tabs: const ['Introduction', 'Dashboard', 'Clients Messages'],
        activeTab: 2,
        onTabTap: (i) {
          const routes = [
            '/coach-home',
            '/coach-dashboard',
            '/coach-messages'
          ];
          if (i != 2) Navigator.pushNamed(context, routes[i]);
        },
        onLogout: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      ),
      backgroundColor: const Color(0xFFF7F8FC),

      body: isMobile
          // ── Mobile: either client list OR chat ──────────────────────
          ? (_selectedClient == null
              ? _ClientList(
                  clients: MockData.assignedClients,
                  selectedId: null,
                  conversations: _conversations,
                  onSelect: (c) => setState(() => _selectedClient = c),
                )
              : Column(
                  children: [
                    // Back button header
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () =>
                                setState(() => _selectedClient = null),
                          ),
                          InitialsAvatar(
                            initials: _selectedClient!.avatarInitials,
                            color: _selectedClient!.avatarColor,
                            radius: 18,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedClient!.name,
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _ChatPanel(
                        messages: _conversations[_selectedClient!.id] ?? [],
                        scrollController: _scrollController,
                      ),
                    ),
                    _MessageInput(
                      controller: _inputController,
                      onSend: _sendMessage,
                    ),
                  ],
                ))

          // ── Desktop: side-by-side layout ─────────────────────────────
          : Row(
              children: [
                // Left panel — client list
                SizedBox(
                  width: 280,
                  child: _ClientList(
                    clients: MockData.assignedClients,
                    selectedId: _selectedClient?.id,
                    conversations: _conversations,
                    onSelect: (c) => setState(() => _selectedClient = c),
                  ),
                ),

                // Vertical divider between panels
                const VerticalDivider(width: 1),

                // Right panel — chat or empty state
                Expanded(
                  child: _selectedClient == null
                      ? _NoChatSelected()
                      : Column(
                          children: [
                            // Chat header
                            _ChatHeader(client: _selectedClient!),
                            const Divider(height: 1),
                            // Messages list
                            Expanded(
                              child: _ChatPanel(
                                messages: _conversations[
                                        _selectedClient!.id] ??
                                    [],
                                scrollController: _scrollController,
                              ),
                            ),
                            const Divider(height: 1),
                            // Input area
                            _MessageInput(
                              controller: _inputController,
                              onSend: _sendMessage,
                            ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}

// ─── Client List Panel ────────────────────────────────────────────────────
class _ClientList extends StatelessWidget {
  final List<AssignedClient> clients;
  final String? selectedId;
  final Map<String, List<ChatMessage>> conversations;
  final ValueChanged<AssignedClient> onSelect;

  const _ClientList({
    required this.clients,
    required this.selectedId,
    required this.conversations,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Clients',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
          ),
          const Divider(height: 1),

          // Client tiles
          Expanded(
            child: ListView.separated(
              itemCount: clients.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (context, i) {
                final client = clients[i];
                final isSelected = client.id == selectedId;
                // Last message preview
                final msgs = conversations[client.id] ?? [];
                final preview =
                    msgs.isNotEmpty ? msgs.last.text : 'No messages yet';

                return InkWell(
                  onTap: () => onSelect(client),
                  child: Container(
                    color: isSelected
                        ? AppTheme.primary.withOpacity(0.06)
                        : Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        // Selection indicator
                        if (isSelected)
                          Container(
                            width: 3,
                            height: 36,
                            color: AppTheme.primary,
                            margin: const EdgeInsets.only(right: 10),
                          ),
                        InitialsAvatar(
                          initials: client.avatarInitials,
                          color: client.avatarColor,
                          radius: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client.name,
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isSelected
                                      ? AppTheme.primary
                                      : AppTheme.textDark,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                preview,
                                style: GoogleFonts.lato(
                                    color: AppTheme.textMuted,
                                    fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Message count badge
                        if (msgs.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${msgs.length}',
                              style: GoogleFonts.lato(
                                  color: AppTheme.primary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chat Header ──────────────────────────────────────────────────────────
class _ChatHeader extends StatelessWidget {
  final AssignedClient client;
  const _ChatHeader({required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          InitialsAvatar(
            initials: client.avatarInitials,
            color: client.avatarColor,
            radius: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                client.name,
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppTheme.textDark),
              ),
              Text(
                client.plan,
                style: GoogleFonts.lato(
                    color: AppTheme.textMuted, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Chat Messages Panel ──────────────────────────────────────────────────
class _ChatPanel extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;

  const _ChatPanel({required this.messages, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          'No messages yet.\nSay hello!',
          style: GoogleFonts.lato(color: AppTheme.textMuted, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: messages.length,
      itemBuilder: (_, i) => _Bubble(message: messages[i]),
    );
  }
}

// ─── Chat Bubble ──────────────────────────────────────────────────────────
class _Bubble extends StatelessWidget {
  final ChatMessage message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    // "coach" messages appear on the RIGHT (sent by the logged-in coach)
    // "client" messages appear on the LEFT
    final isCoach = message.sender == 'coach';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isCoach ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar on the left for client messages
          if (!isCoach) ...[
            CircleAvatar(
              radius: 14,
              backgroundColor: AppTheme.textMuted.withOpacity(0.2),
              child: const Icon(Icons.person, size: 16, color: AppTheme.textMuted),
            ),
            const SizedBox(width: 8),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isCoach ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    // Coach bubbles: dark navy; Client bubbles: light grey
                    color: isCoach ? AppTheme.primary : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isCoach ? 16 : 4),
                      bottomRight: Radius.circular(isCoach ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(maxWidth: 360),
                  child: Text(
                    message.text,
                    style: GoogleFonts.lato(
                      color: isCoach ? Colors.white : AppTheme.textDark,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: GoogleFonts.lato(
                      color: AppTheme.textMuted, fontSize: 11),
                ),
              ],
            ),
          ),

          // Avatar on the right for coach messages
          if (isCoach) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 14,
              backgroundColor: AppTheme.primary.withOpacity(0.15),
              child: const Icon(Icons.person, size: 16, color: AppTheme.primary),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Message Input Bar ────────────────────────────────────────────────────
class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInput({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          // Text input — expands to fill available space
          Expanded(
            child: TextField(
              controller: controller,
              // onSubmitted fires when user presses Enter
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.lato(
                    color: AppTheme.textMuted, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          InkWell(
            onTap: onSend,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── No Chat Selected placeholder ─────────────────────────────────────────
class _NoChatSelected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline,
              size: 72, color: AppTheme.textMuted.withOpacity(0.3)),
          const SizedBox(height: 16),
          Text(
            'Select a client to start chatting',
            style: GoogleFonts.lato(
                color: AppTheme.textMuted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
