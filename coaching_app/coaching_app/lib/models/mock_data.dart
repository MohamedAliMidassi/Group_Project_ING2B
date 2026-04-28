/// mock_data.dart
/// All fake/static data. DART RULE: imports must come before all declarations.

// ✅ Import at the very top — this fixes the "Directives must appear before declarations" error
import 'package:flutter/material.dart';

// ─── Models ────────────────────────────────────────────────────────────────

class CoachingOffer {
  final String title;
  final double price;
  final List<String> perks;
  final bool isPopular;

  const CoachingOffer({
    required this.title,
    required this.price,
    required this.perks,
    this.isPopular = false,
  });
}

class Coach {
  final String id;
  final String name;
  final String specialty;
  final String bio;
  final String avatarInitials;
  final double rating;
  final int sessionsCount;
  final Color avatarColor;

  const Coach({
    required this.id,
    required this.name,
    required this.specialty,
    required this.bio,
    required this.avatarInitials,
    required this.rating,
    required this.sessionsCount,
    required this.avatarColor,
  });
}

class ChatMessage {
  final String sender;
  final String text;
  final String time;

  const ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
  });
}

class AssignedClient {
  final String id;
  final String name;
  final String plan;
  final String nextSession;
  final String avatarInitials;
  final Color avatarColor;

  const AssignedClient({
    required this.id,
    required this.name,
    required this.plan,
    required this.nextSession,
    required this.avatarInitials,
    required this.avatarColor,
  });
}

// ─── Static / Fake Data ────────────────────────────────────────────────────

class MockData {
  static const List<CoachingOffer> offers = [
    CoachingOffer(
      title: 'Starter',
      price: 111,
      perks: [
        '1 coaching session / month',
        'Email support',
        'Goal-setting worksheet',
        'Access to resources library',
      ],
    ),
    CoachingOffer(
      title: 'Growth',
      price: 399,
      isPopular: true,
      perks: [
        '4 coaching sessions / month',
        'Priority email & chat support',
        'Personalized action plan',
        'Progress tracking dashboard',
        'Weekly check-in calls',
      ],
    ),
    CoachingOffer(
      title: 'Elite',
      price: 999,
      perks: [
        'Unlimited coaching sessions',
        '24/7 direct coach access',
        'Custom development roadmap',
        'VIP resource library',
        'Monthly performance report',
        'Dedicated account manager',
      ],
    ),
  ];

  static final List<Coach> coaches = [
    Coach(
      id: 'c1',
      name: 'Sarah Mitchell',
      specialty: 'Career & Leadership',
      bio: 'Former Fortune 500 HR director with 12 years of executive coaching. '
          'Specializes in career transitions and leadership development.',
      avatarInitials: 'SM',
      rating: 4.9,
      sessionsCount: 340,
      avatarColor: const Color(0xFF6C63FF),
    ),
    Coach(
      id: 'c2',
      name: 'James Okonkwo',
      specialty: 'Wellness & Mindfulness',
      bio: 'Certified mindfulness instructor and life coach. Helps clients '
          'build resilience, reduce stress, and find sustainable balance.',
      avatarInitials: 'JO',
      rating: 4.8,
      sessionsCount: 215,
      avatarColor: const Color(0xFF20C997),
    ),
    Coach(
      id: 'c3',
      name: 'Amira Benali',
      specialty: 'Entrepreneurship & Strategy',
      bio: 'Serial entrepreneur and startup advisor who has built three '
          'successful businesses. Guides founders from idea to launch.',
      avatarInitials: 'AB',
      rating: 4.7,
      sessionsCount: 189,
      avatarColor: const Color(0xFFFF6B6B),
    ),
  ];

  static final List<AssignedClient> assignedClients = [
    AssignedClient(
      id: 'u1',
      name: 'Thomas Leclerc',
      plan: 'Growth',
      nextSession: 'Apr 30, 2026',
      avatarInitials: 'TL',
      avatarColor: const Color(0xFF6C63FF),
    ),
    AssignedClient(
      id: 'u2',
      name: 'Nour Khalil',
      plan: 'Elite',
      nextSession: 'May 2, 2026',
      avatarInitials: 'NK',
      avatarColor: const Color(0xFFFF6B6B),
    ),
    AssignedClient(
      id: 'u3',
      name: 'Lucas Ferreira',
      plan: 'Starter',
      nextSession: 'May 5, 2026',
      avatarInitials: 'LF',
      avatarColor: const Color(0xFF20C997),
    ),
  ];

  static const Map<String, List<ChatMessage>> conversations = {
    'u1': [
      ChatMessage(sender: 'client', text: 'Hi Sarah! Looking forward to our session tomorrow.', time: '9:14 AM'),
      ChatMessage(sender: 'coach', text: 'Hi Thomas! Me too. Please review the goal sheet I sent beforehand.', time: '9:20 AM'),
      ChatMessage(sender: 'client', text: 'Will do. Should I prepare anything else?', time: '9:22 AM'),
      ChatMessage(sender: 'coach', text: 'Just write down your top 3 challenges this week. See you tomorrow!', time: '9:25 AM'),
    ],
    'u2': [
      ChatMessage(sender: 'client', text: 'Can we reschedule to Friday instead?', time: '2:05 PM'),
      ChatMessage(sender: 'coach', text: 'Of course, Friday at 11 AM works for me.', time: '2:30 PM'),
      ChatMessage(sender: 'client', text: 'Perfect, thank you!', time: '2:31 PM'),
    ],
    'u3': [
      ChatMessage(sender: 'coach', text: 'Hi Lucas, just checking in. How is the action plan going?', time: '10:00 AM'),
      ChatMessage(sender: 'client', text: "It's going well! Completed step 2 yesterday.", time: '11:15 AM'),
      ChatMessage(sender: 'coach', text: "That's great progress! Keep it up.", time: '11:20 AM'),
    ],
  };

  static const String clientName = 'John Doe';
  static const String coachName = 'Sarah Mitchell';
  static const String coachBio =
      'Former Fortune 500 HR director with 12 years of executive coaching. '
      'Specializes in career transitions, leadership development, and helping '
      'professionals unlock their full potential. Certified ICF coach.';
  static const String clientBio =
      'Passionate about personal growth and continuous learning. '
      'Currently working on transitioning into a senior leadership role. '
      'Has been working with a coach for 6 months with great results.';
}
