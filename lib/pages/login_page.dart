import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../utils/validators.dart';
import 'signup_page.dart';
import 'home_page.dart';

/// ========================================
/// URBINO UNIVERSITY - LOGIN PAGE
/// Premium Renaissance-inspired design
/// For international students platform
/// ========================================

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize elegant entrance animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// Handle login with authentication validation
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Get entered credentials
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // Simple authentication validation
      // For demo: accept "student@urbino.it" with password "urbino123"
      // or any email ending with @urbino.it with password "password"
      final bool isValidLogin = (email.toLowerCase() == 'student@urbino.it' &&
              password == 'urbino123') ||
          (email.toLowerCase().endsWith('@urbino.it') &&
              password == 'password');

      if (isValidLogin) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Benvenuto! Login successful'),
            backgroundColor: UrbinoColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        // Navigate to Home Page (Dashboard)
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => HomePage(
              userEmail: email,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      } else {
        // Show error alert dialog for incorrect credentials
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UrbinoBorderRadius.large),
            ),
            title: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: UrbinoColors.error, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Login Failed',
                  style: UrbinoTextStyles.heading2(context),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Incorrect email or password',
                  style: UrbinoTextStyles.bodyTextBold(context),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please check your credentials and try again.',
                  style: UrbinoTextStyles.bodyText(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'Demo credentials:\n• Email: student@urbino.it\n• Password: urbino123',
                  style: UrbinoTextStyles.smallText(context),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: UrbinoColors.darkBlue,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        );

        // Also show a snackbar for quick feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Invalid email or password'),
                ),
              ],
            ),
            backgroundColor: UrbinoColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: UrbinoGradients.backgroundLight(context),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(),
        const SizedBox(height: 40),
        _buildLoginCard(),
        const SizedBox(height: 24),
        _buildFooter(),
      ],
    );
  }

  /// Premium header with Urbino identity
  Widget _buildHeader() {
    return Column(
      children: [
        // University-inspired logo/emblem
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [UrbinoColors.darkBlue, UrbinoColors.deepBlue],
            ),
            shape: BoxShape.circle,
            boxShadow: [UrbinoShadows.blueGlow],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Decorative ring inspired by Renaissance architecture
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: UrbinoColors.gold.withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
              // Icon
              const Icon(
                Icons.account_balance,
                size: 42,
                color: UrbinoColors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Title
        Text(
          'Benvenuto',
          style: UrbinoTextStyles.heading1(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'Student Housing Platform',
          style: UrbinoTextStyles.subtitle(context),
          textAlign: TextAlign.center,
        ),

        // Gold accent line
        Container(
          margin: const EdgeInsets.only(top: 16),
          width: 60,
          height: 3,
          decoration: BoxDecoration(
            gradient: UrbinoGradients.goldAccent(context),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  /// Premium white card with elevation
  Widget _buildLoginCard() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 440),
      decoration: BoxDecoration(
        color: UrbinoColors.white,
        borderRadius: BorderRadius.circular(UrbinoBorderRadius.large),
        boxShadow: [UrbinoShadows.elevated],
      ),
      child: Column(
        children: [
          // Gold accent bar at top
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: UrbinoGradients.goldAccent(context),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(UrbinoBorderRadius.large),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 12),
                  _buildForgotPassword(),
                  const SizedBox(height: 32),
                  _buildLoginButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Elegant email input
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Email or Username',
        hintText: 'Enter your email',
        prefixIcon: Icon(
          Icons.person_outline_rounded,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
      ),
      validator: (value) => validateRequired(value, 'Email or Username'),
    );
  }

  /// Elegant password input
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: UrbinoColors.warmGray,
          ),
          onPressed: () {
            setState(() => _isPasswordVisible = !_isPasswordVisible);
          },
        ),
      ),
      validator: validatePassword,
    );
  }

  /// Stylish forgot password link
  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
              ),
              title: Text('Password Reset',
                  style: UrbinoTextStyles.heading2(context)),
              content: Text(
                'Password reset functionality will be implemented here.',
                style: UrbinoTextStyles.bodyText(context),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: Text(
          'Forgot password?',
          style: UrbinoTextStyles.linkText(context),
        ),
      ),
    );
  }

  /// Premium gradient button
  Widget _buildLoginButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: UrbinoGradients.primaryButton(context),
        borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
        boxShadow: [UrbinoShadows.blueGlow],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(UrbinoColors.white),
                ),
              )
            : Text(
                'LOGIN',
                style: UrbinoTextStyles.buttonText(context),
              ),
      ),
    );
  }

  /// Footer with sign up link
  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: UrbinoTextStyles.bodyText(context),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SignUpPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          child: const Text(
            'Sign up',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: UrbinoColors.gold,
              decoration: TextDecoration.underline,
              decorationColor: UrbinoColors.gold,
            ),
          ),
        ),
      ],
    );
  }
}
