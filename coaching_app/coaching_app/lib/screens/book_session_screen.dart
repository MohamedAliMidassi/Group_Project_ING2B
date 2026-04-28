import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/mock_data.dart';
import '../widgets/nav_bar.dart';

/// BookSessionScreen — Screen #5
/// ─────────────────────────────────────────────────────────────────────────
/// Shows a list of available coaches. Each row has:
///  - Coach avatar (initials circle)
///  - Name, specialty, rating
///  - Date picker placeholder  ( / / )
///  - Calendar icon
///  - Book button
class BookSessionScreen extends StatefulWidget {
  const BookSessionScreen({super.key});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen> {
  // Map of coach id → selected date.
  // We use a Map so each coach can have their own date selection.
  final Map<String, DateTime?> _selectedDates = {};

  // ── Pick a date for a coach ─────────────────────────────────────────────
  Future<void> _pickDate(BuildContext context, String coachId) async {
    // showDatePicker is a built-in Flutter dialog for picking dates
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        // Wrap with Theme to apply our custom colors to the picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primary,
              onPrimary: Colors.white,
              onSurface: AppTheme.textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // setState tells Flutter to rebuild the widget with the new date
      setState(() => _selectedDates[coachId] = picked);
    }
  }

  // ── Book confirmation ───────────────────────────────────────────────────
  void _book(BuildContext context, Coach coach) {
    final date = _selectedDates[coach.id];
    if (date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date first.'),
          backgroundColor: AppTheme.accent,
        ),
      );
      return;
    }

    // Format the date nicely for display
    final formatted =
        '${date.day}/${date.month}/${date.year}';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Confirm Booking',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coach: ${coach.name}'),
            Text('Specialty: ${coach.specialty}'),
            Text('Date: $formatted'),
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
                SnackBar(
                  content: Text(
                      'Session booked with ${coach.name} on $formatted!'),
                  backgroundColor: AppTheme.success,
                ),
              );
            },
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        tabs: const ['Introduction', 'Book a session', 'Offers'],
        activeTab: 1, // 'Book a session' is active
        onTabTap: (i) {
          const routes = ['/client-home', '/book-session', '/offers'];
          if (i != 1) Navigator.pushNamed(context, routes[i]);
        },
        onLogout: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
      ),
      backgroundColor: const Color(0xFFF7F8FC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Page header ────────────────────────────────────────────
            Text(
              'Book a Session',
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Select a coach and choose your session date.',
              style: GoogleFonts.lato(
                  color: AppTheme.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Container(width: 50, height: 3, color: AppTheme.accent),
            const SizedBox(height: 28),

            // ── Coach list ─────────────────────────────────────────────
            // We use Column + map instead of ListView because the parent
            // is already a SingleChildScrollView
            ...MockData.coaches.map(
              (coach) => _CoachCard(
                coach: coach,
                selectedDate: _selectedDates[coach.id],
                onPickDate: () => _pickDate(context, coach.id),
                onBook: () => _book(context, coach),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Coach Card ────────────────────────────────────────────────────────────
class _CoachCard extends StatelessWidget {
  final Coach coach;
  final DateTime? selectedDate;
  final VoidCallback onPickDate;
  final VoidCallback onBook;

  const _CoachCard({
    required this.coach,
    required this.selectedDate,
    required this.onPickDate,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    // Format selected date or show placeholder
    final dateLabel = selectedDate != null
        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
        : '— / — / —';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Coach info row ─────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                InitialsAvatar(
                  initials: coach.avatarInitials,
                  color: coach.avatarColor,
                  radius: 30,
                ),
                const SizedBox(width: 16),

                // Name, specialty, bio
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coach.name,
                        style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      InfoChip(
                        label: coach.specialty,
                        color: coach.avatarColor,
                        icon: Icons.psychology_outlined,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        coach.bio,
                        style: GoogleFonts.lato(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // ── Rating + Stats row ─────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                const SizedBox(width: 4),
                Text(
                  '${coach.rating}',
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w700, fontSize: 13),
                ),
                const SizedBox(width: 16),
                Icon(Icons.people_outline,
                    size: 16, color: AppTheme.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${coach.sessionsCount} sessions',
                  style: GoogleFonts.lato(
                      color: AppTheme.textMuted, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Booking row: date field + calendar + Book button ────────
            Row(
              children: [
                // Date display — tapping opens the date picker
                Expanded(
                  child: InkWell(
                    onTap: onPickDate,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dateLabel,
                        style: GoogleFonts.lato(
                          color: selectedDate != null
                              ? AppTheme.textDark
                              : AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Calendar icon button
                IconButton(
                  onPressed: onPickDate,
                  icon: const Icon(Icons.calendar_month_outlined),
                  color: AppTheme.primary,
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primary.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 8),

                // Book button
                ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coach.avatarColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text('BOOK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
