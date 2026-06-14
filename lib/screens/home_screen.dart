import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'give_appreciation_screen.dart';
import 'view_list_screen.dart';
import 'summary_screen.dart';
import 'pending_approval_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Century Plyboards (I) Ltd.',
          style: TextStyle(color: AppColors.companyRed),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: AppColors.textGrey),
            tooltip: 'Logout',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── User greeting card ──
              _GreetingCard(user: user),
              const SizedBox(height: 24),

              // ── Section label ──
              const Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 14),

              // ── Action grid ──
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.05,
                children: [
                  // Always visible
                  _ActionCard(
                    label: 'Give\nAppreciation',
                    icon: Icons.emoji_events_outlined,
                    color: AppColors.btnGreen,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const GiveAppreciationScreen())),
                  ),
                  _ActionCard(
                    label: 'View\nAppreciate List',
                    icon: Icons.list_alt_outlined,
                    color: AppColors.btnBlue,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ViewListScreen())),
                  ),

                  // HOD + Admin only
                  if (user.isHOD) ...[
                    _ActionCard(
                      label: 'Pending\nfor Approval',
                      icon: Icons.pending_actions_outlined,
                      color: AppColors.btnNavy,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const PendingApprovalScreen())),
                    ),
                    _ActionCard(
                      label: 'Appreciate\nSummary',
                      icon: Icons.bar_chart_outlined,
                      color: AppColors.btnPurple,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SummaryScreen())),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 28),

              // ── Recent activity ──
              const Text(
                'RECENT ACTIVITY',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textGrey,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 14),
              ..._buildRecentItems(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRecentItems(BuildContext context) {
    final recent = MockData.appreciations.take(3).toList();
    return recent.map((item) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.gradientLeft.withOpacity(0.15),
              child: Text(
                item.receiverName.substring(0, 1),
                style: const TextStyle(
                  color: AppColors.gradientLeft,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.receiverName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.department,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            _statusDot(item.status),
          ],
        ),
      );
    }).toList();
  }

  Widget _statusDot(String status) {
    Color c;
    switch (status) {
      case 'ph_approved':  c = AppColors.statusApproved; break;
      case 'hod_approved': c = AppColors.btnBlue;        break;
      default:             c = AppColors.statusPending;
    }
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.companyRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm == true && context.mounted) {
      // TODO: clear session / SecureStorage
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }
}

// ─── Greeting card ─────────────────────────────────────────────
class _GreetingCard extends StatelessWidget {
  final UserModel user;
  const _GreetingCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientLeft, AppColors.gradientRight],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientLeft.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withOpacity(0.25),
            child: Text(
              user.name.substring(0, 1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.role.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.employeeCode,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action card tile ──────────────────────────────────────────
class _ActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
