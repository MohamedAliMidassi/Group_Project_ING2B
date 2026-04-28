import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// AppNavBar
/// ──────────────────────────────────────────────────────────────────────────
/// A reusable top navigation bar used across all authenticated screens.
/// We build it as a separate widget so every screen just includes it
/// rather than copy-pasting the same code everywhere.
///
/// Parameters:
/// - [tabs]        : list of tab label strings, e.g. ['Introduction', 'Offers']
/// - [activeTab]   : which tab is currently highlighted (0-indexed)
/// - [onTabTap]    : callback when a tab is tapped, receives the tab index
/// - [onLogout]    : callback when the Logout tab is tapped
///
/// Usage example in a screen:
/// ```dart
/// AppNavBar(
///   tabs: ['Introduction', 'Book a session', 'Offers'],
///   activeTab: 0,
///   onTabTap: (i) { /* navigate */ },
///   onLogout: () { Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false); },
/// )
/// ```
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final int activeTab;
  final ValueChanged<int> onTabTap;
  final VoidCallback onLogout;

  const AppNavBar({
    super.key,
    required this.tabs,
    required this.activeTab,
    required this.onTabTap,
    required this.onLogout,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // hides the default back arrow
      backgroundColor: AppTheme.primary,
      titleSpacing: 0,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // lets tabs scroll on small screens
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // ── App Logo/Name ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                'Muscleup',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),

            // ── Tab Buttons ────────────────────────────────────────────
            ...tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isActive = index == activeTab;

              return _TabButton(
                label: label,
                isActive: isActive,
                onTap: () => onTabTap(index),
              );
            }),

            // ── Logout Button ──────────────────────────────────────────
            _TabButton(
              label: 'Logout',
              isActive: false,
              isLogout: true,
              onTap: onLogout,
            ),
          ],
        ),
      ),
    );
  }
}

/// _TabButton — a single clickable tab inside the nav bar.
/// Prefixed with _ to make it private (only usable in this file).
class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isLogout;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          // Active tab gets a solid accent background; others are transparent
          color: isActive
              ? AppTheme.accent
              : isLogout
                  ? Colors.transparent
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isLogout
              ? Border.all(color: Colors.white30, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.lato(
            color: isActive ? Colors.white : Colors.white70,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ─── Profile Avatar Widget ──────────────────────────────────────────────────
/// Reusable circular avatar that shows initials instead of an image.
/// Used in coach cards, client list, chat bubbles, etc.
///
/// Parameters:
/// - [initials]  : 1-2 letters, e.g. "SM"
/// - [color]     : background color of the circle
/// - [radius]    : circle radius (default 24)
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  final double radius;

  const InitialsAvatar({
    super.key,
    required this.initials,
    required this.color,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        initials,
        style: GoogleFonts.lato(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.65, // font size scales with radius
        ),
      ),
    );
  }
}

// ─── Section Header Widget ──────────────────────────────────────────────────
/// A styled heading with an optional red accent underline.
/// Used to introduce sections on profile / intro pages.
class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          // decorative red accent bar under the heading
          Container(width: 40, height: 3, color: AppTheme.accent),
        ],
      ),
    );
  }
}

// ─── Info Chip Widget ───────────────────────────────────────────────────────
/// Small rounded label, used for tags like specialties, plan names, ratings.
class InfoChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;

  const InfoChip({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppTheme.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: bg.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: bg),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.lato(
              color: bg,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
