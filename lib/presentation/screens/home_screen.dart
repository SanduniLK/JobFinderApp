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
  const HomeScreen({super.key}); 
  @override State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final JobApiService _jobApiService = JobApiService();
  final TextEditingController _searchController = TextEditingController();
  
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>(); 
  
  int _currentIndex = 0;
  List<dynamic> _allJobs = [];
  List<dynamic> _filteredJobs = [];
  List<dynamic> _suggestedJobs = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String? _selectedJobField;
  String? _selectedJobTitle;
  String? _selectedWorkMode;
  String? _selectedExperience;
  List<String> _userJobFields = [];
  List<String> _userJobTitles = [];

  final List<String> _experienceOptions = [
    'All',
    'Entry Level (0-2 years)',
    'Mid Level (3-5 years)',
    'Senior Level (6-9 years)',
    'Expert (10+ years)',
  ];

  final List<String> _workModeOptions = [
    'All',
    'Remote',
    'Hybrid',
    'On-site',
  ];

  

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _loadJobs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
  await authProvider.reloadPreferences();
  
  print(' Loading user preferences in HomeScreen...');
  print(' Prefs: $prefs');
  print(' Job Fields: ${prefs?.jobFields}');
  print(' Job Titles: ${prefs?.jobTitles}');
  
  if (prefs != null && mounted) {
    setState(() {
      _userJobFields = prefs.jobFields;
      _userJobTitles = prefs.jobTitles;
    });
    print('Updated UI with ${_userJobFields.length} fields and ${_userJobTitles.length} titles');
  } else {
    print('No preferences found');
  }
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

  void _filterByWorkMode(String? mode) {
    if (mounted) {
      setState(() {
        _selectedWorkMode = mode == 'All' ? null : mode;
        _applyFilters();
      });
    }
  }

  void _filterByExperience(String? exp) {
    if (mounted) {
      setState(() {
        _selectedExperience = exp == 'All' ? null : exp;
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
    
    if (_selectedWorkMode != null && _selectedWorkMode != 'All') {
      filtered = filtered.where((job) {
        final location = job['location']?.toString().toLowerCase() ?? '';
        final jobType = job['type']?.toString().toLowerCase() ?? '';
        final jobArea = job['jobArea']?.toString().toLowerCase() ?? '';
        final title = job['title']?.toString().toLowerCase() ?? '';
        final mode = _selectedWorkMode!.toLowerCase();
        
        if (mode == 'remote') {
          return location.contains('remote') || 
                 jobType.contains('remote') || 
                 jobArea.contains('remote') ||
                 title.contains('remote');
        } else if (mode == 'hybrid') {
          return location.contains('hybrid') || 
                 jobType.contains('hybrid') || 
                 jobArea.contains('hybrid');
        } else if (mode == 'on-site' || mode == 'onsite') {
          
          return !location.contains('remote') && 
                 !jobType.contains('remote') &&
                 !location.contains('hybrid') &&
                 !jobType.contains('hybrid');
        }
        return true;
      }).toList();
    }
    
    if (_selectedExperience != null && _selectedExperience != 'All') {
      filtered = filtered.where((job) {
        final experience = job['experience']?.toString().toLowerCase() ?? '';
        
        if (_selectedExperience!.contains('Entry Level') || _selectedExperience!.contains('0-2')) {
          return experience.contains('0') || experience.contains('1') || experience.contains('2') ||
                 experience.contains('entry') || experience.contains('junior');
        } else if (_selectedExperience!.contains('Mid Level') || _selectedExperience!.contains('3-5')) {
          return experience.contains('3') || experience.contains('4') || experience.contains('5') ||
                 experience.contains('mid') || experience.contains('intermediate');
        } else if (_selectedExperience!.contains('Senior Level') || _selectedExperience!.contains('6-9')) {
          return experience.contains('6') || experience.contains('7') || experience.contains('8') || experience.contains('9') ||
                 experience.contains('senior') || experience.contains('lead');
        } else if (_selectedExperience!.contains('Expert') || _selectedExperience!.contains('10+')) {
          return experience.contains('10') || experience.contains('11') || experience.contains('12') ||
                 experience.contains('expert') || experience.contains('principal');
        }
        return false;
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
        _selectedWorkMode = null;
        _selectedExperience = null;
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

  Future<void> _onRefresh() async {
    await _loadJobs();
    await _loadUserPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = HomeTheme(isDark);
    final hasActiveFilters = _selectedJobField != null ||
        _selectedJobTitle != null ||
        _selectedWorkMode != null ||
        _selectedExperience != null ||
        _searchQuery.isNotEmpty;

    return Scaffold(
      backgroundColor: theme.bg,
      body: _currentIndex == 0
          ? RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _onRefresh,
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
                  
                  SliverToBoxAdapter(
                    child: _buildDropdownFilters(theme, isDark),
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
                            GestureDetector(
                              onTap: _clearAllFilters,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Palette.error.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Palette.error.withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.clear, size: 12, color: Palette.error),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Clear All',
                                      style: TextStyle(fontSize: 11, color: Palette.error, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  
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
              color: Colors.black.withValues(alpha: 0.06),
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

  Widget _buildDropdownFilters(HomeTheme theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedWorkMode ?? 'All',
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Palette.primary),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  items: _workModeOptions.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Row(
                        children: [
                          Icon(
                            mode == 'Remote' ? Icons.home : 
                            mode == 'Hybrid' ? Icons.business_center : 
                            Icons.location_city,
                            size: 16,
                            color: Palette.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(mode),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _filterByWorkMode,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedExperience ?? 'All',
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Palette.primary),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  items: _experienceOptions.map((exp) {
                    return DropdownMenuItem(
                      value: exp,
                      child: Row(
                        children: [
                          Icon(
                            exp.contains('Entry') ? Icons.child_care :
                            exp.contains('Mid') ? Icons.people :
                            exp.contains('Senior') ? Icons.workspace_premium :
                            Icons.work,
                            size: 16,
                            color: Palette.primary,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              exp,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: _filterByExperience,
                ),
              ),
            ),
          ),
        ],
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
                    ? Palette.primary.withValues(alpha: 0.12)
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