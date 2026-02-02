import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_theme.dart';
import '../utils/validators.dart';
import 'login_page.dart';

/// ========================================
/// URBINO UNIVERSITY - REGISTER PAGE
/// Complete student profile
/// Premium Renaissance-inspired design
/// ========================================

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _selectedCountry;
  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _countries = [
    'Italy 🇮🇹',
    'United States 🇺🇸',
    'United Kingdom 🇬🇧',
    'France 🇫🇷',
    'Germany 🇩🇪',
    'Spain 🇪🇸',
    'Portugal 🇵🇹',
    'China 🇨🇳',
    'India 🇮🇳',
    'Brazil 🇧🇷',
    'Mexico 🇲🇽',
    'Canada 🇨🇦',
    'Australia 🇦🇺',
    'Japan 🇯🇵',
    'Other',
  ];

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
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _profileImage = File(pickedFile.path));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: UrbinoColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCountry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select your country'),
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
          content: const Text('Profile completed successfully!'),
          backgroundColor: UrbinoColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (route) => false,
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
        _buildRegisterCard(),
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
                Icons.assignment_ind_outlined,
                size: 42,
                color: UrbinoColors.white,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Complete Profile',
          style: UrbinoTextStyles.heading1(context),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Add your details to get started',
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

  Widget _buildRegisterCard() {
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
                  _buildProfilePicturePicker(),
                  const SizedBox(height: 28),
                  _buildUsernameField(),
                  const SizedBox(height: 20),
                  _buildPhoneField(),
                  const SizedBox(height: 20),
                  _buildCountryDropdown(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePicturePicker() {
    return Column(
      children: [
        Text(
          'Profile Picture',
          style: UrbinoTextStyles.labelText(context),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: UrbinoColors.paleBlue,
              shape: BoxShape.circle,
              border: Border.all(
                color: UrbinoColors.gold,
                width: 3,
              ),
              boxShadow: [UrbinoShadows.goldGlow],
            ),
            child: _profileImage != null
                ? ClipOval(
                    child: Image.file(
                      _profileImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: UrbinoColors.gold.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_a_photo_outlined,
                          size: 36,
                          color: UrbinoColors.darkBlue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Upload',
                        style: TextStyle(
                          color: UrbinoColors.darkBlue,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_profileImage != null) ...[
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => setState(() => _profileImage = null),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove'),
            style: TextButton.styleFrom(
              foregroundColor: UrbinoColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Username',
        hintText: 'Choose a username',
        prefixIcon: Icon(
          Icons.alternate_email_rounded,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
      ),
      validator: validateUsername,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        hintText: '+39 123 456 7890',
        prefixIcon: Icon(
          Icons.phone_outlined,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
      ),
      validator: validatePhone,
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCountry,
      style: UrbinoTextStyles.bodyText(context),
      decoration: InputDecoration(
        labelText: 'Country',
        hintText: 'Select your country',
        prefixIcon: Icon(
          Icons.public_outlined,
          color: UrbinoColors.gold.withOpacity(0.7),
        ),
      ),
      dropdownColor: UrbinoColors.white,
      icon: const Icon(Icons.keyboard_arrow_down_rounded,
          color: UrbinoColors.gold),
      items: _countries.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(country),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() => _selectedCountry = value);
      },
      validator: (value) {
        if (value == null) {
          return 'Please select a country';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: UrbinoGradients.primaryButton(context),
        borderRadius: BorderRadius.circular(UrbinoBorderRadius.medium),
        boxShadow: [UrbinoShadows.blueGlow],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
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
                'COMPLETE PROFILE',
                style: UrbinoTextStyles.buttonText(context),
              ),
      ),
    );
  }
}
