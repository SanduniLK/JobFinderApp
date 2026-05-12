import 'package:flutter/material.dart';
import 'package:job_finder/presentation/screens/apply_job_screen.dart';
import 'home_common_widgets.dart';

class HomeJobDetailsSheet extends StatelessWidget {
  final dynamic job;
  const HomeJobDetailsSheet({required this.job});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = HomeTheme(isDark);

    return Container(decoration: BoxDecoration(color: theme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(28))),
      child: DraggableScrollableSheet(initialChildSize: 0.9, minChildSize: 0.5, maxChildSize: 0.95, expand: false,
        builder: (_, controller) => SingleChildScrollView(controller: controller, child: Column(children: [
          Center(child: Container(width: 36, height: 4, margin: const EdgeInsets.only(top: 14, bottom: 18),
            decoration: BoxDecoration(color: theme.border, borderRadius: BorderRadius.circular(2)))),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5), decoration: BoxDecoration(color: Palette.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text(job['type'] ?? 'Job Type', style: const TextStyle(color: Palette.primary, fontWeight: FontWeight.w700, fontSize: 12))),
            const SizedBox(height: 12),
            Text(job['title'] ?? 'Job Title', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: theme.text, height: 1.1)),
            const SizedBox(height: 24),
            _DetailRow(icon: Icons.location_on_outlined, label: 'Location', value: job['location'] ?? 'N/A', theme: theme),
            _DetailRow(icon: Icons.attach_money_rounded, label: 'Salary', value: '${job['salary'] ?? 'N/A'}', theme: theme, valueColor: Palette.success),
            _DetailRow(icon: Icons.category_outlined, label: 'Area', value: job['jobArea'] ?? 'N/A', theme: theme),
            _DetailRow(icon: Icons.business_outlined, label: 'Company', value: job['company'] ?? job['type'] ?? 'N/A', theme: theme),
            const SizedBox(height: 24),
            Text('Description', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: theme.text)),
            const SizedBox(height: 8),
            Text(job['description'] ?? 'No description available.', style: TextStyle(height: 1.6, fontSize: 14, color: theme.textMuted)),
            if (job['requirements'] != null) ...[
              const SizedBox(height: 24),
              Text('Requirements', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: theme.text)),
              const SizedBox(height: 8),
              Text(job['requirements'], style: TextStyle(height: 1.6, fontSize: 14, color: theme.textMuted)),
            ],
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 54, child: GestureDetector(
              onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => ApplyJobScreen(job: job))); },
              child: Container(decoration: BoxDecoration(color: Palette.primary, borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Palette.primary.withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 8))]),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.send_rounded, color: Colors.white, size: 18), SizedBox(width: 10),
                  Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
              ),
            )),
            const SizedBox(height: 36),
          ])),
        ])),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon; final String label; final String value; final HomeTheme theme; final Color? valueColor;
  const _DetailRow({required this.icon, required this.label, required this.value, required this.theme, this.valueColor});

  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 14),
    child: Row(children: [
      Container(width: 36, height: 36, decoration: BoxDecoration(color: theme.surface2, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, size: 16, color: theme.textMuted)),
      const SizedBox(width: 12),
      Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.textMuted)),
      const SizedBox(width: 8),
      Expanded(child: Text(value, style: TextStyle(fontSize: 13, color: valueColor ?? theme.text, fontWeight: valueColor != null ? FontWeight.w700 : FontWeight.w400), textAlign: TextAlign.right)),
    ]),
  );
}