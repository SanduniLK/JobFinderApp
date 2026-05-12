import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/presentation/provider/auth_provider.dart';
import 'package:job_finder/presentation/screens/signin_screen.dart';
import 'package:job_finder/presentation/screens/signup_step2_screen.dart';
import 'package:job_finder/core/constants/app_colors.dart';
import 'package:job_finder/core/utils/validators.dart';

class SignUpStep1Screen extends StatefulWidget {
  const SignUpStep1Screen({Key? key}) : super(key: key);

  @override
  State<SignUpStep1Screen> createState() => _SignUpStep1ScreenState();
}

class _SignUpStep1ScreenState extends State<SignUpStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, size: 18, color: isDark ? Colors.white : Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          _buildOnlineStatus(),
          const SizedBox(width: 20),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Progress Header
                  _buildProgressIndicator(1),
                  
                  const SizedBox(height: 32),
                  
                  Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create an account to find your dream job',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  _buildInputField(
                    label: 'Full Name',
                    hint: 'Enter your name',
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                    validator: Validators.validateName,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildInputField(
                    label: 'Email Address',
                    hint: 'name@example.com',
                    controller: _emailController,
                    icon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.validateEmail,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildInputField(
                    label: 'Password',
                    hint: '••••••••',
                    controller: _passwordController,
                    icon: Icons.lock_outline_rounded,
                    isPassword: true,
                    isVisible: _isPasswordVisible,
                    onVisibilityToggle: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    validator: Validators.validatePassword,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  _buildInputField(
                    label: 'Confirm Password',
                    hint: '••••••••',
                    controller: _confirmPasswordController,
                    icon: Icons.lock_reset_rounded,
                    isPassword: true,
                    isVisible: _isConfirmPasswordVisible,
                    onVisibilityToggle: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Continue Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => _handleContinue(authProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: isDark ? Colors.white60 : Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        ),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnlineStatus() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: (auth.isOnline ? AppColors.success : AppColors.offline).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 3, backgroundColor: auth.isOnline ? AppColors.success : AppColors.offline),
            const SizedBox(width: 6),
            Text(
              auth.isOnline ? 'Online' : 'Offline',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: auth.isOnline ? AppColors.success : AppColors.offline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      children: List.generate(5, (index) {
        if (index % 2 == 0) {
          int stepNum = (index ~/ 2) + 1;
          bool isCompleted = stepNum < currentStep;
          bool isActive = stepNum == currentStep;
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.primary : (isCompleted ? AppColors.primary : Colors.grey.withOpacity(0.2)),
              border: isActive ? Border.all(color: AppColors.primary.withOpacity(0.2), width: 4) : null,
            ),
            child: Center(
              child: isCompleted 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text('$stepNum', style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ),
          );
        }
        return Expanded(child: Container(height: 2, color: Colors.grey.withOpacity(0.1), margin: const EdgeInsets.symmetric(horizontal: 8)));
      }),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    bool? isVisible,
    VoidCallback? onVisibilityToggle,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !(isVisible ?? false),
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(isVisible! ? Icons.visibility_off : Icons.visibility, size: 20),
                  onPressed: onVisibilityToggle,
                )
              : null,
            filled: true,
            fillColor: isDark ? Colors.grey[900] : Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppColors.primary, width: 1)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
          ),
        ),
      ],
    );
  }

  void _handleContinue(AuthProvider authProvider) {
    if (_formKey.currentState!.validate()) {
      authProvider.saveStep1Data(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpStep2Screen()));
    }
  }
}