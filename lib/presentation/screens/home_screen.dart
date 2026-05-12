import 'package:flutter/material.dart';
import 'package:job_finder/presentation/provider/auth_provider.dart';

import 'package:provider/provider.dart';
import 'package:job_finder/data/remote/job_api_service.dart';
import 'package:job_finder/presentation/screens/profile_screen.dart';
import 'package:job_finder/presentation/widgets/home/home_common_widgets.dart';
import 'package:job_finder/presentation/widgets/home/home_header.dart';
import 'package:job_finder/presentation/widgets/home/home_filters.dart';
import 'package:job_finder/presentation/widgets/home/home_suggestions.dart';
import 'package:job_finder/presentation/widgets/home/home_job_card.dart';
import 'package:job_finder/presentation/widgets/home/home_job_details_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final JobApiService _jobApiService = JobApiService();
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;
  List<dynamic> _allJobs = [];
  List<dynamic> _filteredJobs = [];
  List<dynamic> _suggestedJobs = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedJobField;
  String? _selectedJobTitle;
  List<String> _userJobFields = [];
  List<String> _userJobTitles = [];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _loadJobs();
  }
   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload preferences when coming back to screen (after edit)
    _loadUserPreferences();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPreferences() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final prefs = authProvider.userPreferences;
    if (prefs != null && mounted) {
      setState(() {
        _userJobFields = prefs.jobFields;
        _userJobTitles = prefs.jobTitles;
      });
    }
  }
void _reloadUserPreferences() {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final prefs = authProvider.userPreferences;
  
  setState(() {
    _userJobFields = prefs?.jobFields ?? [];
    _userJobTitles = prefs?.jobTitles ?? [];
    // Regenerate suggestions with new preferences
    if (_allJobs.isNotEmpty) {
      _generateSuggestions(_allJobs);
      _applyFilters();
    }
  });
  
  print('✅ Reloaded preferences: ${_userJobFields.length} fields, ${_userJobTitles.length} titles');
}
  Future<void> _loadJobs() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final jobs = await _jobApiService.fetchJobs();
      if (mounted) {
        if (jobs.isNotEmpty) {
          setState(() {
            _allJobs = jobs;
            _filteredJobs = jobs;
            _generateSuggestions(jobs);
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'No jobs found';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load jobs';
          _isLoading = false;
        });
      }
    }
  }

  void _generateSuggestions(List<dynamic> jobs) {
    if (_userJobFields.isEmpty && _userJobTitles.isEmpty) {
      if (mounted) {
        setState(() {
          _suggestedJobs = jobs.take(5).toList();
        });
      }
      return;
    }
    final suggestions = jobs.where((job) {
      final jobType = job['type']?.toString().toLowerCase() ?? '';
      final jobTitle = job['title']?.toString().toLowerCase() ?? '';
      final jobArea = job['jobArea']?.toString().toLowerCase() ?? '';
      final matchesField = _userJobFields.any((field) =>
          jobType.contains(field.toLowerCase()) ||
          jobArea.contains(field.toLowerCase()));
      final matchesTitle = _userJobTitles
          .any((title) => jobTitle.contains(title.toLowerCase()));
      return matchesField || matchesTitle;
    }).toList();
    if (mounted) {
      setState(() {
        _suggestedJobs = suggestions.isEmpty && jobs.isNotEmpty
            ? jobs.take(5).toList()
            : suggestions;
      });
    }
  }

  void _searchJobs(String query) {
    if (mounted) {
      setState(() {
        _searchQuery = query;
        _applyFilters();
      });
    }
  }

  void _filterByJobField(String? field) {
    if (mounted) {
      setState(() {
        _selectedJobField = _selectedJobField == field ? null : field;
        if (_selectedJobField != null) _selectedJobTitle = null;
        _applyFilters();
      });
    }
  }

  void _filterByJobTitle(String? title) {
    if (mounted) {
      setState(() {
        _selectedJobTitle = _selectedJobTitle == title ? null : title;
        if (_selectedJobTitle != null) _selectedJobField = null;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    var filtered = _allJobs;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((job) {
        final title = job['title']?.toString().toLowerCase() ?? '';
        final type = job['type']?.toString().toLowerCase() ?? '';
        final location = job['location']?.toString().toLowerCase() ?? '';
        final jobArea = job['jobArea']?.toString().toLowerCase() ?? '';
        return title.contains(_searchQuery.toLowerCase()) ||
            type.contains(_searchQuery.toLowerCase()) ||
            location.contains(_searchQuery.toLowerCase()) ||
            jobArea.contains(_searchQuery.toLowerCase());
      }).toList();
    }
    if (_selectedJobField != null) {
      filtered = filtered.where((job) {
        final jobType = job['type']?.toString() ?? '';
        final jobArea = job['jobArea']?.toString() ?? '';
        return jobType == _selectedJobField || jobArea == _selectedJobField;
      }).toList();
    }
    if (_selectedJobTitle != null) {
      filtered = filtered.where((job) {
        final jobTitle = job['title']?.toString() ?? '';
        return jobTitle.contains(_selectedJobTitle!);
      }).toList();
    }
    if (mounted) {
      setState(() {
        _filteredJobs = filtered;
      });
    }
  }

  void _clearAllFilters() {
    if (mounted) {
      setState(() {
        _selectedJobField = null;
        _selectedJobTitle = null;
        _searchController.clear();
        _searchQuery = '';
        _filteredJobs = _allJobs;
      });
    }
  }

  void _showJobDetails(dynamic job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HomeJobDetailsSheet(job: job),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = HomeTheme(isDark);
    final hasActiveFilters = _selectedJobField != null ||
        _selectedJobTitle != null ||
        _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.bg,
      body: _currentIndex == 0
          ? RefreshIndicator(
              onRefresh: _loadJobs,
              color: Palette.primary,
              backgroundColor: theme.surface,
              child: CustomScrollView(
  physics: const AlwaysScrollableScrollPhysics(),
  slivers: [
    SliverToBoxAdapter(
      child: HomeHeader(
        theme: theme,
        jobCount: _filteredJobs.length,
        suggestionCount: _suggestedJobs.length,
        searchController: _searchController,
        onSearchChanged: _searchJobs,
        onClearSearch: () {
          _searchController.clear();
          _searchJobs('');
        },
      ),
    ),
    if (_userJobFields.isNotEmpty || _userJobTitles.isNotEmpty)
      SliverToBoxAdapter(
        child: HomeFilters(
          theme: theme,
          jobFields: _userJobFields,
          jobTitles: _userJobTitles,
          selectedField: _selectedJobField,
          selectedTitle: _selectedJobTitle,
          onFieldTap: _filterByJobField,
          onTitleTap: _filterByJobTitle,
          onClearAll: _clearAllFilters,
          hasActiveFilters: hasActiveFilters,
        ),
      ),
    if (_searchQuery.isEmpty && _suggestedJobs.isNotEmpty)
      SliverToBoxAdapter(
        child: HomeSuggestions(
          theme: theme,
          jobs: _suggestedJobs,
          onTap: _showJobDetails,
        ),
      ),
    SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          children: [
            Text(
              '${_filteredJobs.length}',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: theme.text,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'positions',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: theme.textMuted,
              ),
            ),
            const Spacer(),
            if (hasActiveFilters)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Palette.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Palette.primary.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.tune_rounded, size: 12, color: Palette.primary),
                    SizedBox(width: 5),
                    Text(
                      'Filtered',
                      style: TextStyle(fontSize: 11, color: Palette.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    ),
    // ✅ Fixed: Use SliverToBoxAdapter with SizedBox for empty/error states
    if (_isLoading)
      SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 350,
          child: const Center(child: CircularProgressIndicator()),
        ),
      )
    else if (_errorMessage != null)
      SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 350,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Palette.error),
                const SizedBox(height: 16),
                Text(_errorMessage!),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _loadJobs,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      color: Palette.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    else if (_filteredJobs.isEmpty)
      SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 350,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off_rounded, size: 48, color: theme.textFaint),
                const SizedBox(height: 16),
                Text(
                  'No positions found',
                  style: TextStyle(color: theme.text, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try different keywords or clear filters',
                  style: TextStyle(color: theme.textMuted),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _clearAllFilters,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    decoration: BoxDecoration(
                      color: Palette.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'Clear Filters',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    else
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final job = _filteredJobs[index];
            return HomeJobCard(
              theme: theme,
              job: job,
              isSuggested: _suggestedJobs.contains(job),
              onTap: () => _showJobDetails(job),
            );
          },
          childCount: _filteredJobs.length,
        ),
      ),
    const SliverToBoxAdapter(child: SizedBox(height: 24)),
  ],
),
            )
          : const ProfileScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.surface,
          border: Border(top: BorderSide(color: theme.border)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.grid_view_rounded,
                  activeIcon: Icons.grid_view_rounded,
                  label: 'Explore',
                  isActive: _currentIndex == 0,
                  theme: theme,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  isActive: _currentIndex == 1,
                  theme: theme,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final HomeTheme theme;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive
                    ? Palette.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? activeIcon : icon,
                size: 22,
                color: isActive ? Palette.primary : theme.textFaint,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive ? Palette.primary : theme.textFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}