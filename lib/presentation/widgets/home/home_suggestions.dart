import 'package:flutter/material.dart';
import 'home_common_widgets.dart';

class HomeSuggestions extends StatelessWidget {
  final HomeTheme theme;
  final List<dynamic> jobs;
  final Function(dynamic) onTap;

  const HomeSuggestions({
    Key? key,
    required this.theme,
    required this.jobs,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: Palette.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Recommended for You',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: theme.text,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 152,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: jobs.length > 10 ? 10 : jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return _SuggestionCard(
                  theme: theme,
                  job: job,
                  onTap: () => onTap(job),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final HomeTheme theme;
  final dynamic job;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.theme,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Palette.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.work_outline_rounded,
                        size: 18,
                        color: Palette.primary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Palette.success.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '★ Match',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Palette.success,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  job['title'] ?? 'Job',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: theme.text,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  job['company'] ?? job['type'] ?? 'Company',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 11,
                      color: theme.textFaint,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        job['location'] ?? 'Remote',
                        style: TextStyle(
                          fontSize: 10,
                          color: theme.textFaint,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${job['salary'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Palette.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}