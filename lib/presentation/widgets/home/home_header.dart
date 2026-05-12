import 'package:flutter/material.dart';
import 'home_common_widgets.dart';

class HomeHeader extends StatelessWidget {
  final HomeTheme theme;
  final int jobCount;
  final int suggestionCount;
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSearch;
  
  const HomeHeader({
    required this.theme,
    required this.jobCount,
    required this.suggestionCount,
    required this.searchController,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return '🌅';
    } else if (hour < 17) {
      return '☀️';
    } else {
      return '🌙';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = _getGreeting();
    final greetingIcon = _getGreetingIcon();
    
    return Container(
      decoration: BoxDecoration(gradient: theme.headerGradient),
      child: Stack(children: [
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.primary.withValues(alpha: 0.15),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: -20,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.primary.withValues(alpha: 0.08),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 56, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              greetingIcon,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              greeting,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Find Your\nDream Job',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatPill(
                        icon: Icons.work_outline_rounded,
                        value: '$jobCount',
                        label: 'Jobs',
                        color: Palette.primary,
                      ),
                      const SizedBox(height: 8),
                      StatPill(
                        icon: Icons.auto_awesome_rounded,
                        value: '$suggestionCount',
                        label: 'Matches',
                        color: Palette.success,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 1, 3, 20),
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search roles..…',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 204, 204, 204).withValues(alpha: 0.4),
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Palette.primary,
                      size: 20,
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            onPressed: onClearSearch,
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}