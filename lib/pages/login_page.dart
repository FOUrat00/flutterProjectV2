import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../utils/validators.dart';
import '../services/auth_manager.dart';
import '../services/user_manager.dart';
import 'home_page.dart';
import 'signup_page.dart';

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

  final UserManager _userManager = UserManager();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthManager>(context, listen: false);
      if (auth.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

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

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      await Future.delayed(const Duration(seconds: 1));

      final success = await Provider.of<AuthManager>(context, listen: false)
          .login(email, password);

      if (success) {
        _userManager.updateProfile(
          name: 'Student User',
          email: email,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back!'),
            backgroundColor: UrbinoColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() => _isLoading = false);
        if (!mounted) return;
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
            content: const Text(
                'Invalid email or password. Please try again or create an account.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('RETRY'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text('SIGN UP'),
              ),
            ],
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

  Widget _buildHeader() {
    return Column(
      children: [
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
              const Icon(
                Icons.account_balance,
                size: 42,
                color: UrbinoColors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Benvenuto',
          style: UrbinoTextStyles.heading1(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Student Housing Platform',
          style: UrbinoTextStyles.subtitle(context),
          textAlign: TextAlign.center,
        ),
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
