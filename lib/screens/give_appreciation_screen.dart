import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/common_widgets.dart';

class GiveAppreciationScreen extends StatefulWidget {
  const GiveAppreciationScreen({super.key});

  @override
  State<GiveAppreciationScreen> createState() => _GiveAppreciationScreenState();
}

class _GiveAppreciationScreenState extends State<GiveAppreciationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _searchCtrl = TextEditingController();
  final _effortCtrl = TextEditingController();

  Map<String, String>? _selectedEmployee;
  List<File> _pickedImages = [];
  bool _loading = false;

  // Filtered employee search list
  List<Map<String, String>> _filtered = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchCtrl.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearch);
    _searchCtrl.dispose();
    _effortCtrl.dispose();
    super.dispose();
  }

  void _onSearch() {
    final q = _searchCtrl.text.toLowerCase();
    if (q.isEmpty) {
      setState(() { _filtered = []; _showSuggestions = false; });
      return;
    }
    setState(() {
      _filtered = MockData.employees
          .where((e) =>
              e['name']!.toLowerCase().contains(q) ||
              e['code']!.toLowerCase().contains(q))
          .toList();
      _showSuggestions = _filtered.isNotEmpty;
    });
  }

  void _selectEmployee(Map<String, String> emp) {
    setState(() {
      _selectedEmployee = emp;
      _searchCtrl.text = emp['name']!;
      _filtered = [];
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _pickImage() async {
    if (_pickedImages.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 2 images allowed'),
          backgroundColor: AppColors.statusPending,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text('Select Image Source',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sourceBtn(Icons.camera_alt_outlined, 'Camera',
                    () => Navigator.pop(ctx, ImageSource.camera)),
                _sourceBtn(Icons.photo_library_outlined, 'Gallery',
                    () => Navigator.pop(ctx, ImageSource.gallery)),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
    if (source == null) return;

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1080,
    );
    if (picked != null) {
      setState(() => _pickedImages.add(File(picked.path)));
    }
  }

  Widget _sourceBtn(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.gradientLeft.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.gradientLeft, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (_selectedEmployee == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an employee'),
          backgroundColor: AppColors.statusRejected,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    // TODO: POST to Supabase
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _loading = false);

    if (!mounted) return;
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70, height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: AppColors.statusApproved, size: 40),
            ),
            const SizedBox(height: 16),
            const Text('Appreciation Submitted!',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Your appreciation for ${_selectedEmployee!['name']} has been sent for HOD approval.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13.5, color: AppColors.textGrey, height: 1.5),
            ),
          ],
        ),
        actions: [
          Center(
            child: AppButton(
              label: 'Done',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              color: AppColors.btnGreen,
              width: 160,
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FB),
      appBar: AppBar(
        title: const Text('Give Appreciation',
            style: TextStyle(
                color: AppColors.companyRed,
                fontWeight: FontWeight.w700,
                fontSize: 16)),
        leading: const BackButton(color: AppColors.textDark),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Employee search ──
              _SectionCard(
                title: 'Select Employee',
                child: Column(
                  children: [
                    TextFormField(
                      controller: _searchCtrl,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Search Employee Name or Code',
                        prefixIcon: Icon(Icons.search, size: 20),
                      ),
                    ),
                    if (_showSuggestions)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        constraints: const BoxConstraints(maxHeight: 220),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.divider),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, color: AppColors.divider),
                          itemBuilder: (ctx, i) {
                            final e = _filtered[i];
                            return ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor:
                                    AppColors.gradientLeft.withOpacity(0.12),
                                child: Text(
                                  e['name']!.substring(0, 1),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.gradientLeft,
                                  ),
                                ),
                              ),
                              title: Text(e['name']!,
                                  style: const TextStyle(fontSize: 13)),
                              subtitle: Text(e['dept']!,
                                  style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textGrey)),
                              onTap: () => _selectEmployee(e),
                            );
                          },
                        ),
                      ),

                    // Selected employee details
                    if (_selectedEmployee != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.statusApproved.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.statusApproved.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person_pin_outlined,
                                color: AppColors.statusApproved, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedEmployee!['name']!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  Text(
                                    '${_selectedEmployee!['code']} · ${_selectedEmployee!['dept']}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.check_circle,
                                color: AppColors.statusApproved, size: 18),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Discretionary effort ──
              _SectionCard(
                title: 'Discretionary Effort',
                child: TextFormField(
                  controller: _effortCtrl,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 14),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Please describe the effort' : null,
                  decoration: const InputDecoration(
                    hintText:
                        'Describe the employee\'s exceptional contribution or effort...',
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Images ──
              _SectionCard(
                title: 'Upload Images (Max 2)',
                child: Column(
                  children: [
                    if (_pickedImages.isNotEmpty)
                      Row(
                        children: [
                          ..._pickedImages.asMap().entries.map((e) => Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 10, bottom: 10),
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: FileImage(e.value),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => setState(() =>
                                          _pickedImages.removeAt(e.key)),
                                      child: Container(
                                        width: 22,
                                        height: 22,
                                        decoration: const BoxDecoration(
                                          color: AppColors.statusRejected,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close,
                                            size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    if (_pickedImages.length < 2)
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.inputFill,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.gradientLeft.withOpacity(0.3),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate_outlined,
                                  color: AppColors.gradientLeft, size: 28),
                              const SizedBox(width: 10),
                              Text(
                                'Tap to add image (${_pickedImages.length}/2)',
                                style: const TextStyle(
                                  color: AppColors.gradientLeft,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Info bar (from web app) ──
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.badge_outlined,
                      text: 'Appreciation By: ${user.username.toUpperCase()} - ${user.name} (${user.department})',
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.access_time,
                      text:
                          'Date & Time: ${DateFormat('dd-MM-yyyy hh:mm:ss a').format(now)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Submit ──
              AppButton(
                label: 'Submit Appreciation',
                onTap: _submit,
                loading: _loading,
                icon: Icons.send_outlined,
                color: AppColors.btnGreen,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.gradientLeft),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12.5, color: AppColors.textGrey),
          ),
        ),
      ],
    );
  }
}
