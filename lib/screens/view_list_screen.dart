import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/appreciation_card.dart';

class ViewListScreen extends StatefulWidget {
  const ViewListScreen({super.key});

  @override
  State<ViewListScreen> createState() => _ViewListScreenState();
}

class _ViewListScreenState extends State<ViewListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _filter = 'all'; // all | pending | approved | rejected

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      final filters = ['all', 'pending', 'hod_approved', 'ph_approved'];
      if (_tabController.indexIsChanging) {
        setState(() => _filter = filters[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<AppreciationModel> get _filtered {
    if (_filter == 'all') return MockData.appreciations;
    return MockData.appreciations.where((a) => a.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Appreciation List',
          style: TextStyle(
            color: AppColors.companyRed,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        leading: const BackButton(color: AppColors.textDark),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.gradientLeft,
          unselectedLabelColor: AppColors.textGrey,
          indicatorColor: AppColors.gradientLeft,
          indicatorWeight: 2.5,
          labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 12),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'HOD OK'),
            Tab(text: 'Approved'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Stats bar ──
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _Stat(label: 'Total',
                    count: MockData.appreciations.length,
                    color: AppColors.gradientLeft),
                _Stat(label: 'Pending',
                    count: MockData.appreciations
                        .where((a) => a.status == 'pending').length,
                    color: AppColors.statusPending),
                _Stat(label: 'Approved',
                    count: MockData.appreciations
                        .where((a) => a.status == 'ph_approved').length,
                    color: AppColors.statusApproved),
                _Stat(label: 'Rejected',
                    count: MockData.appreciations
                        .where((a) => a.status.contains('rejected')).length,
                    color: AppColors.statusRejected),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // ── List ──
          Expanded(
            child: _filtered.isEmpty
                ? _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 12, bottom: 24),
                    itemCount: _filtered.length,
                    itemBuilder: (ctx, i) =>
                        AppreciationCard(item: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _Stat({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text('$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: color,
              )),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined,
              size: 60, color: AppColors.textGrey.withOpacity(0.4)),
          const SizedBox(height: 14),
          const Text('No appreciations found',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
