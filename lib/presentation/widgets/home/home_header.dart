import 'package:flutter/material.dart';
import 'home_common_widgets.dart';

class HomeHeader extends StatelessWidget {
  final HomeTheme theme; final int jobCount; final int suggestionCount; final TextEditingController searchController;
  final Function(String) onSearchChanged; final VoidCallback onClearSearch;
  
  const HomeHeader({required this.theme, required this.jobCount, required this.suggestionCount, required this.searchController, required this.onSearchChanged, required this.onClearSearch});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(gradient: theme.headerGradient),
    child: Stack(children: [
      Positioned(top: -40, right: -40, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Palette.primary.withOpacity(0.15)))),
      Positioned(bottom: 0, left: -20, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Palette.primary.withOpacity(0.08)))),
      Padding(padding: const EdgeInsets.fromLTRB(22, 56, 22, 28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Good morning 👋', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
            const SizedBox(height: 6),
            const Text('Find Your\nDream Job', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, height: 1.15)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            StatPill(icon: Icons.work_outline_rounded, value: '$jobCount', label: 'Jobs', color: Palette.primary),
            const SizedBox(height: 8),
            StatPill(icon: Icons.auto_awesome_rounded, value: '$suggestionCount', label: 'Matches', color: Palette.success),
          ]),
        ]),
        const SizedBox(height: 22),
        Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.15))),
          child: TextField(controller: searchController, style: const TextStyle(color: Colors.white, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search roles, locations…', hintStyle: TextStyle(color: const Color.fromARGB(255, 204, 204, 204).withOpacity(0.4)),
              prefixIcon: Icon(Icons.search_rounded, color: Palette.primary, size: 20),
              suffixIcon: searchController.text.isNotEmpty ? IconButton(icon: Icon(Icons.close_rounded, color: Colors.white.withOpacity(0.5)), onPressed: onClearSearch) : null,
              border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
            onChanged: onSearchChanged,
          ),
        ),
      ])),
    ]),
  );
}