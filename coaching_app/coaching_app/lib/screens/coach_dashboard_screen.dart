import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../widgets/nav_bar.dart';

/// CoachDashboardScreen — Screen #7
/// ─────────────────────────────────────────────────────────────────────────
/// The coach sees all assigned clients here.
/// Each row shows:
///  - Client avatar + name + plan
///  - Next session date (with calendar picker to reschedule)
///  - Delete button (removes client from local list)
///  - Assign button (assign a new date)
///
/// This is a StatefulWidget because:
///  - clients can be deleted (list shrinks)
///  - dates can be updated (calendar picker)
class CoachDashboardScreen extends StatefulWidget {
  const CoachDashboardScreen({super.key});

  @override
  State<CoachDashboardScreen> createState() => _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends State<CoachDashboardScreen> {
  // Local mutable copy of the assigned clients list.
  // We make a copy so changes don't affect MockData (which is const).
  late List<AssignedClient> _clients;

  @override
  void initState() {
    super.initState();
    _clients = List.from(MockData.assignedClients);
  }

  // ── Delete a client from the list ───────────────────────────────────────
  void _delete(String id) {
    setState(() => _clients.removeWhere((c) => c.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Client removed from dashboard.')),
    );
  }

  // ── Assign / reschedule a session ───────────────────────────────────────
  Future<void> _assign(BuildContext context, AssignedClient client) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 180)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted = '${_monthName(picked.month)} ${picked.day}, ${picked.year}';
      setState(() {
        final idx = _clients.indexWhere((c) => c.id == client.id);
        if (idx != -1) {
          // Replace the client with an updated copy
          _clients[idx] = AssignedClient(
            id: client.id,
            name: client.name,
            plan: client.plan,
            nextSession: formatted,
            avatarInitials: client.avatarInitials,
            avatarColor: client.avatarColor,
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Session with ${client.name} set to $formatted'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        tabs: const ['Introduction', 'Dashboard', 'Clients Messages'],
        activeTab: 1,
        onTabTap: (i) {
          const routes = [
            '/coach-home',
            '/coach-dashboard',
            '/coach-messages'
          ];
          if (i != 1) Navigator.pushNamed(context, routes[i]);
        },
        onLogout: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Dashboard',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your clients and sessions.',
                        style: GoogleFonts.lato(
                            color: AppTheme.textMuted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Client count badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${_clients.length} Clients',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(width: 50, height: 3, color: AppTheme.accent),
            const SizedBox(height: 28),

            // ── Client list (or empty state) ─────────────────────────
            if (_clients.isEmpty)
              _EmptyState()
            else
              ..._clients.map(
                (client) => _ClientRow(
                  client: client,
                  onDelete: () => _delete(client.id),
                  onAssign: () => _assign(context, client),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Client Row Card ────────────────────────────────────────────────────────
class _ClientRow extends StatelessWidget {
  final AssignedClient client;
  final VoidCallback onDelete;
  final VoidCallback onAssign;

  const _ClientRow({
    required this.client,
    required this.onDelete,
    required this.onAssign,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // ── Avatar ──────────────────────────────────────────────
            InitialsAvatar(
              initials: client.avatarInitials,
              color: client.avatarColor,
              radius: 26,
            ),
            const SizedBox(width: 16),

            // ── Client info ─────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    client.name,
                    style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      InfoChip(
                        label: client.plan,
                        color: client.avatarColor,
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today,
                          size: 12, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        client.nextSession,
                        style: GoogleFonts.lato(
                            color: AppTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ── Delete button ────────────────────────────────────────
            // OutlinedButton with red color for destructive action
            OutlinedButton(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.accent,
                side: const BorderSide(color: AppTheme.accent),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                minimumSize: Size.zero,
              ),
              child: Text(
                'Delete',
                style: GoogleFonts.lato(fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),

            // ── Calendar icon ────────────────────────────────────────
            IconButton(
              onPressed: onAssign,
              icon: const Icon(Icons.calendar_month_outlined),
              color: AppTheme.primary,
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primary.withOpacity(0.08),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 8),

            // ── Assign button ────────────────────────────────────────
            ElevatedButton(
              onPressed: onAssign,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                minimumSize: Size.zero,
              ),
              child: Text(
                'Assign',
                style: GoogleFonts.lato(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ───────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(Icons.people_outline,
                size: 64, color: AppTheme.textMuted.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              'No clients yet',
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                color: AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Clients will appear here once assigned.',
              style: GoogleFonts.lato(
                  color: AppTheme.textMuted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
