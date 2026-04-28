import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../widgets/nav_bar.dart';

/// ClientHomeScreen — Screen #3
/// ─────────────────────────────────────────────────────────────────────────
/// This is the home page shown to a logged-in CLIENT.
/// Nav tabs: Introduction (active) | Book a session | Offers | Logout
///
/// Shows:
///  - The client's avatar, name, and bio
///  - A summary of their current plan
///  - Upcoming session info
///  - Quick navigation buttons
class ClientHomeScreen extends StatelessWidget {
  const ClientHomeScreen({super.key});

  void _logout(BuildContext context) {
    // pushNamedAndRemoveUntil clears the whole navigation stack,
    // so pressing Back won't bring the user back to a protected screen.
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Navigation bar at the top ──────────────────────────────────────
      appBar: AppNavBar(
        tabs: const ['Introduction', 'Book a session', 'Offers'],
        activeTab: 0, // 'Introduction' is the active tab
        onTabTap: (i) {
          // Map tab index to route
          const routes = ['/client-home', '/book-session', '/offers'];
          if (i != 0) Navigator.pushNamed(context, routes[i]);
        },
        onLogout: () => _logout(context),
      ),

      backgroundColor: const Color(0xFFF7F8FC),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile header ───────────────────────────────────────────
            _ProfileHeader(),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),

            // ── About / Bio section ──────────────────────────────────────
            const SectionHeader(title: 'About Me'),
            const SizedBox(height: 12),
            Text(
              MockData.clientBio,
              style: GoogleFonts.lato(
                color: AppTheme.textDark,
                fontSize: 15,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 32),

            // ── Current Plan ─────────────────────────────────────────────
            const SectionHeader(title: 'My Plan'),
            const SizedBox(height: 12),
            _PlanCard(),

            const SizedBox(height: 32),

            // ── Quick Actions ─────────────────────────────────────────────
            const SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 12),
            _QuickActions(),
          ],
        ),
      ),
    );
  }
}

// ─── Profile Header ────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar circle
        InitialsAvatar(
          initials: 'JD',
          color: AppTheme.primary,
          radius: 44,
        ),
        const SizedBox(width: 24),

        // Name and tags
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MockData.clientName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  InfoChip(
                    label: 'Growth Plan',
                    color: AppTheme.accent,
                    icon: Icons.workspace_premium_outlined,
                  ),
                  InfoChip(
                    label: 'Active Client',
                    color: AppTheme.success,
                    icon: Icons.verified_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Member since January 2026',
                style: GoogleFonts.lato(
                    color: AppTheme.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Plan Card ─────────────────────────────────────────────────────────────
class _PlanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Plan summary row
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.workspace_premium,
                      color: AppTheme.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Growth Plan — \$399/month',
                        style: GoogleFonts.lato(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppTheme.textDark),
                      ),
                      Text(
                        '4 sessions per month • Priority support',
                        style: GoogleFonts.lato(
                            color: AppTheme.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Upcoming session
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppTheme.textMuted),
                const SizedBox(width: 8),
                Text(
                  'Next session: ',
                  style: GoogleFonts.lato(
                      color: AppTheme.textMuted, fontSize: 13),
                ),
                Text(
                  'April 30, 2026 at 10:00 AM',
                  style: GoogleFonts.lato(
                      color: AppTheme.textDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Upgrade button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/offers'),
                icon: const Icon(Icons.upgrade, size: 16),
                label: const Text('VIEW ALL PLANS'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Actions Grid ─────────────────────────────────────────────────────
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.calendar_month_outlined,
        label: 'Book a Session',
        color: const Color(0xFF6C63FF),
        onTap: () => Navigator.pushNamed(context, '/book-session'),
      ),
      _ActionItem(
        icon: Icons.workspace_premium_outlined,
        label: 'View Offers',
        color: AppTheme.accent,
        onTap: () => Navigator.pushNamed(context, '/offers'),
      ),
      _ActionItem(
        icon: Icons.history,
        label: 'Session History',
        color: const Color(0xFF20C997),
        onTap: () {},
      ),
      _ActionItem(
        icon: Icons.settings_outlined,
        label: 'Settings',
        color: AppTheme.textMuted,
        onTap: () {},
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true, // don't scroll independently — let parent scroll
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: actions,
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppTheme.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
