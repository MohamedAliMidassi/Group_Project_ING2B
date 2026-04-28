import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// LandingScreen — Screen #1
/// ──────────────────────────────────────────────────────────────────────────
/// This is the very first page visitors see (not logged in).
/// It has a top nav with: Sign in/Login | Feedback | Locations
/// And a hero section with a call-to-action.
///
/// This is a StatelessWidget because the content never changes —
/// it just shows static info and navigation buttons.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ── Top Navigation Bar ─────────────────────────────────────────────
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppTheme.primary,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Brand name
              Text(
                'Muscleup',
                style: GoogleFonts.playfairDisplay(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              const Spacer(),

              // "Sign in / Login" button — highlighted in accent color
              _NavButton(
                label: 'Sign in / Login',
                isHighlighted: true,
                onTap: () => Navigator.pushNamed(context, '/login'),
              ),
              _NavButton(
                label: 'Feedback',
                onTap: () => _showFeedbackDialog(context),
              ),
              _NavButton(
                label: 'Locations',
                onTap: () => _showLocationsDialog(context),
              ),
            ],
          ),
        ),
      ),

      // ── Page Body ──────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero Section ─────────────────────────────────────────
            _HeroSection(
              onGetStarted: () => Navigator.pushNamed(context, '/login'),
            ),

            // ── Features Section ─────────────────────────────────────
            _FeaturesSection(),

            // ── Testimonials Section ──────────────────────────────────
            _TestimonialsSection(),

            // ── Footer ───────────────────────────────────────────────
            _Footer(),
          ],
        ),
      ),
    );
  }

  // ── Dialog Helpers ───────────────────────────────────────────────────────

  void _showFeedbackDialog(BuildContext context) {
    // showDialog() is Flutter's built-in modal popup.
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min, // dialog only as tall as it needs to be
          children: [
            const Text("We'd love to hear from you!"),
            const SizedBox(height: 12),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Write your feedback here...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Feedback sent! Thank you.')),
              );
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }

  void _showLocationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Our Locations'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            _LocationItem(city: 'Paris', country: 'France', flag: '🇫🇷'),
            _LocationItem(city: 'Tunis', country: 'Tunisia', flag: '🇹🇳'),
            _LocationItem(city: 'Dubai', country: 'UAE', flag: '🇦🇪'),
            _LocationItem(city: 'New York', country: 'USA', flag: '🇺🇸'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ─── Private Widgets (only used inside this file) ──────────────────────────

/// Top navigation button for the landing page nav bar.
class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _NavButton({
    required this.label,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: isHighlighted ? AppTheme.accent : Colors.transparent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Text(
        label,
        style: GoogleFonts.lato(
          fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w400,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// The big top section of the landing page with headline and CTA button.
class _HeroSection extends StatelessWidget {
  final VoidCallback onGetStarted;

  const _HeroSection({required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Dark gradient background for the hero
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.background],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
            ),
            child: Text(
              'Professional Coaching Platform',
              style: GoogleFonts.lato(
                color: AppTheme.accent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Main headline
          Text(
            'Unlock Your\nFull Potential',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 20),

          // Sub-headline
          Text(
            'Connect with world-class coaches who guide you toward\n'
            'your goals — career, wellness, leadership, and beyond.',
            style: GoogleFonts.lato(
              color: Colors.white70,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 36),

          // CTA Buttons
          Wrap(
            spacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: onGetStarted,
                icon: const Icon(Icons.arrow_forward, size: 18),
                label: const Text('GET STARTED'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white30),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                ),
                child: const Text('LEARN MORE'),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // Stats row
          Wrap(
            spacing: 40,
            runSpacing: 16,
            children: [
              _StatItem(value: '500+', label: 'Active Coaches'),
              _StatItem(value: '12k+', label: 'Sessions Held'),
              _StatItem(value: '98%', label: 'Satisfaction Rate'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            color: AppTheme.accent,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.lato(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }
}

/// Features section — three feature cards
class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          Text(
            'Why Muscleup?',
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(width: 60, height: 3, color: AppTheme.accent),
          const SizedBox(height: 40),

          // Feature cards laid out in a responsive wrap
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              _FeatureCard(
                icon: Icons.people_outline,
                title: 'Expert Coaches',
                description:
                    'Every coach is vetted, certified, and experienced in their field.',
              ),
              _FeatureCard(
                icon: Icons.calendar_today_outlined,
                title: 'Flexible Scheduling',
                description:
                    'Book sessions at any time that fits your schedule, globally.',
              ),
              _FeatureCard(
                icon: Icons.track_changes_outlined,
                title: 'Track Your Progress',
                description:
                    'Set goals, monitor milestones, and see your transformation.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.accent, size: 26),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.lato(
              color: AppTheme.textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

/// Testimonials section
class _TestimonialsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      child: Column(
        children: [
          Text(
            'What Our Clients Say',
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: const [
              _TestimonialCard(
                name: 'Mia Roberts',
                text: '"Working with my coach changed how I approach leadership. '
                    'I got promoted within 3 months."',
                role: 'Senior Manager',
              ),
              _TestimonialCard(
                name: 'Karim Bouali',
                text: '"The mindfulness sessions helped me manage stress in ways '
                    'I never thought possible."',
                role: 'Entrepreneur',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String name;
  final String text;
  final String role;

  const _TestimonialCard({
    required this.name,
    required this.text,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Star rating
          Row(
            children: List.generate(
              5,
              (_) => const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            text,
            style: GoogleFonts.lato(
              color: AppTheme.textDark,
              fontSize: 15,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primary,
                child: Text(
                  name[0],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w700, fontSize: 13)),
                  Text(role,
                      style: GoogleFonts.lato(
                          color: AppTheme.textMuted, fontSize: 12)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Page footer
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primary,
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Text(
          '© 2026 Muscleup — All rights reserved.',
          style: GoogleFonts.lato(color: Colors.white38, fontSize: 13),
        ),
      ),
    );
  }
}

/// Location list item used in the Locations dialog
class _LocationItem extends StatelessWidget {
  final String city;
  final String country;
  final String flag;

  const _LocationItem({
    required this.city,
    required this.country,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(city,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600, fontSize: 15)),
              Text(country,
                  style: GoogleFonts.lato(
                      color: AppTheme.textMuted, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}
