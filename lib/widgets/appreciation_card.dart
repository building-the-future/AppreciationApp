import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';

class AppreciationCard extends StatelessWidget {
  final AppreciationModel item;
  final bool showActions;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const AppreciationCard({
    super.key,
    required this.item,
    this.showActions = false,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientLeft.withOpacity(0.12),
                  AppColors.gradientRight.withOpacity(0.08),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.gradientLeft.withOpacity(0.2),
                  child: Text(
                    item.receiverName.substring(0, 1),
                    style: const TextStyle(
                      color: AppColors.gradientLeft,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
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
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
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
                StatusChip(status: item.status),
              ],
            ),
          ),

          // ── Body ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Discretionary effort
                const Text(
                  'Discretionary Effort',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textGrey,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.discretionaryEffort,
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textDark,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.divider),
                const SizedBox(height: 10),

                // Footer: giver + date
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'By: ${item.giverName}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textGrey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(Icons.access_time, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(item.createdAt),
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),

                // Image thumbnails if any
                if (item.imagePaths.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: item.imagePaths
                        .map((p) => Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.inputFill,
                                image: DecorationImage(
                                  image: NetworkImage(p),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],

                // Approve / Reject actions (HOD/Admin only)
                if (showActions && item.status == 'pending') ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Reject'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.statusRejected,
                            side: const BorderSide(color: AppColors.statusRejected),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onApprove,
                          icon: const Icon(Icons.check, size: 16),
                          label: const Text('Approve'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.statusApproved,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // HOD approved — plant head actions
                if (showActions && item.status == 'hod_approved') ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.btnBlue.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 14, color: AppColors.btnBlue),
                        SizedBox(width: 6),
                        Text(
                          'HOD Approved · Awaiting Plant Head decision',
                          style: TextStyle(
                              fontSize: 11.5, color: AppColors.btnBlue),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onReject,
                          icon: const Icon(Icons.close, size: 16),
                          label: const Text('Reject (PH)'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.statusRejected,
                            side: const BorderSide(color: AppColors.statusRejected),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onApprove,
                          icon: const Icon(Icons.verified, size: 16),
                          label: const Text('Approve (PH)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.statusApproved,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
