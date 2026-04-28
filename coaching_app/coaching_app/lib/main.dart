import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/app_theme.dart';
import 'screens/landing_screen.dart';
import 'screens/login_screen.dart';
import 'screens/client_home_screen.dart';
import 'screens/offers_screen.dart';
import 'screens/book_session_screen.dart';
import 'screens/coach_home_screen.dart';
import 'screens/coach_dashboard_screen.dart';
import 'screens/coach_messages_screen.dart';

/// main() is the entry point of every Flutter app.
/// runApp() boots the widget tree — everything starts here.
void main() {
  runApp(const CoachingApp());
}

/// CoachingApp is the root widget.
/// MaterialApp sets up:
///  - the global theme (colors, fonts, button styles)
///  - the named route table (URL → screen mapping)
///  - the initial route shown on launch
class CoachingApp extends StatelessWidget {
  const CoachingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muscleup',
      debugShowCheckedModeBanner: false, // hides the red DEBUG banner
      theme: AppTheme.theme,

      // ── Initial route: first screen shown when app opens ──────────────
      initialRoute: '/',

      // ── Route table ───────────────────────────────────────────────────
      // Each key is a route name. The builder returns the screen widget.
      // Navigate between them with: Navigator.pushNamed(context, '/route')
      routes: {
        '/': (context) => const LandingScreen(),
        '/login': (context) => const LoginScreen(),

        // Client routes
        '/client-home': (context) => const ClientHomeScreen(),
        '/offers': (context) => const OffersScreen(),
        '/book-session': (context) => const BookSessionScreen(),

        // Coach routes
        '/coach-home': (context) => const CoachHomeScreen(),
        '/coach-dashboard': (context) => const CoachDashboardScreen(),
        '/coach-messages': (context) => const CoachMessagesScreen(),
      },
    );
  }
}
