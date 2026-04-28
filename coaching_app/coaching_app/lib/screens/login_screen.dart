import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// LoginScreen — Screen #2
/// ─────────────────────────────────────────────────────────────────────────
/// Handles both Login and Register in one screen.
/// Uses a StatefulWidget because the UI changes based on user interaction:
///   - toggling between Login / Register tabs
///   - showing/hiding error messages
///   - showing/hiding the password field
///
/// MOCK LOGIN CREDENTIALS (no backend):
///   Client  → email: client@test.com   password: 1234
///   Coach   → email: coach@test.com    password: 1234
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ── State variables ──────────────────────────────────────────────────────
  bool _isLogin = true;          // true = Login tab, false = Register tab
  bool _showError = false;       // whether to show "wrong credentials" banner
  bool _obscurePassword = true;  // whether the password is hidden

  // TextEditingControllers let us read what the user typed in each field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _confirmController = TextEditingController();

  // TabController animates the Login / Register tab switch
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Listen to tab changes and update _isLogin accordingly
    _tabController.addListener(() {
      setState(() => _isLogin = _tabController.index == 0);
    });
  }

  @override
  void dispose() {
    // Always dispose controllers to free memory when the screen is removed
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ── Login logic ──────────────────────────────────────────────────────────
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _showError = false);

    if (email == 'client@test.com' && password == '1234') {
      // Navigate to client home and remove all previous screens from the stack
      Navigator.pushNamedAndRemoveUntil(
          context, '/client-home', (route) => false);
    } else if (email == 'coach@test.com' && password == '1234') {
      Navigator.pushNamedAndRemoveUntil(
          context, '/coach-home', (route) => false);
    } else {
      // Show error alert
      setState(() => _showError = true);
    }
  }

  // ── Register logic ───────────────────────────────────────────────────────
  void _handleRegister() {
    // Basic validation
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    // In a real app you'd call an API. Here we just redirect to client home.
    Navigator.pushNamedAndRemoveUntil(
        context, '/client-home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Logo / Brand ───────────────────────────────────────────
              Text(
                'CoachHub',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your journey starts here',
                style: GoogleFonts.lato(
                    color: AppTheme.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 40),

              // ── Card container ─────────────────────────────────────────
              Container(
                width: 420,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ── Tab Bar: Login | Register ────────────────────────
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: AppTheme.textMuted,
                        indicator: BoxDecoration(
                          color: AppTheme.primary,
                        ),
                        labelStyle: GoogleFonts.lato(
                            fontWeight: FontWeight.w700, fontSize: 14),
                        tabs: const [
                          Tab(text: 'LOG IN'),
                          Tab(text: 'REGISTER'),
                        ],
                      ),
                    ),

                    // ── Error Banner ─────────────────────────────────────
                    if (_showError)
                      _ErrorBanner(
                        message: _isLogin
                            ? 'Username or password is incorrect.'
                            : 'Please fill in all fields.',
                        onRetry: () => setState(() => _showError = false),
                      ),

                    // ── Tab Content ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: _isLogin
                          ? _LoginForm(
                              emailController: _emailController,
                              passwordController: _passwordController,
                              obscurePassword: _obscurePassword,
                              onToggleObscure: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              onSubmit: _handleLogin,
                            )
                          : _RegisterForm(
                              nameController: _nameController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmController: _confirmController,
                              obscurePassword: _obscurePassword,
                              onToggleObscure: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              onSubmit: _handleRegister,
                            ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              // Back to landing
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: const Text('Back to home'),
                style: TextButton.styleFrom(
                    foregroundColor: AppTheme.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Error Banner ─────────────────────────────────────────────────────────
class _ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBanner({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppTheme.accent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message,
                style:
                    GoogleFonts.lato(color: AppTheme.accent, fontSize: 13)),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(
                foregroundColor: AppTheme.accent,
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 24)),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─── Login Form ────────────────────────────────────────────────────────────
class _LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _LoginForm({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Hint text for demo ─────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F7FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Text(
            'Demo:\nclient@test.com / 1234\ncoach@test.com / 1234',
            style: GoogleFonts.lato(
                color: Colors.blue.shade700, fontSize: 12),
          ),
        ),
        const SizedBox(height: 20),

        // ── Email field ────────────────────────────────────────────────
        _FormLabel(text: 'Email address'),
        const SizedBox(height: 6),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'you@example.com',
            prefixIcon: Icon(Icons.email_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 20),

        // ── Password field ─────────────────────────────────────────────
        _FormLabel(text: 'Password'),
        const SizedBox(height: 6),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: '••••••••',
            prefixIcon: const Icon(Icons.lock_outline, size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 18),
              onPressed: onToggleObscure,
            ),
          ),
        ),
        const SizedBox(height: 28),

        // ── Submit button ──────────────────────────────────────────────
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text('LOG IN'),
        ),
      ],
    );
  }
}

// ─── Register Form ─────────────────────────────────────────────────────────
class _RegisterForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;
  final VoidCallback onSubmit;

  const _RegisterForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.obscurePassword,
    required this.onToggleObscure,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormLabel(text: 'Full name'),
        const SizedBox(height: 6),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'John Doe',
            prefixIcon: Icon(Icons.person_outline, size: 18),
          ),
        ),
        const SizedBox(height: 16),

        _FormLabel(text: 'Email address'),
        const SizedBox(height: 6),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'you@example.com',
            prefixIcon: Icon(Icons.email_outlined, size: 18),
          ),
        ),
        const SizedBox(height: 16),

        _FormLabel(text: 'Password'),
        const SizedBox(height: 6),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            hintText: 'Create a strong password',
            prefixIcon: const Icon(Icons.lock_outline, size: 18),
            suffixIcon: IconButton(
              icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  size: 18),
              onPressed: onToggleObscure,
            ),
          ),
        ),
        const SizedBox(height: 16),

        _FormLabel(text: 'Confirm password'),
        const SizedBox(height: 6),
        TextField(
          controller: confirmController,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Repeat your password',
            prefixIcon: Icon(Icons.lock_outline, size: 18),
          ),
        ),
        const SizedBox(height: 28),

        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50)),
          child: const Text('CREATE ACCOUNT'),
        ),
      ],
    );
  }
}

// ─── Shared small label above each input ──────────────────────────────────
class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.lato(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppTheme.textDark,
      ),
    );
  }
}
