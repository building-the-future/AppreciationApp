// ─── User Model ───────────────────────────────────────────────
class UserModel {
  final String username;
  final String employeeCode;
  final String name;
  final String department;
  final String role; // 'user' | 'hod' | 'admin'
  bool isFirstLogin;

  UserModel({
    required this.username,
    required this.employeeCode,
    required this.name,
    required this.department,
    required this.role,
    this.isFirstLogin = false,
  });

  bool get isHOD   => role == 'hod'   || role == 'admin';
  bool get isAdmin  => role == 'admin';
}

// ─── Appreciation Model ────────────────────────────────────────
class AppreciationModel {
  final String id;
  final String giverName;
  final String giverCode;
  final String receiverName;
  final String receiverCode;
  final String department;
  final String discretionaryEffort;
  final List<String> imagePaths;
  final String status; // pending | hod_approved | hod_rejected | ph_approved | ph_rejected
  final DateTime createdAt;
  final String? hodComment;
  final String? phComment;

  AppreciationModel({
    required this.id,
    required this.giverName,
    required this.giverCode,
    required this.receiverName,
    required this.receiverCode,
    required this.department,
    required this.discretionaryEffort,
    this.imagePaths = const [],
    required this.status,
    required this.createdAt,
    this.hodComment,
    this.phComment,
  });

  String get statusLabel {
    switch (status) {
      case 'pending':       return 'Pending HOD';
      case 'hod_approved':  return 'Pending Plant Head';
      case 'hod_rejected':  return 'Rejected by HOD';
      case 'ph_approved':   return 'Approved ✓';
      case 'ph_rejected':   return 'Rejected by Plant Head';
      default:              return status;
    }
  }
}

// ─── Mock Employee List (from Staff_Data_Upload.xlsx) ─────────
class MockData {
  static final currentUser = UserModel(
    username: 'kdl13562',
    employeeCode: 'KDL13562',
    name: 'SANGRAMKESHARI MALIK',
    department: 'BOILER',
    role: 'admin',
    isFirstLogin: false,
  );

  static final List<Map<String, String>> employees = [
    {'code': 'KDL11091', 'name': 'GOPI KRISHNA BAJAJ - KDL11091',   'dept': 'OPERATIONS'},
    {'code': 'KDL6',     'name': 'CHAVADA NILESH DAYALAL - KDL6',   'dept': 'ACCOUNTS'},
    {'code': 'KDL7',     'name': 'MAHENDRASINH VAGHELA - KDL7',     'dept': 'E.D.P./DISPATCH'},
    {'code': 'KDL13',    'name': 'SHAILESH KUMAR YADAV - KDL13',    'dept': 'MAINTENANCE'},
    {'code': 'KDL19',    'name': 'RAJU SHARMA - KDL19',             'dept': 'QUALITY CONTROL'},
    {'code': 'KDL22',    'name': 'JITENDER SINGH - KDL22',          'dept': 'MAINTENANCE'},
    {'code': 'KDL26',    'name': 'UMESH MAHTO - KDL26',             'dept': 'PEELING'},
    {'code': 'KDL64',    'name': 'DHARMENDRA-64 - KDL64',           'dept': 'H.R.D.'},
    {'code': 'KDL289',   'name': 'SURENDRA YADAV - KDL289',         'dept': 'HOT PRESS'},
    {'code': 'KDL681',   'name': 'AJAY DEY - KDL681',               'dept': 'MAINTENANCE'},
    {'code': 'KDL1004',  'name': 'UJJAL MUKHERJEE - KDL1004',       'dept': 'MAINTENANCE'},
    {'code': 'KDL1048',  'name': 'ASHISH KUMAR DUBEY - KDL1048',    'dept': 'E.D.P./DISPATCH'},
    {'code': 'KDL2282',  'name': 'AJAY KUMAR CHAHAR - KDL2282',     'dept': 'E.D.P./DISPATCH'},
    {'code': 'KDL3976',  'name': 'MANOJ CHANDRAMOHAN - KDL3976',    'dept': 'F/A & STORES'},
    {'code': 'KDL4529',  'name': 'VIPIN KUMAR - KDL4529',           'dept': 'IMPORT/INVENTORY'},
    {'code': 'KDL4811',  'name': 'KHUSHI SINGH YADAV - KDL4811',    'dept': 'FINISHING'},
    {'code': 'KDL10728', 'name': 'SAILENDRA BEHERA - KDL10728',     'dept': 'VENEER'},
    {'code': 'KDL11363', 'name': 'SHUBH NARAYAN RAY - KDL11363',    'dept': 'E.D.P./DISPATCH'},
  ];

  static final List<AppreciationModel> appreciations = [
    AppreciationModel(
      id: 'APP001',
      giverName: 'SANGRAMKESHARI MALIK',
      giverCode: 'KDL13562',
      receiverName: 'AJAY DEY - KDL681',
      receiverCode: 'KDL681',
      department: 'MAINTENANCE',
      discretionaryEffort:
          'Exceptional effort in completing the boiler maintenance during the weekend shutdown without any delay. Saved 2 days of downtime.',
      status: 'ph_approved',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    AppreciationModel(
      id: 'APP002',
      giverName: 'SANGRAMKESHARI MALIK',
      giverCode: 'KDL13562',
      receiverName: 'UJJAL MUKHERJEE - KDL1004',
      receiverCode: 'KDL1004',
      department: 'MAINTENANCE',
      discretionaryEffort:
          'Proactively identified and fixed a critical electrical fault before it could cause production loss.',
      status: 'hod_approved',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppreciationModel(
      id: 'APP003',
      giverName: 'GOPI KRISHNA BAJAJ',
      giverCode: 'KDL11091',
      receiverName: 'SHUBH NARAYAN RAY - KDL11363',
      receiverCode: 'KDL11363',
      department: 'E.D.P./DISPATCH',
      discretionaryEffort:
          'Handled entire dispatch coordination single-handedly during colleague\'s absence and achieved 100% on-time delivery.',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    AppreciationModel(
      id: 'APP004',
      giverName: 'MANOJ CHANDRAMOHAN',
      giverCode: 'KDL3976',
      receiverName: 'ASHISH KUMAR DUBEY - KDL1048',
      receiverCode: 'KDL1048',
      department: 'E.D.P./DISPATCH',
      discretionaryEffort:
          'Worked overtime for 3 consecutive days to clear the backlog during peak season.',
      status: 'pending',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
}
