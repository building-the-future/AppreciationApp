import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final all = MockData.appreciations;
    final approved = all.where((a) => a.status == 'ph_approved').length;
    final pending  = all.where((a) => a.status == 'pending').length;
    final rejected = all.where((a) => a.status.contains('rejected')).length;

    // Department breakdown
    final deptMap = <String, int>{};
    for (final a in all) {
      deptMap[a.department] = (deptMap[a.department] ?? 0) + 1;
    }
    final sortedDepts = deptMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appreciate Summary',
          style: TextStyle(
              color: AppColors.companyRed,
              fontWeight: FontWeight.w700,
              fontSize: 16),
        ),
        leading: const BackButton(color: AppColors.textDark),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined,
                size: 18, color: AppColors.gradientLeft),
            label: const Text('Export',
                style: TextStyle(
                    color: AppColors.gradientLeft, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Date range ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  const Icon(Icons.date_range_outlined,
                      size: 18, color: AppColors.gradientLeft),
                  const SizedBox(width: 8),
                  Text(
                    'June 2026 — Kandla Plant',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13.5),
                  ),
                  const Spacer(),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 20, color: AppColors.textGrey),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Overview cards ──
            _SectionTitle('Overview'),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(
                    label: 'Total',
                    value: '${all.length}',
                    icon: Icons.emoji_events_outlined,
                    color: AppColors.gradientLeft),
                const SizedBox(width: 10),
                _StatCard(
                    label: 'Approved',
                    value: '$approved',
                    icon: Icons.check_circle_outline,
                    color: AppColors.statusApproved),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _StatCard(
                    label: 'Pending',
                    value: '$pending',
                    icon: Icons.hourglass_empty_outlined,
                    color: AppColors.statusPending),
                const SizedBox(width: 10),
                _StatCard(
                    label: 'Rejected',
                    value: '$rejected',
                    icon: Icons.cancel_outlined,
                    color: AppColors.statusRejected),
              ],
            ),
            const SizedBox(height: 22),

            // ── Department breakdown ──
            _SectionTitle('By Department'),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                children: sortedDepts.asMap().entries.map((entry) {
                  final i = entry.key;
                  final d = entry.value;
                  final pct = d.value / all.length;
                  final isLast = i == sortedDepts.length - 1;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    d.key,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark),
                                  ),
                                ),
                                Text(
                                  '${d.value} (${(pct * 100).toStringAsFixed(0)}%)',
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.gradientLeft),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: pct,
                                backgroundColor:
                                    AppColors.gradientLeft.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.gradientLeft.withOpacity(0.7),
                                ),
                                minHeight: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isLast)
                        const Divider(height: 1, color: AppColors.divider),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 22),

            // ── Top receivers ──
            _SectionTitle('Top Appreciated Employees'),
            const SizedBox(height: 10),
            _TopReceiverList(),
            const SizedBox(height: 22),

            // ── Recent approvals ──
            _SectionTitle('Recent Activity'),
            const SizedBox(height: 10),
            ...MockData.appreciations.map((a) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppColors.gradientLeft.withOpacity(0.12),
                        child: Text(a.receiverName.substring(0, 1),
                            style: const TextStyle(
                                color: AppColors.gradientLeft,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.receiverName,
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Text(
                                '${a.department} · ${DateFormat('dd MMM').format(a.createdAt)}',
                                style: const TextStyle(
                                    fontSize: 11.5,
                                    color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      _statusIcon(a.status),
                    ],
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _statusIcon(String status) {
    switch (status) {
      case 'ph_approved':
        return const Icon(Icons.verified, color: AppColors.statusApproved, size: 20);
      case 'hod_approved':
        return const Icon(Icons.pending, color: AppColors.btnBlue, size: 20);
      case 'pending':
        return const Icon(Icons.hourglass_top, color: AppColors.statusPending, size: 20);
      default:
        return const Icon(Icons.cancel, color: AppColors.statusRejected, size: 20);
    }
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textGrey,
          letterSpacing: 1.2,
        ),
      );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: color)),
                Text(label,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TopReceiverList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Count how many times each employee was appreciated
    final counts = <String, int>{};
    for (final a in MockData.appreciations) {
      counts[a.receiverName] = (counts[a.receiverName] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: sorted.asMap().entries.map((entry) {
          final i = entry.key;
          final e = entry.value;
          final medals = ['🥇', '🥈', '🥉'];
          return Column(
            children: [
              ListTile(
                leading: Text(
                  i < 3 ? medals[i] : '${i + 1}.',
                  style: const TextStyle(fontSize: 20),
                ),
                title: Text(e.key,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gradientLeft.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${e.value}x',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gradientLeft)),
                ),
              ),
              if (i < sorted.length - 1)
                const Divider(height: 1, color: AppColors.divider, indent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
