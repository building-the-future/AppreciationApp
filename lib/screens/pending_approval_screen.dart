import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/appreciation_card.dart';

class PendingApprovalScreen extends StatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  // Mutable local copy for UI state
  late List<AppreciationModel> _items;
  String _dept = 'All';

  final List<String> _depts = [
    'All',
    'MAINTENANCE',
    'E.D.P./DISPATCH',
    'FINISHING',
    'HOT PRESS',
    'QUALITY CONTROL',
  ];

  @override
  void initState() {
    super.initState();
    _items = List.from(MockData.appreciations
        .where((a) => a.status == 'pending' || a.status == 'hod_approved')
        .toList());
  }

  List<AppreciationModel> get _filtered {
    if (_dept == 'All') return _items;
    return _items.where((a) => a.department == _dept).toList();
  }

  void _approve(AppreciationModel item) {
    _showCommentDialog(
      title: 'Approve Appreciation',
      confirmLabel: 'Approve',
      confirmColor: AppColors.statusApproved,
      icon: Icons.thumb_up_outlined,
      onConfirm: (comment) {
        setState(() {
          final idx = _items.indexOf(item);
          _items[idx] = AppreciationModel(
            id: item.id,
            giverName: item.giverName,
            giverCode: item.giverCode,
            receiverName: item.receiverName,
            receiverCode: item.receiverCode,
            department: item.department,
            discretionaryEffort: item.discretionaryEffort,
            imagePaths: item.imagePaths,
            status: item.status == 'pending' ? 'hod_approved' : 'ph_approved',
            createdAt: item.createdAt,
            hodComment: item.status == 'pending' ? comment : item.hodComment,
            phComment: item.status == 'hod_approved' ? comment : null,
          );
        });
        _showToast('Appreciation Approved ✓', AppColors.statusApproved);
      },
    );
  }

  void _reject(AppreciationModel item) {
    _showCommentDialog(
      title: 'Reject Appreciation',
      confirmLabel: 'Reject',
      confirmColor: AppColors.statusRejected,
      icon: Icons.thumb_down_outlined,
      onConfirm: (comment) {
        setState(() {
          final idx = _items.indexOf(item);
          _items[idx] = AppreciationModel(
            id: item.id,
            giverName: item.giverName,
            giverCode: item.giverCode,
            receiverName: item.receiverName,
            receiverCode: item.receiverCode,
            department: item.department,
            discretionaryEffort: item.discretionaryEffort,
            imagePaths: item.imagePaths,
            status:
                item.status == 'pending' ? 'hod_rejected' : 'ph_rejected',
            createdAt: item.createdAt,
            hodComment: item.status == 'pending' ? comment : item.hodComment,
            phComment: item.status == 'hod_approved' ? comment : null,
          );
        });
        _showToast('Appreciation Rejected', AppColors.statusRejected);
      },
    );
  }

  void _showCommentDialog({
    required String title,
    required String confirmLabel,
    required Color confirmColor,
    required IconData icon,
    required void Function(String comment) onConfirm,
  }) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(icon, color: confirmColor, size: 22),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comment (optional):',
                style: TextStyle(
                    fontSize: 13, color: AppColors.textGrey)),
            const SizedBox(height: 8),
            TextField(
              controller: ctrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a remark...',
                filled: true,
                fillColor: AppColors.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm(ctrl.text.trim());
            },
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
  }

  void _showToast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount =
        _items.where((a) => a.status == 'pending').length;
    final hodApprovedCount =
        _items.where((a) => a.status == 'hod_approved').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pending Approval',
          style: TextStyle(
            color: AppColors.companyRed,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        leading: const BackButton(color: AppColors.textDark),
      ),
      body: Column(
        children: [
          // ── Summary bar ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    _CountBadge(
                        label: 'Needs HOD action',
                        count: pendingCount,
                        color: AppColors.statusPending),
                    const SizedBox(width: 10),
                    _CountBadge(
                        label: 'Needs Plant Head',
                        count: hodApprovedCount,
                        color: AppColors.btnBlue),
                  ],
                ),
                const SizedBox(height: 12),
                // Department filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _depts.map((d) {
                      final sel = d == _dept;
                      return GestureDetector(
                        onTap: () => setState(() => _dept = d),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: sel
                                ? AppColors.gradientLeft
                                : AppColors.inputFill,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            d,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: sel ? Colors.white : AppColors.textGrey,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // ── List ──
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            size: 60,
                            color: AppColors.statusApproved.withOpacity(0.4)),
                        const SizedBox(height: 14),
                        const Text('No pending items!',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textGrey)),
                        const SizedBox(height: 6),
                        const Text('All appreciations have been reviewed.',
                            style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textGrey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) {
                      final item = _filtered[i];
                      return AppreciationCard(
                        item: item,
                        showActions: true,
                        onApprove: () => _approve(item),
                        onReject: () => _reject(item),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _CountBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Text('$count',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 11.5,
                      color: color,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
