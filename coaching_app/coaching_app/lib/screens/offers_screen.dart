import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../widgets/nav_bar.dart';

/// OffersScreen — Screen #4
/// ─────────────────────────────────────────────────────────────────────────
/// Shows the three pricing plans: Starter ($111), Growth ($399), Elite ($999)
/// Each plan has a list of perks and a Purchase button.
/// The "Growth" plan is marked as "Most Popular".
class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        tabs: const ['Introduction', 'Book a session', 'Offers'],
        activeTab: 2, // 'Offers' is active
        onTabTap: (i) {
          const routes = ['/client-home', '/book-session', '/offers'];
          if (i != 2) Navigator.pushNamed(context, routes[i]);
        },
        onLogout: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          children: [
            // ── Page header ──────────────────────────────────────────────
            Text(
              'Choose Your Plan',
              style: GoogleFonts.playfairDisplay(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Invest in yourself. Every plan includes access to\n'
              'certified coaches and a satisfaction guarantee.',
              style: GoogleFonts.lato(
                color: AppTheme.textMuted,
                fontSize: 15,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(width: 60, height: 3, color: AppTheme.accent),
            const SizedBox(height: 48),

            // ── Pricing cards in a Wrap (responsive) ─────────────────────
            // Wrap places items side by side and wraps to next line on small screens
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: MockData.offers
                  .map((offer) => _PricingCard(offer: offer))
                  .toList(),
            ),

            const SizedBox(height: 48),

            // ── Money-back guarantee note ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.success.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_user_outlined,
                      color: AppTheme.success, size: 28),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      '30-day money-back guarantee on all plans. '
                      'Cancel anytime, no questions asked.',
                      style: GoogleFonts.lato(
                          color: AppTheme.success,
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pricing Card ──────────────────────────────────────────────────────────
class _PricingCard extends StatelessWidget {
  final CoachingOffer offer;

  const _PricingCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    // The popular plan gets a special highlighted style
    final isPop = offer.isPopular;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        // Popular plan: dark navy background; others: white
        color: isPop ? AppTheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isPop
            ? Border.all(color: AppTheme.accent, width: 2)
            : Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(
            color: isPop
                ? AppTheme.accent.withOpacity(0.2)
                : Colors.black.withOpacity(0.06),
            blurRadius: isPop ? 30 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Card header ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Most Popular" badge (only shown on the popular plan)
                if (isPop) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'MOST POPULAR',
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Plan title
                Text(
                  offer.title,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isPop ? Colors.white : AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isPop ? AppTheme.accent : AppTheme.primary,
                      ),
                    ),
                    Text(
                      offer.price.toInt().toString(),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        color: isPop ? Colors.white : AppTheme.textDark,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26),
                      child: Text(
                        '/mo',
                        style: GoogleFonts.lato(
                          color: isPop ? Colors.white54 : AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Divider ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Divider(
              color: isPop ? Colors.white12 : AppTheme.divider,
            ),
          ),

          // ── Perks list ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: offer.perks
                  .map((perk) => _PerkRow(perk: perk, isPopular: isPop))
                  .toList(),
            ),
          ),

          const SizedBox(height: 24),

          // ── Purchase button ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: ElevatedButton(
              onPressed: () => _onPurchase(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isPop ? AppTheme.accent : AppTheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('PURCHASE'),
            ),
          ),
        ],
      ),
    );
  }

  void _onPurchase(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Purchase',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700)),
        content: Text(
          'You are about to subscribe to the ${offer.title} plan '
          'for \$${offer.price.toInt()}/month.\n\nProceed?',
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
                SnackBar(
                  content: Text(
                      '${offer.title} plan purchased! Welcome aboard.'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

// ─── Perk Row ──────────────────────────────────────────────────────────────
class _PerkRow extends StatelessWidget {
  final String perk;
  final bool isPopular;

  const _PerkRow({required this.perk, required this.isPopular});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: isPopular ? AppTheme.accent : AppTheme.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              perk,
              style: GoogleFonts.lato(
                color: isPopular ? Colors.white70 : AppTheme.textDark,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
