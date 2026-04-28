import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../widgets/nav_bar.dart';

/// CoachHomeScreen — Screen #6
/// ─────────────────────────────────────────────────────────────────────────
/// The home page for a logged-in COACH.
/// Nav tabs: Introduction (active) | Dashboard | Clients Messages | Logout
///
/// Shows:
///  - Coach avatar, name, specialty
///  - Bio / about section
///  - Stats (total clients, sessions, rating)
///  - Quick actions: go to Dashboard or Messages
class CoachHomeScreen extends StatelessWidget {
  const CoachHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        tabs: const ['Introduction', 'Dashboard', 'Clients Messages'],
        activeTab: 0,
        onTabTap: (i) {
          const routes = [
            '/coach-home',
            '/coach-dashboard',
            '/coach-messages'
          ];
          if (i != 0) Navigator.pushNamed(context, routes[i]);
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
            // ── Profile header ───────────────────────────────────────────
            _CoachProfileHeader(),

            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),

            // ── Stats row ────────────────────────────────────────────────
            _StatsRow(),

            const SizedBox(height: 32),

            // ── About ────────────────────────────────────────────────────
            const SectionHeader(title: 'About Me'),
            const SizedBox(height: 12),
            Text(
              MockData.coachBio,
              style: GoogleFonts.lato(
                  color: AppTheme.textDark, fontSize: 15, height: 1.8),
            ),

            const SizedBox(height: 32),

            // ── Specialties ──────────────────────────────────────────────
            const SectionHeader(title: 'Specialties'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                'Career Transitions',
                'Leadership Development',
                'Executive Coaching',
                'Strategic Planning',
                'Team Building',
                'Work-Life Balance',
              ]
                  .map((s) => InfoChip(
                        label: s,
                        color: AppTheme.primary,
                        icon: Icons.check,
                      ))
                  .toList(),
            ),

            const SizedBox(height: 32),

            // ── Quick actions ─────────────────────────────────────────────
            const SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _BigActionButton(
                    icon: Icons.dashboard_outlined,
                    label: 'Open Dashboard',
                    subtitle: 'Manage client assignments',
                    color: AppTheme.primary,
                    onTap: () =>
                        Navigator.pushNamed(context, '/coach-dashboard'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _BigActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: 'Messages',
                    subtitle: 'Chat with your clients',
                    color: const Color(0xFF6C63FF),
                    onTap: () =>
                        Navigator.pushNamed(context, '/coach-messages'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Coach Profile Header ──────────────────────────────────────────────────
class _CoachProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InitialsAvatar(
          initials: 'SM',
          color: const Color(0xFF6C63FF),
          radius: 48,
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                MockData.coachName,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
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
                    label: 'Career & Leadership',
                    color: const Color(0xFF6C63FF),
                    icon: Icons.psychology_outlined,
                  ),
                  InfoChip(
                    label: 'ICF Certified',
                    color: AppTheme.success,
                    icon: Icons.verified_outlined,
                  ),
                  InfoChip(
                    label: '4.9 ★',
                    color: const Color(0xFFFFC107),
                    icon: Icons.star_outline,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Coaching since 2014 • 340+ sessions',
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

// ─── Stats Row ────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                value: '3', label: 'Active Clients', color: AppTheme.primary)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                value: '340',
                label: 'Total Sessions',
                color: const Color(0xFF6C63FF))),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
                value: '4.9',
                label: 'Avg. Rating',
                color: const Color(0xFFFFC107))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lato(
                color: AppTheme.textMuted, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Big Action Button ─────────────────────────────────────────────────────
class _BigActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _BigActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.lato(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.lato(
                  color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
