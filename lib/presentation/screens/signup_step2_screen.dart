import 'package:flutter/material.dart';
import 'package:job_finder/data/entities/user_preferences.dart';
import 'package:job_finder/presentation/provider/auth_provider.dart';
import 'package:job_finder/presentation/screens/signup_step3_screen.dart';
import 'package:provider/provider.dart';
import 'package:job_finder/core/constants/app_colors.dart';

class SignUpStep2Screen extends StatefulWidget {
  
  const SignUpStep2Screen({super.key});

  @override
  State<SignUpStep2Screen> createState() => _SignUpStep2ScreenState();
}

class _SignUpStep2ScreenState extends State<SignUpStep2Screen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.chevron_left_rounded, color: isDark ? Colors.white : Colors.black, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        
        title: _buildProgressIndicator(2), 
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildHeaderSection(authProvider),
                      const SizedBox(height: 32),
                      _buildSearchBar(isDark),
                      const SizedBox(height: 32),

                      _buildSectionLabel(
                        icon: Icons.grid_view_rounded,
                        title: "Preferred Fields",
                        count: authProvider.selectedJobFields.length,
                        onClear: () => _clearAll(authProvider, true),
                      ),
                      const SizedBox(height: 16),
                      _buildChipGroup(
                        items: JobField.options,
                        selectedItems: authProvider.selectedJobFields,
                        onToggle: authProvider.toggleJobField,
                      ),

                      const SizedBox(height: 40),

                      _buildSectionLabel(
                        icon: Icons.badge_outlined,
                        title: "Job Titles",
                        count: authProvider.selectedJobTitles.length,
                        onClear: () => _clearAll(authProvider, false),
                      ),
                      const SizedBox(height: 16),
                      _buildChipGroup(
                        items: JobTitle.options,
                        selectedItems: authProvider.selectedJobTitles,
                        onToggle: authProvider.toggleJobTitle,
                      ),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: _buildStickyFooter(context),
    );
  }



  Widget _buildProgressIndicator(int currentStep) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
              color: isActive ? AppColors.primary : (isCompleted ? AppColors.primary : Colors.grey.withValues(alpha: 0.2)),
              border: isActive ? Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 4) : null,
            ),
            child: Center(
              child: isCompleted 
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text('$stepNum', style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ),
          );
        }
       
        return Container(
          width: 20,
          height: 2, 
          color: Colors.grey.withValues(alpha: 0.1), 
          margin: const EdgeInsets.symmetric(horizontal: 4)
        );
      }),
    );
  }

  Widget _buildHeaderSection(AuthProvider auth) {
    int total = auth.selectedJobFields.length + auth.selectedJobTitles.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Personalize your\ncareer feed.",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, letterSpacing: -1, height: 1.2),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: total > 0 ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            total > 0 ? " $total items selected" : "Select at least 1 field to continue",
            style: TextStyle(
              color: total > 0 ? AppColors.primary : Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: "Search categories...",
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSectionLabel({required IconData icon, required String title, required int count, required VoidCallback onClear}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const Spacer(),
        if (count > 0)
          TextButton(
            onPressed: onClear,
            child: const Text("Clear all", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildChipGroup({required List<String> items, required List<String> selectedItems, required Function(String) onToggle}) {
    final filtered = items.where((i) => i.toLowerCase().contains(_searchQuery)).toList();
    return Wrap(
      spacing: 10,
      runSpacing: 12,
      children: filtered.map((item) {
        final isSelected = selectedItems.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onToggle(item),
          selectedColor: AppColors.primary.withValues(alpha: 0.15),
          checkmarkColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        );
      }).toList(),
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpStep3Screen())),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  void _clearAll(AuthProvider auth, bool isField) {
    if (isField) {
      for (var field in List.from(auth.selectedJobFields)) {
        auth.toggleJobField(field);
      }
    } else {
      for (var title in List.from(auth.selectedJobTitles)) {
        auth.toggleJobTitle(title);
      }
    }
  }
}