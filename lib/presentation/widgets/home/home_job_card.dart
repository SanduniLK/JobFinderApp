import 'package:flutter/material.dart';
import 'home_common_widgets.dart';

class HomeJobCard extends StatelessWidget {
  final HomeTheme theme; final dynamic job; final bool isSuggested; final VoidCallback onTap;
  const HomeJobCard({required this.theme, required this.job, required this.isSuggested, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = [Palette.primary, const Color(0xFF0EA5E9), const Color(0xFF8B5CF6), const Color(0xFF14B8A6)];
    final avatarColor = colors[(job['title']?.hashCode ?? 0).abs() % colors.length];

    return Container(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(color: theme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: theme.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 6))]),
      child: Material(color: Colors.transparent, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(20),
        child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          Container(width: 52, height: 52, decoration: BoxDecoration(color: avatarColor.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.business_center_rounded, color: avatarColor, size: 24)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(job['title'] ?? 'Job Title', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: theme.text), maxLines: 1, overflow: TextOverflow.ellipsis)),
              if (isSuggested) Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(color: Palette.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8), border: Border.all(color: Palette.primary.withOpacity(0.3))),
                child: const Text('✦ Match', style: TextStyle(fontSize: 9, color: Palette.primary, fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height: 3),
            Text(job['type'] ?? 'Job Type', style: TextStyle(color: theme.textMuted, fontSize: 12)),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.location_on_outlined, size: 13, color: theme.textFaint), const SizedBox(width: 3),
              Expanded(child: Text(job['location'] ?? 'Location', style: TextStyle(color: theme.textFaint, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: 8),
              Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: Palette.success.withOpacity(0.10), borderRadius: BorderRadius.circular(8)),
                child: Text('${job['salary'] ?? 'N/A'}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Palette.success))),
            ]),
          ])),
          Icon(Icons.chevron_right_rounded, color: theme.textFaint, size: 20),
        ])),
      )),
    );
  }
}