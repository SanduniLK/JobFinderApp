import 'package:flutter/material.dart';
import 'home_common_widgets.dart';

class HomeFilters extends StatelessWidget {
  final HomeTheme theme; final List<String> jobFields; final List<String> jobTitles; final String? selectedField; final String? selectedTitle;
  final Function(String?) onFieldTap; final Function(String?) onTitleTap; final VoidCallback onClearAll; final bool hasActiveFilters;
  
  const HomeFilters({required this.theme, required this.jobFields, required this.jobTitles, required this.selectedField, required this.selectedTitle, required this.onFieldTap, required this.onTitleTap, required this.onClearAll, required this.hasActiveFilters});

  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.fromLTRB(16, 16, 16, 0), padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: theme.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (jobFields.isNotEmpty) ...[
        Text('FIELDS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.textFaint, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        SizedBox(height: 36, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: jobFields.length,
          itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(right: 8),
            child: ChipButton(label: jobFields[i], isSelected: selectedField == jobFields[i], theme: theme, onTap: () => onFieldTap(jobFields[i])))),
        ),
        const SizedBox(height: 14),
      ],
      if (jobTitles.isNotEmpty) ...[
        Text('TITLES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: theme.textFaint, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        SizedBox(height: 36, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: jobTitles.length,
          itemBuilder: (_, i) => Padding(padding: const EdgeInsets.only(right: 8),
            child: ChipButton(label: jobTitles[i], isSelected: selectedTitle == jobTitles[i], theme: theme, onTap: () => onTitleTap(jobTitles[i])))),
        ),
      ],
      if (hasActiveFilters) ...[
        const SizedBox(height: 14),
        GestureDetector(onTap: onClearAll, child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.close_rounded, size: 13, color: Palette.error), const SizedBox(width: 5),
          Text('Clear all filters', style: TextStyle(fontSize: 12, color: Palette.error, fontWeight: FontWeight.w500)),
        ])),
      ],
    ]),
  );
}