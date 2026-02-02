import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../utils/validators.dart';
import 'login_page.dart';
import 'register_page.dart';

/// ========================================
/// URBINO UNIVERSITY - SIGN UP PAGE
/// Premium Renaissance-inspired design
/// Password strength indicator included
/// ========================================

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

  PasswordStrength _passwordStrength = PasswordStrength(
    level: 'weak',
    score: 0,
    percentage: 0.0,
  );

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

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
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _passwordStrength = checkPasswordStrength(_passwordController.text);
    });
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordStrength.level == 'weak' &&
          _passwordController.text.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please use a stronger password'),
            backgroundColor: UrbinoColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Account created successfully!'),
          backgroundColor: UrbinoColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const RegisterPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
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
        const SizedBox(height: 36),
        _buildSignUpCard(),
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
                Icons.person_add_outlined,
                size: 42,
                color: UrbinoColors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Join Us',
          style: UrbinoTextStyles.heading1(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Create your student account',
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

  Widget _buildSignUpCard() {
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
                  _buildFullNameField(),
                  const SizedBox(height: 20),
                  _buildEmailField(),
                  const SizedBox(height: 20),
                  _buildPasswordField(),
                  const SizedBox(height: 20),
                  _buildConfirmPasswordField(),
                  const SizedBox(height: 32),
                  _buildSignUpButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: Icon(
          Icons.badge_outlined,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
      ),
      validator: (value) => validateRequired(value, 'Full name'),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'your.email@example.com',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
      ),
      validator: validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          style: UrbinoTextStyles.bodyText(context),
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Create a strong password',
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
        ),
        if (_passwordController.text.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildPasswordStrengthIndicator(),
        ],
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    Color strengthColor;
    String strengthText;
    IconData strengthIcon;

    switch (_passwordStrength.level) {
      case 'strong':
        strengthColor = UrbinoColors.success;
        strengthText = 'Strong password';
        strengthIcon = Icons.check_circle;
        break;
      case 'medium':
        strengthColor = UrbinoColors.warning;
        strengthText = 'Medium strength';
        strengthIcon = Icons.warning_amber;
        break;
      default:
        strengthColor = UrbinoColors.error;
        strengthText = 'Weak password';
        strengthIcon = Icons.error;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: UrbinoColors.lightBeige,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _passwordStrength.percentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: strengthColor,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: strengthColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(strengthIcon, size: 16, color: strengthColor),
            const SizedBox(width: 6),
            Text(
              strengthText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: strengthColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: UrbinoColors.warmGray,
          ),
          onPressed: () {
            setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
          },
        ),
      ),
      validator: (value) =>
          validateConfirmPassword(value, _passwordController.text),
    );
  }

  Widget _buildSignUpButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: UrbinoGradients.primaryButton(context),
        borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
        boxShadow: [UrbinoShadows.blueGlow],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignUp,
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
                'CREATE ACCOUNT',
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
          'Already have an account? ',
          style: UrbinoTextStyles.bodyText(context),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LoginPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 400),
              ),
            );
          },
          child: const Text(
            'Login',
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
