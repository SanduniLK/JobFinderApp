import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:job_finder/data/entities/user_preferences.dart';
import 'package:job_finder/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';

import 'package:job_finder/core/constants/app_colors.dart';
import 'package:job_finder/data/local/database_helper.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  
  List<String> _selectedJobFields = [];
  List<String> _selectedJobTitles = [];
  double _expectedSalary = 50000;
  String _selectedWorkMode = WorkMode.remote;
  
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user != null) {
      _nameController = TextEditingController(text: user.name);
      _emailController = TextEditingController(text: user.email);
      
      final prefs = await _databaseHelper.fetchUserPreferences(user.id!);
      if (prefs != null && mounted) {
        setState(() {
          _selectedJobFields = _getListFromJson(prefs['job_fields']);
          _selectedJobTitles = _getListFromJson(prefs['job_titles']);
          _expectedSalary = prefs['expected_salary'] ?? 50000;
          _selectedWorkMode = prefs['work_mode'] ?? WorkMode.remote;
        });
      }
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _getListFromJson(dynamic data) {
    if (data == null) return [];
    if (data is List) return List<String>.from(data);
    if (data is String) {
      try {
        final decoded = json.decode(data);
        if (decoded is List) return List<String>.from(decoded);
      } catch (e) {
        return [];
      }
    }
    return [];
  }

  Future<void> _saveChanges() async {
  if (!_formKey.currentState!.validate()) return;
  
  setState(() {
    _isSaving = true;
  });
  
  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    
    if (user == null) throw Exception('User not found');
    
    // Update user basic info
    await _databaseHelper.updateUser(user.id!, {
      'name': _nameController.text,
      'email': _emailController.text,
    });
    
    // ✅ Update preferences using AuthProvider
    await authProvider.updateUserPreferences(
      jobFields: _selectedJobFields,
      jobTitles: _selectedJobTitles,
      expectedSalary: _expectedSalary,
      workMode: _selectedWorkMode,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } finally {
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }
}

  void _toggleJobField(String field) {
    setState(() {
      if (_selectedJobFields.contains(field)) {
        _selectedJobFields.remove(field);
      } else {
        _selectedJobFields.add(field);
      }
    });
  }

  void _toggleJobTitle(String title) {
    setState(() {
      if (_selectedJobTitles.contains(title)) {
        _selectedJobTitles.remove(title);
      } else {
        _selectedJobTitles.add(title);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F0E0C) : const Color(0xFFF8F7F4),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0E0C) : const Color(0xFFF8F7F4),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // ✅ FIX: Use pop instead of close
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveChanges,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 55,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Basic Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1916) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Job Fields
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1916) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.category, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Job Fields',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: JobField.options.map((field) {
                        final isSelected = _selectedJobFields.contains(field);
                        return FilterChip(
                          label: Text(field),
                          selected: isSelected,
                          onSelected: (_) => _toggleJobField(field),
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : (isDark ? Colors.grey[300] : Colors.grey[700]),
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Job Titles
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1916) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.work_outline, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Job Titles',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: JobTitle.options.map((title) {
                        final isSelected = _selectedJobTitles.contains(title);
                        return FilterChip(
                          label: Text(title),
                          selected: isSelected,
                          onSelected: (_) => _toggleJobTitle(title),
                          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[100],
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? AppColors.primary : (isDark ? Colors.grey[300] : Colors.grey[700]),
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Salary & Work Mode
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1916) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.attach_money, size: 20, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Salary & Work Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Expected Salary: \$${_expectedSalary.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    Slider(
                      value: _expectedSalary,
                      min: 30000,
                      max: 200000,
                      divisions: 170,
                      onChanged: (value) {
                        setState(() {
                          _expectedSalary = value;
                        });
                      },
                      activeColor: AppColors.primary,
                    ),
                    Row(
                      children: [
                        _buildWorkModeOption(WorkMode.remote, Icons.home, 'Remote', isDark),
                        const SizedBox(width: 8),
                        _buildWorkModeOption(WorkMode.hybrid, Icons.business_center, 'Hybrid', isDark),
                        const SizedBox(width: 8),
                        _buildWorkModeOption(WorkMode.onSite, Icons.location_city, 'On-site', isDark),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkModeOption(String mode, IconData icon, String label, bool isDark) {
    final isSelected = _selectedWorkMode == mode;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedWorkMode = mode;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : (isDark ? Colors.grey[800] : Colors.grey[100]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: isSelected ? AppColors.primary : (isDark ? Colors.grey[400] : Colors.grey[600])),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppColors.primary : (isDark ? Colors.grey[400] : Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}