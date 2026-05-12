import 'package:flutter/material.dart';
import 'package:job_finder/data/entities/user_preferences.dart';
import 'package:job_finder/presentation/provider/auth_provider.dart';

import 'package:provider/provider.dart';
import 'package:job_finder/core/constants/app_colors.dart';
import 'package:job_finder/presentation/screens/home_screen.dart';

class SignUpStep3Screen extends StatefulWidget {
  const SignUpStep3Screen({Key? key}) : super(key: key);

  @override
  State<SignUpStep3Screen> createState() => _SignUpStep3ScreenState();
}

class _SignUpStep3ScreenState extends State<SignUpStep3Screen> {
  double _salary = 50000;
  String _selectedWorkMode = WorkMode.remote;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary & Work Mode'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              
              Container(
  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
  child: Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(1, "Done", isCompleted: true),
          _buildStepLine(isCompleted: true),
          _buildStepCircle(2, "Done", isCompleted: true),
          _buildStepLine(isCompleted: true),
          _buildStepCircle(3, "3", isActive: true),
        ],
      ),
      const SizedBox(height: 16),
     
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 16, color: AppColors.success),
            const SizedBox(width: 8),
            Text(
              'Final Step: Set your preferences',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        'Final Details',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tell us about your salary expectations',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 14,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.attach_money, size: 20, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Expected Annual Salary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.08),
                              AppColors.primary.withValues(alpha: 0.02),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_salary.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Slider(
                              value: _salary,
                              min: 30000,
                              max: 200000,
                              divisions: 170,
                              label: '${_salary.toStringAsFixed(0)}',
                              onChanged: (value) {
                                setState(() {
                                  _salary = value;
                                });
                                authProvider.updateSalary(_salary);
                              },
                              activeColor: AppColors.primary,
                              thumbColor: AppColors.primary,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$30k',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightTextTertiary,
                                  ),
                                ),
                                Text(
                                  '\$100k',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primary,
                                  ),
                                ),
                                Text(
                                  '\$200k',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.darkTextTertiary
                                        : AppColors.lightTextTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                     
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.work_outline, size: 20, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Preferred Work Mode',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                     
                      Row(
                        children: [
                          _buildWorkModeCard(
                            icon: Icons.home,
                            title: WorkMode.remote,
                            description: 'Work from anywhere',
                            isSelected: _selectedWorkMode == WorkMode.remote,
                            onTap: () {
                              setState(() {
                                _selectedWorkMode = WorkMode.remote;
                              });
                              authProvider.updateWorkMode(WorkMode.remote);
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildWorkModeCard(
                            icon: Icons.business_center,
                            title: WorkMode.hybrid,
                            description: 'Mix of office & remote',
                            isSelected: _selectedWorkMode == WorkMode.hybrid,
                            onTap: () {
                              setState(() {
                                _selectedWorkMode = WorkMode.hybrid;
                              });
                              authProvider.updateWorkMode(WorkMode.hybrid);
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildWorkModeCard(
                            icon: Icons.location_city,
                            title: WorkMode.onSite,
                            description: 'Work from office',
                            isSelected: _selectedWorkMode == WorkMode.onSite,
                            onTap: () {
                              setState(() {
                                _selectedWorkMode = WorkMode.onSite;
                              });
                              authProvider.updateWorkMode(WorkMode.onSite);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      
                      final success = await authProvider.completeSignUp();
                      
                      setState(() {
                        _isLoading = false;
                      });
                      
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Account created successfully!'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(authProvider.errorMessage ?? 'Registration failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Complete Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWorkModeCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withValues(alpha: 0.1)
                : (Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkSurface
                    : Colors.grey[50]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? AppColors.primary 
                  : (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.darkBorder
                      : Colors.grey[200]!),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 36,
                color: isSelected ? AppColors.primary : Colors.grey[500],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isSelected 
                      ? AppColors.primary 
                      : (Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected 
                      ? AppColors.primary.withValues(alpha: 0.8)
                      : (Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextTertiary
                          : AppColors.lightTextTertiary),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCircle(int step, String label, {bool isCompleted = false, bool isActive = false}) {
  return Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: isActive || isCompleted ? AppColors.primary : Colors.transparent,
      border: Border.all(
        color: isActive || isCompleted ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
        width: 2,
      ),
      boxShadow: isActive ? [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: 0.3),
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ] : null,
    ),
    child: Center(
      child: isCompleted
          ? const Icon(Icons.check, size: 20, color: Colors.white)
          : Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
    ),
  );
}

  Widget _buildStepLine({bool isCompleted = false}) {
  return Container(
    width: 40,
    height: 3,
    margin: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(2),
      color: isCompleted ? AppColors.primary : Colors.grey.withValues(alpha: 0.2),
    ),
  );
}
}