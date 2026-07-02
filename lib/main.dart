// ═══════════════════════════════════════════════════════════
// تطبيق "أمان" — نظام تصاريح العمل الآمن (Permit to Work)
// الإصدار 2.1 — الهوية البصرية السعودية الحديثة (أخضر ملكي × ذهبي رملي)
// نظام ثنائي البوابات: بوابة الموظف (تقديم الطلبات) + بوابة المشرف (التحقق والاعتماد)
// روعي في تصميم الاحتياطات الاسترشاد بمعايير OSHA وHSE (HSG250)
// ومنهجيات NEBOSH وIOSH في أنظمة تصاريح العمل.
// حقوق الطبع والنشر © 2026 محمد عبدالمجيد البارقي. جميع الحقوق محفوظة.
// يُمنع نسخ أو استخدام أي جزء من هذا الكود دون إذن خطّي من المؤلّف.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

void main() => runApp(const AmanApp());

/* ============================ الهوية البصرية ============================
   لوحة ألوان مستوحاة من المنصات السعودية الحديثة:
   أخضر ملكي عميق (ثقة وأمان) + ذهبي رملي (فخامة) + خلفيات ناعمة       */
const cGreen = Color(0xFF0B5334); // الأخضر السعودي الملكي — أساسي
const cGreenDark = Color(0xFF0E3B27); // تدرج داكن للبوابة
const cGreenLite = Color(0xFF17835A); // تدرج فاتح لأشرطة التقدم
const cGold = Color(0xFFC5A059); // ذهبي رملي — لمسات فاخرة
const cBg = Color(0xFFF4F6F8); // خلفية التطبيق
const cCard = Colors.white;
const cInk = Color(0xFF232B33); // نص رئيسي (سليت داكن)
const cMuted = Color(0xFF6E7781); // نص ثانوي
const cLine = Color(0xFFE8ECEF); // حدود خفيفة
const cTrack = Color(0xFFEDF1F4); // مسار أشرطة التقدم

/* ظل ناعم موحّد للبطاقات العائمة */
const softShadow = [
  BoxShadow(color: Color(0x0A000000), blurRadius: 18, offset: Offset(0, 4)),
];

/* ألوان الحالات — درجات هادئة تُعرض على خلفيات باستيل */
const cPending = Color(0xFFC27A00);
const cApproved = Color(0xFF0B5334);
const cRejected = Color(0xFFC0392B);
const cExpired = Color(0xFF8C6B1F);
const cClosed = Color(0xFF2F6DAE);

Color statusColor(String s) {
  switch (s) {
    case 'بانتظار الاعتماد':
      return cPending;
    case 'معتمد':
      return cApproved;
    case 'مرفوض':
      return cRejected;
    case 'منتهي':
      return cExpired;
    case 'مقفل':
      return cClosed;
    default:
      return cMuted;
  }
}

/* ============================ أنواع التصاريح ============================
   12 نوعًا تغطي أشهر تصاريح العمل في المنشآت الصناعية والإنشائية،
   مع الاحتياطات ومعدات الوقاية والمرجعية المعيارية لكل نوع.        */
class PermitType {
  final String name;
  final IconData icon;
  final String std; // المرجعية المعيارية
  final List<String> precautions;
  final List<String> ppe;
  const PermitType(this.name, this.icon, this.std, this.precautions, this.ppe);
}

const permitTypes = [
  PermitType(
    'عمل ساخن',
    Icons.local_fire_department,
    'OSHA 1910.252 / NFPA 51B',
    [
      'توفير طفاية حريق صالحة ومراقب حريق في الموقع',
      'إزالة أو تغطية المواد القابلة للاشتعال ضمن 10 أمتار',
      'فحص الأجواء من الغازات القابلة للاشتعال قبل البدء',
      'تغطية الفتحات والمجاري لمنع تسرّب الشرر',
      'استمرار مراقبة الموقع 30 دقيقة بعد انتهاء العمل',
    ],
    ['خوذة سلامة', 'درع/نظارات لحام', 'قفازات جلدية', 'ملابس مقاومة للهب'],
  ),
  PermitType(
    'عمل بارد',
    Icons.build,
    'HSE HSG250 (أفضل ممارسات PTW)',
    [
      'التأكد من عزل المنطقة عن أي أعمال ساخنة مجاورة',
      'ترتيب الموقع وإزالة العوائق قبل البدء',
      'استخدام العدد اليدوية السليمة والمناسبة للمهمة',
      'التأكد من كفاية الإضاءة والتهوية',
      'إبلاغ مشغّل المنطقة قبل البدء وبعد الانتهاء',
    ],
    ['خوذة سلامة', 'حذاء سلامة', 'قفازات', 'نظارات واقية'],
  ),
  PermitType(
    'دخول أماكن مغلقة',
    Icons.inventory_2,
    'OSHA 1910.146',
    [
      'قياس الأكسجين والغازات السامة والقابلة للاشتعال قبل الدخول',
      'تهوية مستمرة للمكان أثناء العمل',
      'مراقب خارجي دائم عند فتحة الدخول',
      'معدات إنقاذ جاهزة (حبل أمان ورافعة استرجاع)',
      'وسيلة اتصال دائمة مع العامل بالداخل',
    ],
    ['جهاز قياس غازات', 'حزام جسم كامل', 'جهاز تنفس عند الحاجة', 'خوذة سلامة'],
  ),
  PermitType(
    'حفريات',
    Icons.construction,
    'OSHA 1926 Subpart P',
    [
      'التأكد من خلو الموقع من الخدمات المدفونة (كهرباء، ماء، غاز)',
      'تدعيم الجوانب أو عمل ميول آمنة للحفر الأعمق من 1.2 متر',
      'وضع حواجز وإشارات تحذيرية حول الحفرية',
      'توفير سلالم خروج آمنة كل 7.5 متر',
      'إبعاد ناتج الحفر والمعدات مترًا على الأقل عن الحافة',
    ],
    ['خوذة سلامة', 'سترة عاكسة', 'حذاء سلامة', 'قفازات'],
  ),
  PermitType(
    'عمل على ارتفاعات',
    Icons.height,
    'OSHA 1926.501 / WAH Regs 2005',
    [
      'فحص أحزمة الأمان ونقاط التثبيت قبل البدء',
      'التأكد من سلامة السقالات أو السلالم وشهادات فحصها',
      'تحويط منطقة خطر السقوط أسفل موقع العمل',
      'تأمين العدد والأدوات من السقوط (ربطها)',
      'إيقاف العمل عند الرياح الشديدة أو الأمطار',
    ],
    ['حزام أمان كامل', 'خوذة بحزام ذقن', 'حذاء مانع للانزلاق', 'حبل تثبيت مزدوج'],
  ),
  PermitType(
    'أعمال كهربائية',
    Icons.electrical_services,
    'OSHA 1910.147 / NFPA 70E',
    [
      'فصل التيار وتطبيق العزل والقفل والتعليق (LOTO)',
      'التحقق من انعدام الجهد قبل ملامسة الموصلات',
      'استخدام عدد معزولة مناسبة لمستوى الجهد',
      'وضع لافتة تحذير عند مصدر الفصل',
      'عدم إعادة التيار إلا بعد إبلاغ جميع العاملين',
    ],
    ['قفازات عازلة', 'حذاء عازل', 'نظارات واقية', 'ملابس مقاومة للقوس الكهربائي'],
  ),
  PermitType(
    'عمليات الرفع',
    Icons.upload,
    'OSHA 1926.1400 / LOLER 1998',
    [
      'التأكد من سريان شهادة فحص الرافعة وملحقاتها',
      'التأكد من ثبات الأرضية وفرد الدعامات كاملة',
      'تحديد وزن الحمولة وعدم تجاوز الحمل الآمن للرافعة',
      'تعيين مشرف رفع ومُشير (Rigger) معتمدَين',
      'تحويط منطقة الرفع ومنع المرور تحت الحمولة',
    ],
    ['خوذة سلامة', 'سترة عاكسة', 'حذاء سلامة', 'قفازات'],
  ),
  PermitType(
    'أعمال إشعاعية',
    Icons.flare,
    'OSHA 1910.1096 / IAEA',
    [
      'تحديد منطقة محظورة وتحويطها بعلامات الإشعاع',
      'إبعاد جميع العاملين غير المعنيين أثناء التصوير',
      'استخدام أجهزة قياس الجرعات الشخصية (Dosimeter)',
      'تنفيذ العمل بواسطة فني إشعاع مرخّص فقط',
      'تخزين المصدر المشع في حاويته المعتمدة فور الانتهاء',
    ],
    ['شارة قياس جرعات', 'جهاز إنذار إشعاعي', 'قفازات', 'ملابس واقية'],
  ),
  PermitType(
    'مواد كيميائية وخطرة',
    Icons.science,
    'OSHA 1910.1200 / COSHH',
    [
      'توفر صحيفة بيانات السلامة (SDS) لكل مادة في الموقع',
      'تهوية مناسبة أو شفط موضعي للأبخرة',
      'توفير محطة غسيل عيون ودش طوارئ قريبة',
      'تخزين المواد المتعارضة بشكل منفصل',
      'تجهيز خطة احتواء ومواد امتصاص للانسكابات',
    ],
    ['قفازات مقاومة كيميائيًا', 'نظارات محكمة', 'كمامة بفلتر مناسب', 'مريول مقاوم'],
  ),
  PermitType(
    'أعمال هدم',
    Icons.hardware,
    'OSHA 1926 Subpart T',
    [
      'إجراء مسح هندسي للمبنى وتحديد تسلسل الهدم',
      'فصل جميع الخدمات (كهرباء، ماء، غاز) قبل البدء',
      'تحويط منطقة الهدم ومنع دخول غير المصرّح لهم',
      'ترطيب الموقع للحد من انتشار الغبار',
      'إزالة الأنقاض أولًا بأول ومنع تراكمها',
    ],
    ['خوذة سلامة', 'كمامة غبار N95', 'نظارات واقية', 'سترة عاكسة'],
  ),
  PermitType(
    'عمل فوق الماء أو قربه',
    Icons.water,
    'OSHA 1926.106',
    [
      'ارتداء سترات نجاة معتمدة لجميع العاملين',
      'توفير أطواق نجاة وحبال إنقاذ على مسافات مناسبة',
      'تجهيز قارب إنقاذ عند العمل فوق مياه عميقة',
      'تأمين مناطق العمل بحواجز ضد السقوط',
      'التحقق من حالة الطقس والتيارات قبل البدء',
    ],
    ['سترة نجاة', 'خوذة سلامة', 'حذاء مانع للانزلاق', 'حبل أمان'],
  ),
  PermitType(
    'عزل الطاقة (LOTO)',
    Icons.lock,
    'OSHA 1910.147',
    [
      'تحديد جميع مصادر الطاقة (كهربائية، هيدروليكية، هوائية، ميكانيكية)',
      'عزل كل مصدر وتركيب قفل وبطاقة شخصية لكل عامل',
      'تفريغ الطاقة المخزّنة (مكثفات، ضغط، نوابض)',
      'التحقق من انعدام الطاقة بمحاولة تشغيل',
      'عدم إزالة الأقفال إلا بواسطة أصحابها بعد انتهاء العمل',
    ],
    ['أقفال وبطاقات شخصية', 'قفازات', 'نظارات واقية', 'خوذة سلامة'],
  ),
];

/* بنود التحقق الميداني — يعبّئها المشرف قبل الاعتماد */
const siteCheckItems = [
  'تم فحص موقع العمل ميدانيًا قبل الاعتماد',
  'الموقع آمن ومستوفٍ لاشتراطات السلامة للعمل المطلوب',
  'معدات الطوارئ والإسعافات الأولية متوفرة وجاهزة في الموقع',
];

const durChoices = [4, 8, 12, 24, 48];

String durLabel(int h) {
  switch (h) {
    case 4:
      return '4 ساعات';
    case 8:
      return '8 ساعات';
    case 12:
      return '12 ساعة';
    case 24:
      return '24 ساعة';
    case 48:
      return '48 ساعة';
  }
  return '$h ساعة';
}

/* ============================ النموذج ============================ */
class Permit {
  final String id;
  final PermitType type;
  final String facility;
  final String department;
  final String location;
  final String description;
  final String requester;
  final String workers;
  final int durationHours;
  String status;
  String supervisor;
  String rejectReason;
  final DateTime createdAt;
  DateTime? approvedAt;
  final List<bool> checks;
  final List<bool> siteChecks;

  Permit({
    required this.id,
    required this.type,
    required this.facility,
    required this.department,
    required this.location,
    required this.description,
    required this.requester,
    required this.workers,
    required this.durationHours,
    this.status = 'بانتظار الاعتماد',
    this.supervisor = '',
    this.rejectReason = '',
    this.approvedAt,
    DateTime? createdAt,
    List<bool>? checks,
    List<bool>? siteChecks,
  })  : createdAt = createdAt ?? DateTime.now(),
        checks = checks ?? List.filled(type.precautions.length, false),
        siteChecks = siteChecks ?? List.filled(siteCheckItems.length, false);

  DateTime? get expiresAt => approvedAt == null
      ? null
      : approvedAt!.add(Duration(hours: durationHours));

  String get effectiveStatus {
    if (status == 'معتمد' &&
        expiresAt != null &&
        DateTime.now().isAfter(expiresAt!)) {
      return 'منتهي';
    }
    return status;
  }

  Duration? get remaining {
    if (status != 'معتمد' || expiresAt == null) return null;
    final d = expiresAt!.difference(DateTime.now());
    return d.isNegative ? Duration.zero : d;
  }
}

/* ============================ المخزن ============================ */
class PermitStore extends ChangeNotifier {
  static final PermitStore I = PermitStore._internal();
  PermitStore._internal() {
    _seed();
  }

  final List<Permit> items = [];
  int _counter = 0;

  String nextId() {
    _counter++;
    return 'PTW-2026-${_counter.toString().padLeft(3, '0')}';
  }

  int get pendingCount =>
      items.where((p) => p.effectiveStatus == 'بانتظار الاعتماد').length;

  void add(Permit p) {
    items.insert(0, p);
    notifyListeners();
  }

  void approve(Permit p, String supervisor) {
    p.status = 'معتمد';
    p.supervisor = supervisor;
    p.approvedAt = DateTime.now();
    notifyListeners();
  }

  void reject(Permit p, String supervisor, String reason) {
    p.status = 'مرفوض';
    p.supervisor = supervisor;
    p.rejectReason = reason;
    notifyListeners();
  }

  void close(Permit p) {
    p.status = 'مقفل';
    notifyListeners();
  }

  void _seed() {
    final t = permitTypes;
    items.addAll([
      Permit(
        id: nextId(),
        type: t[0],
        facility: 'مصنع الشرق للبتروكيماويات',
        department: 'وحدة الغلايات',
        location: 'ورشة الصيانة الرئيسية',
        description: 'أعمال لحام وقطع لأنابيب خط البخار',
        requester: 'سعد القحطاني',
        workers: '3',
        durationHours: 8,
        status: 'معتمد',
        supervisor: 'م. خالد عسيري',
        approvedAt: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        checks: List.filled(t[0].precautions.length, true),
        siteChecks: List.filled(siteCheckItems.length, true),
      ),
      Permit(
        id: nextId(),
        type: t[2],
        facility: 'مصنع الشرق للبتروكيماويات',
        department: 'المرافق والخدمات',
        location: 'خزان المياه الأرضي - المبنى ب',
        description: 'دخول الخزان لأعمال التنظيف والفحص الدوري',
        requester: 'ناصر الشهري',
        workers: '2',
        durationHours: 4,
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      ),
      Permit(
        id: nextId(),
        type: t[6],
        facility: 'مشروع برج المروج',
        department: 'الأعمال الإنشائية',
        location: 'الواجهة الشمالية - الدور 12',
        description: 'رفع ألواح زجاجية بواسطة رافعة برجية',
        requester: 'ماجد آل مفرح',
        workers: '4',
        durationHours: 8,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      Permit(
        id: nextId(),
        type: t[5],
        facility: 'مصنع الشرق للبتروكيماويات',
        department: 'الصيانة الكهربائية',
        location: 'لوحة التوزيع الرئيسية - الدور الأرضي',
        description: 'استبدال قاطع رئيسي وفحص التوصيلات',
        requester: 'فهد الغامدي',
        workers: '2',
        durationHours: 8,
        status: 'مقفل',
        supervisor: 'م. خالد عسيري',
        approvedAt:
            DateTime.now().subtract(const Duration(days: 1, hours: 6)),
        createdAt:
            DateTime.now().subtract(const Duration(days: 1, hours: 7)),
        checks: List.filled(t[5].precautions.length, true),
        siteChecks: List.filled(siteCheckItems.length, true),
      ),
      Permit(
        id: nextId(),
        type: t[3],
        facility: 'مشروع برج المروج',
        department: 'الأعمال المدنية',
        location: 'خلف المستودع الشمالي',
        description: 'حفر خط تصريف بعمق متر ونصف',
        requester: 'صالح عسيري',
        workers: '5',
        durationHours: 24,
        status: 'مرفوض',
        supervisor: 'م. عبدالله الأحمري',
        rejectReason: 'عدم إرفاق مخطط الخدمات المدفونة تحت الأرض',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Permit(
        id: nextId(),
        type: t[4],
        facility: 'مشروع برج المروج',
        department: 'التشطيبات الخارجية',
        location: 'واجهة المبنى الإداري',
        description: 'تركيب لوحة إرشادية على ارتفاع 9 أمتار',
        requester: 'ماجد آل مفرح',
        workers: '3',
        durationHours: 24,
        status: 'معتمد',
        supervisor: 'م. عبدالله الأحمري',
        approvedAt: DateTime.now().subtract(const Duration(hours: 30)),
        createdAt: DateTime.now().subtract(const Duration(hours: 31)),
        checks: List.filled(t[4].precautions.length, true),
        siteChecks: List.filled(siteCheckItems.length, true),
      ),
    ]);
  }
}

/* ============================ أدوات مساعدة ============================ */
BoxDecoration cardBox({double radius = 16}) => BoxDecoration(
      color: cCard,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: softShadow,
    );

InputDecoration _dec(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: cMuted),
      filled: true,
      fillColor: cBg,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cLine),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cLine),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: cGreen, width: 1.4),
      ),
    );

String _two(int n) => n.toString().padLeft(2, '0');

String fmtDT(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)}/${d.year} — ${_two(d.hour)}:${_two(d.minute)}';

String fmtRemain(Duration d) {
  if (d.inMinutes <= 0) return 'انتهت';
  final h = d.inHours;
  final m = d.inMinutes % 60;
  if (h > 0) return '$h ساعة و $m دقيقة';
  return '$m دقيقة';
}

/* ============================ التطبيق ============================ */
class AmanApp extends StatelessWidget {
  const AmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'أمان — تصاريح العمل',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cBg,
        colorScheme: ColorScheme.fromSeed(seedColor: cGreen),
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: RoleGate(),
      ),
    );
  }
}

/* ============================ بوابة اختيار الدور ============================ */
class RoleGate extends StatefulWidget {
  const RoleGate({super.key});

  @override
  State<RoleGate> createState() => _RoleGateState();
}

class _RoleGateState extends State<RoleGate> {
  String? role; // null = شاشة الاختيار | 'emp' موظف | 'sup' مشرف

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return RoleSelectScreen(onPick: (r) => setState(() => role = r));
    }
    if (role == 'sup') {
      return SupervisorShell(onSwitch: () => setState(() => role = null));
    }
    return EmployeeShell(onSwitch: () => setState(() => role = null));
  }
}

class RoleSelectScreen extends StatelessWidget {
  final void Function(String role) onPick;
  const RoleSelectScreen({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cGreenDark, cGreen],
          ),
        ),
        child: Stack(children: [
          Positioned(top: -70, right: -50, child: _deco(210)),
          Positioned(bottom: 90, left: -80, child: _deco(260)),
          Positioned(top: 180, left: 40, child: _deco(90)),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: cGold,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 24,
                              offset: Offset(0, 8)),
                        ],
                      ),
                      child: const Icon(Icons.verified_user,
                          color: cGreenDark, size: 46),
                    ),
                    const SizedBox(height: 18),
                    const Text('أمان',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5)),
                    const SizedBox(height: 5),
                    const Text('نظام تصاريح العمل الآمن — Permit to Work',
                        style:
                            TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 36),
                    _RoleCard(
                      icon: Icons.badge,
                      title: 'بوابة الموظف',
                      desc:
                          'تقديم طلبات تصاريح العمل مع بيانات المنشأة ومتابعة حالتها',
                      onTap: () => onPick('emp'),
                    ),
                    const SizedBox(height: 14),
                    _RoleCard(
                      icon: Icons.engineering,
                      title: 'بوابة المشرف',
                      desc:
                          'مراجعة الطلبات والتحقق الميداني من الموقع واعتماد التصاريح',
                      onTap: () => onPick('sup'),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'الاحتياطات والاشتراطات مصمّمة بالاسترشاد بمعايير\nOSHA · HSE (HSG250) · NEBOSH · IOSH',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white38, fontSize: 11, height: 1.7),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _deco(double s) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.035),
        ),
      );
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title, desc;
  final VoidCallback onTap;
  const _RoleCard(
      {required this.icon,
      required this.title,
      required this.desc,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
                color: Color(0x22000000),
                blurRadius: 22,
                offset: Offset(0, 6)),
          ],
        ),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [cGreen, cGreenLite]),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: cInk)),
                const SizedBox(height: 3),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 11.5, color: cMuted, height: 1.5)),
              ],
            ),
          ),
          const Icon(Icons.arrow_back_ios_new, size: 15, color: cGold),
        ]),
      ),
    );
  }
}

/* ============================ الشريط العلوي المشترك ============================ */
class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onSwitch;
  const _TopBar({required this.title, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: softShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: cGreen,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.verified_user, color: cGold, size: 18),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(title,
              style: const TextStyle(
                  color: cInk, fontSize: 14.5, fontWeight: FontWeight.bold)),
        ),
        TextButton.icon(
          onPressed: onSwitch,
          icon: const Icon(Icons.swap_horiz, color: cGreen, size: 18),
          label: const Text('تبديل الدور',
              style: TextStyle(
                  color: cGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}

/* شريط التنقل السفلي — جزيرة عائمة أنيقة */
class _FloatNav extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onTap;
  final List<NavigationDestination> destinations;
  const _FloatNav(
      {required this.idx, required this.onTap, required this.destinations});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
                color: Color(0x14000000),
                blurRadius: 24,
                offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: cGreen.withOpacity(0.12),
              labelTextStyle: WidgetStateProperty.resolveWith(
                (states) => TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: states.contains(WidgetState.selected)
                      ? cGreen
                      : cMuted,
                ),
              ),
            ),
            child: NavigationBar(
              height: 68,
              selectedIndex: idx,
              onDestinationSelected: onTap,
              destinations: destinations,
            ),
          ),
        ),
      ),
    );
  }
}

/* ════════════════════════════ بوابة الموظف ════════════════════════════ */
class EmployeeShell extends StatefulWidget {
  final VoidCallback onSwitch;
  const EmployeeShell({super.key, required this.onSwitch});

  @override
  State<EmployeeShell> createState() => _EmployeeShellState();
}

class _EmployeeShellState extends State<EmployeeShell> {
  int idx = 0;

  void goTo(int i) => setState(() => idx = i);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PermitStore.I,
      builder: (_, __) {
        final pages = [
          EmployeeHome(onNew: () => goTo(1), onSeeAll: () => goTo(2)),
          NewPermitScreen(onDone: () => goTo(2)),
          const PermitsScreen(isSupervisor: false),
          const AboutScreen(),
        ];
        return Scaffold(
          backgroundColor: cBg,
          body: SafeArea(
            child: Column(children: [
              _TopBar(title: 'أمان — بوابة الموظف', onSwitch: widget.onSwitch),
              Expanded(child: pages[idx]),
            ]),
          ),
          bottomNavigationBar: _FloatNav(
            idx: idx,
            onTap: goTo,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: cMuted),
                  selectedIcon: Icon(Icons.home, color: cGreen),
                  label: 'الرئيسية'),
              NavigationDestination(
                  icon: Icon(Icons.post_add_outlined, color: cMuted),
                  selectedIcon: Icon(Icons.post_add, color: cGreen),
                  label: 'طلب جديد'),
              NavigationDestination(
                  icon: Icon(Icons.assignment_outlined, color: cMuted),
                  selectedIcon: Icon(Icons.assignment, color: cGreen),
                  label: 'الطلبات'),
              NavigationDestination(
                  icon: Icon(Icons.info_outline, color: cMuted),
                  selectedIcon: Icon(Icons.info, color: cGreen),
                  label: 'عن التطبيق'),
            ],
          ),
        );
      },
    );
  }
}

class EmployeeHome extends StatelessWidget {
  final VoidCallback onNew;
  final VoidCallback onSeeAll;
  const EmployeeHome({super.key, required this.onNew, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final items = PermitStore.I.items;
    final pending =
        items.where((p) => p.effectiveStatus == 'بانتظار الاعتماد').length;
    final active = items.where((p) => p.effectiveStatus == 'معتمد').length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _Head('الرئيسية', 'تقديم طلبات تصاريح العمل ومتابعتها'),
        const SizedBox(height: 16),
        Row(children: [
          _Stat('بانتظار الاعتماد', pending, cPending, Icons.hourglass_top),
          const SizedBox(width: 10),
          _Stat('تصاريح سارية', active, cApproved, Icons.verified),
        ]),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: cardBox(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [
                Icon(Icons.tips_and_updates, color: cGold, size: 19),
                SizedBox(width: 7),
                Text('قبل تقديم الطلب',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: cInk)),
              ]),
              const SizedBox(height: 10),
              const Text(
                '• حدّد نوع العمل بدقة ليظهر لك الاحتياطات ومعدات الوقاية المطلوبة.\n'
                '• اكتب بيانات المنشأة والموقع الدقيق ليتمكّن المشرف من التحقق الميداني.\n'
                '• لن يُعتمد التصريح إلا بعد تحقق المشرف من الموقع واستيفاء جميع الاحتياطات.',
                style: TextStyle(fontSize: 12, height: 1.9, color: cInk),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: cGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: onNew,
                  icon: const Icon(Icons.post_add, size: 19),
                  label: const Text('تقديم طلب تصريح جديد',
                      style: TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _Card(
          title: 'أحدث الطلبات',
          child: Column(children: [
            for (final p in items.take(4)) _PermitTile(p),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: onSeeAll,
                child: const Text('عرض كل الطلبات',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cGreen,
                        fontSize: 12.5)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

/* ════════════════════════════ بوابة المشرف ════════════════════════════ */
class SupervisorShell extends StatefulWidget {
  final VoidCallback onSwitch;
  const SupervisorShell({super.key, required this.onSwitch});

  @override
  State<SupervisorShell> createState() => _SupervisorShellState();
}

class _SupervisorShellState extends State<SupervisorShell> {
  int idx = 0;

  void goTo(int i) => setState(() => idx = i);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: PermitStore.I,
      builder: (_, __) {
        final pending = PermitStore.I.pendingCount;
        final pages = [
          DashboardScreen(onSeeAll: () => goTo(2)),
          const PendingScreen(),
          const PermitsScreen(isSupervisor: true),
          const AboutScreen(),
        ];
        return Scaffold(
          backgroundColor: cBg,
          body: SafeArea(
            child: Column(children: [
              _TopBar(title: 'أمان — بوابة المشرف', onSwitch: widget.onSwitch),
              Expanded(child: pages[idx]),
            ]),
          ),
          bottomNavigationBar: _FloatNav(
            idx: idx,
            onTap: goTo,
            destinations: [
              const NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined, color: cMuted),
                  selectedIcon: Icon(Icons.dashboard, color: cGreen),
                  label: 'لوحة المعلومات'),
              NavigationDestination(
                  icon: Badge(
                    isLabelVisible: pending > 0,
                    backgroundColor: cGold,
                    textColor: cGreenDark,
                    label: Text('$pending',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    child: const Icon(Icons.pending_actions_outlined,
                        color: cMuted),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible: pending > 0,
                    backgroundColor: cGold,
                    textColor: cGreenDark,
                    label: Text('$pending',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    child:
                        const Icon(Icons.pending_actions, color: cGreen),
                  ),
                  label: 'الاعتماد'),
              const NavigationDestination(
                  icon: Icon(Icons.assignment_outlined, color: cMuted),
                  selectedIcon: Icon(Icons.assignment, color: cGreen),
                  label: 'التصاريح'),
              const NavigationDestination(
                  icon: Icon(Icons.info_outline, color: cMuted),
                  selectedIcon: Icon(Icons.info, color: cGreen),
                  label: 'عن التطبيق'),
            ],
          ),
        );
      },
    );
  }
}

/* ============================ لوحة المعلومات (مشرف) ============================ */
class DashboardScreen extends StatelessWidget {
  final VoidCallback onSeeAll;
  const DashboardScreen({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final items = PermitStore.I.items;
    final active = items.where((p) => p.effectiveStatus == 'معتمد').length;
    final pending =
        items.where((p) => p.effectiveStatus == 'بانتظار الاعتماد').length;
    final expired = items.where((p) => p.effectiveStatus == 'منتهي').length;
    final total = items.length;
    final counts = [
      for (final t in permitTypes)
        items.where((p) => p.type.name == t.name).length
    ];
    final maxC = counts.fold<int>(0, (a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _Head('لوحة المعلومات', 'نظرة عامة على تصاريح العمل'),
        const SizedBox(height: 16),
        Row(children: [
          _Stat('سارية الآن', active, cApproved, Icons.verified),
          const SizedBox(width: 10),
          _Stat('بانتظار الاعتماد', pending, cPending, Icons.hourglass_top),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          _Stat('منتهية الصلاحية', expired, cExpired, Icons.timer_off),
          const SizedBox(width: 10),
          _Stat('إجمالي التصاريح', total, cClosed, Icons.assignment),
        ]),
        const SizedBox(height: 14),
        _Card(
          title: 'التصاريح حسب نوع العمل',
          child: Column(children: [
            for (int i = 0; i < permitTypes.length; i++)
              if (counts[i] > 0) _typeBar(permitTypes[i], counts[i], maxC),
          ]),
        ),
        _Card(
          title: 'أحدث التصاريح',
          child: Column(children: [
            for (final p in items.take(4)) _PermitTile(p, sup: true),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: onSeeAll,
                child: const Text('عرض كل التصاريح',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: cGreen,
                        fontSize: 12.5)),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

Widget _typeBar(PermitType t, int count, int maxC) {
  final f = maxC == 0 ? 0.0 : count / maxC;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Row(children: [
      SizedBox(
          width: 130,
          child: Text(t.name,
              style: const TextStyle(fontSize: 11.5, color: cInk),
              maxLines: 1,
              overflow: TextOverflow.ellipsis)),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 8,
            color: cTrack,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: f,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [cGreen, cGreenLite]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(width: 8),
      Text('$count',
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: cInk)),
    ]),
  );
}

/* ============================ طابور الاعتماد (مشرف) ============================ */
class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final list = PermitStore.I.items
        .where((p) => p.effectiveStatus == 'بانتظار الاعتماد')
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Head('طلبات بانتظار الاعتماد',
            'عدد الطلبات المعلّقة: ${list.length}'),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 60),
            child: Center(
              child: Column(children: [
                Icon(Icons.task_alt, size: 48, color: cApproved),
                SizedBox(height: 10),
                Text('لا توجد طلبات معلّقة — كل الطلبات تمت مراجعتها',
                    style: TextStyle(color: cMuted, fontSize: 13)),
              ]),
            ),
          )
        else ...[
          const _Banner(
            color: cPending,
            icon: Icons.fact_check,
            text:
                'افتح كل طلب للتحقق الميداني من الموقع والتأكد من استيفاء احتياطات السلامة قبل الاعتماد.',
          ),
          for (final p in list) _PermitTile(p, sup: true),
        ],
        const SizedBox(height: 10),
      ],
    );
  }
}

/* ============================ طلب جديد (موظف) ============================ */
class NewPermitScreen extends StatefulWidget {
  final VoidCallback onDone;
  const NewPermitScreen({super.key, required this.onDone});

  @override
  State<NewPermitScreen> createState() => _NewPermitScreenState();
}

class _NewPermitScreenState extends State<NewPermitScreen> {
  int typeIdx = 0;
  int dur = 8;
  final facCtrl = TextEditingController();
  final depCtrl = TextEditingController();
  final locCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final reqCtrl = TextEditingController();
  final wrkCtrl = TextEditingController();

  @override
  void dispose() {
    facCtrl.dispose();
    depCtrl.dispose();
    locCtrl.dispose();
    descCtrl.dispose();
    reqCtrl.dispose();
    wrkCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (facCtrl.text.trim().isEmpty ||
        depCtrl.text.trim().isEmpty ||
        locCtrl.text.trim().isEmpty ||
        descCtrl.text.trim().isEmpty ||
        reqCtrl.text.trim().isEmpty ||
        wrkCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('يرجى تعبئة جميع بيانات المنشأة والعمل')),
      );
      return;
    }
    PermitStore.I.add(Permit(
      id: PermitStore.I.nextId(),
      type: permitTypes[typeIdx],
      facility: facCtrl.text.trim(),
      department: depCtrl.text.trim(),
      location: locCtrl.text.trim(),
      description: descCtrl.text.trim(),
      requester: reqCtrl.text.trim(),
      workers: wrkCtrl.text.trim(),
      durationHours: dur,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('تم إرسال الطلب — بانتظار تحقق المشرف واعتماده')),
    );
    facCtrl.clear();
    depCtrl.clear();
    locCtrl.clear();
    descCtrl.clear();
    reqCtrl.clear();
    wrkCtrl.clear();
    setState(() {
      typeIdx = 0;
      dur = 8;
    });
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    final t = permitTypes[typeIdx];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _Head('طلب تصريح جديد', 'عبّئ بيانات المنشأة والعمل المطلوب'),
        const SizedBox(height: 16),
        _Card(
          title: 'نوع العمل (12 نوعًا)',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (int i = 0; i < permitTypes.length; i++)
                ChoiceChip(
                  selected: typeIdx == i,
                  onSelected: (_) => setState(() => typeIdx = i),
                  showCheckmark: false,
                  avatar: Icon(permitTypes[i].icon,
                      size: 17,
                      color: typeIdx == i ? cGold : cGreen),
                  label: Text(permitTypes[i].name),
                  labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: typeIdx == i ? Colors.white : cInk),
                  selectedColor: cGreen,
                  backgroundColor: cBg,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  side: BorderSide(
                      color: typeIdx == i ? cGreen : cLine),
                ),
            ],
          ),
        ),
        _Card(
          title: 'بيانات المنشأة',
          child: Column(children: [
            TextField(
                controller: facCtrl,
                decoration: _dec('اسم المنشأة / الشركة')),
            const SizedBox(height: 10),
            TextField(
                controller: depCtrl,
                decoration: _dec('القسم / المنطقة داخل المنشأة')),
            const SizedBox(height: 10),
            TextField(
                controller: locCtrl,
                decoration: _dec('الموقع الدقيق للعمل (مبنى، دور، وحدة...)')),
          ]),
        ),
        _Card(
          title: 'بيانات العمل',
          child: Column(children: [
            TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: _dec('وصف العمل المطلوب')),
            const SizedBox(height: 10),
            TextField(
                controller: reqCtrl,
                decoration: _dec('اسم مقدّم الطلب / منفّذ العمل')),
            const SizedBox(height: 10),
            TextField(
                controller: wrkCtrl,
                keyboardType: TextInputType.number,
                decoration: _dec('عدد العمال المشاركين')),
          ]),
        ),
        _Card(
          title: 'مدة صلاحية التصريح',
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final h in durChoices)
                      ChoiceChip(
                        selected: dur == h,
                        onSelected: (_) => setState(() => dur = h),
                        showCheckmark: false,
                        label: Text(durLabel(h)),
                        labelStyle: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: dur == h ? Colors.white : cInk),
                        selectedColor: cGreen,
                        backgroundColor: cBg,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11)),
                        side: BorderSide(
                            color: dur == h ? cGreen : cLine),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('تبدأ الصلاحية من لحظة اعتماد المشرف للتصريح.',
                    style: TextStyle(fontSize: 11.5, color: cMuted)),
              ]),
        ),
        _Card(
          title: 'معدات الوقاية الشخصية المطلوبة',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final e in t.ppe) _PpeChip(e)],
          ),
        ),
        _Card(
          title: 'احتياطات السلامة — ${t.name}',
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: cGold.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('المرجعية: ${t.std}',
                      style: const TextStyle(
                          fontSize: 10.5,
                          color: cExpired,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 10),
                for (final pr in t.precautions)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.shield_outlined,
                              size: 16, color: cGreen),
                          const SizedBox(width: 7),
                          Expanded(
                              child: Text(pr,
                                  style: const TextStyle(
                                      fontSize: 12.5,
                                      height: 1.6,
                                      color: cInk))),
                        ]),
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cGreen.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'لن يُعتمد التصريح إلا بعد تحقق المشرف ميدانيًا من الموقع ومن توفر جميع الاحتياطات أعلاه.',
                    style: TextStyle(
                        fontSize: 11.5, height: 1.6, color: cGreen),
                  ),
                ),
              ]),
        ),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: cGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _submit,
            child: const Text('إرسال الطلب للمشرف',
                style:
                    TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _PpeChip extends StatelessWidget {
  final String text;
  const _PpeChip(this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cGreen.withOpacity(0.07),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.health_and_safety, size: 14, color: cGreen),
          const SizedBox(width: 5),
          Text(text,
              style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: cInk)),
        ]),
      );
}

/* ============================ قائمة التصاريح ============================ */
class PermitsScreen extends StatefulWidget {
  final bool isSupervisor;
  const PermitsScreen({super.key, required this.isSupervisor});

  @override
  State<PermitsScreen> createState() => _PermitsScreenState();
}

class _PermitsScreenState extends State<PermitsScreen> {
  String filter = 'الكل';
  static const filters = [
    'الكل',
    'بانتظار الاعتماد',
    'معتمد',
    'منتهي',
    'مقفل',
    'مرفوض'
  ];

  @override
  Widget build(BuildContext context) {
    final items = PermitStore.I.items;
    final list = filter == 'الكل'
        ? items
        : items.where((p) => p.effectiveStatus == filter).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _Head('التصاريح',
            widget.isSupervisor ? 'سجل جميع التصاريح' : 'متابعة حالة طلباتك'),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            for (final f in filters)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: ChoiceChip(
                  selected: filter == f,
                  onSelected: (_) => setState(() => filter = f),
                  showCheckmark: false,
                  label: Text(f),
                  labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: filter == f ? Colors.white : cInk),
                  selectedColor: cGreen,
                  backgroundColor: cCard,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  side: BorderSide(color: filter == f ? cGreen : cLine),
                ),
              ),
          ]),
        ),
        const SizedBox(height: 14),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Center(
              child: Column(children: [
                Icon(Icons.assignment_outlined, size: 46, color: cMuted),
                SizedBox(height: 8),
                Text('لا توجد تصاريح بهذه الحالة',
                    style: TextStyle(color: cMuted, fontSize: 13)),
              ]),
            ),
          )
        else
          for (final p in list) _PermitTile(p, sup: widget.isSupervisor),
        const SizedBox(height: 10),
      ],
    );
  }
}

/* ============================ بطاقة تصريح ============================ */
class _PermitTile extends StatelessWidget {
  final Permit p;
  final bool sup;
  const _PermitTile(this.p, {this.sup = false});

  @override
  Widget build(BuildContext context) {
    final st = p.effectiveStatus;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) =>
                PermitDetailScreen(permit: p, isSupervisor: sup)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: cardBox(),
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: cGreen.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(p.type.icon, color: cGreen, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                        child: Text(p.id,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                                color: cInk))),
                    _Badge(st, statusColor(st)),
                  ]),
                  const SizedBox(height: 3),
                  Text('${p.type.name} — ${p.facility}',
                      style: const TextStyle(fontSize: 12, color: cMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  if (st == 'معتمد' && p.remaining != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text('متبقي: ${fmtRemain(p.remaining!)}',
                          style: const TextStyle(
                              fontSize: 11.5,
                              color: cApproved,
                              fontWeight: FontWeight.w600)),
                    ),
                ]),
          ),
        ]),
      ),
    );
  }
}

/* ============================ تفاصيل التصريح ============================ */
class PermitDetailScreen extends StatefulWidget {
  final Permit permit;
  final bool isSupervisor;
  const PermitDetailScreen(
      {super.key, required this.permit, required this.isSupervisor});

  @override
  State<PermitDetailScreen> createState() => _PermitDetailScreenState();
}

class _PermitDetailScreenState extends State<PermitDetailScreen> {
  final supCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    supCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    supCtrl.dispose();
    super.dispose();
  }

  void _approve() {
    PermitStore.I.approve(widget.permit, supCtrl.text.trim());
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم اعتماد التصريح وبدأت صلاحيته الآن')),
    );
  }

  Future<void> _rejectDialog() async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (dctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
          title: const Text('رفض التصريح',
              style: TextStyle(fontSize: 16, color: cInk)),
          content: TextField(
            controller: ctrl,
            decoration: _dec('سبب الرفض'),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dctx, false),
                child:
                    const Text('إلغاء', style: TextStyle(color: cMuted))),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: cRejected),
              onPressed: () => Navigator.pop(dctx, true),
              child: const Text('رفض التصريح'),
            ),
          ],
        ),
      ),
    );
    if (ok == true) {
      PermitStore.I
          .reject(widget.permit, supCtrl.text.trim(), ctrl.text.trim());
      if (mounted) setState(() {});
    }
  }

  void _close() {
    PermitStore.I.close(widget.permit);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم إقفال التصريح')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.permit;
    final st = p.effectiveStatus;
    final isSup = widget.isSupervisor;
    final allSite = p.siteChecks.every((c) => c);
    final allChecked = p.checks.every((c) => c);
    final canApprove =
        allSite && allChecked && supCtrl.text.trim().isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cBg,
        appBar: AppBar(
          backgroundColor: cGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          title: Text(p.id, style: const TextStyle(fontSize: 16)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: cardBox(),
              child: Row(children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      color: cGreen.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(13)),
                  child: Icon(p.type.icon, color: cGreen, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.type.name,
                            style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.bold,
                                color: cInk)),
                        const SizedBox(height: 3),
                        Text(p.facility,
                            style: const TextStyle(
                                fontSize: 12.5, color: cMuted)),
                      ]),
                ),
                _Badge(st, statusColor(st)),
              ]),
            ),
            if (st == 'بانتظار الاعتماد' && !isSup)
              const _Banner(
                color: cPending,
                icon: Icons.hourglass_top,
                text:
                    'الطلب قيد مراجعة المشرف — سيتم التحقق ميدانيًا من الموقع واستيفاء الاحتياطات قبل الاعتماد.',
              ),
            if (st == 'معتمد')
              _Banner(
                color: cApproved,
                icon: Icons.timer,
                text:
                    'التصريح ساري — متبقي على انتهاء الصلاحية: ${fmtRemain(p.remaining ?? Duration.zero)}',
              ),
            if (st == 'منتهي')
              const _Banner(
                color: cExpired,
                icon: Icons.timer_off,
                text:
                    'انتهت صلاحية هذا التصريح. أوقف العمل أو تقدّم بطلب تصريح جديد.',
              ),
            if (st == 'مرفوض')
              _Banner(
                color: cRejected,
                icon: Icons.block,
                text: p.rejectReason.isEmpty
                    ? 'تم رفض هذا التصريح.'
                    : 'تم رفض التصريح — السبب: ${p.rejectReason}',
              ),
            _Card(
              title: 'بيانات المنشأة والعمل',
              child: Column(children: [
                _InfoRow('المنشأة', p.facility),
                _InfoRow('القسم / المنطقة', p.department),
                _InfoRow('الموقع الدقيق', p.location),
                _InfoRow('مقدّم الطلب', p.requester),
                _InfoRow('عدد العمال', p.workers),
                _InfoRow('تاريخ الطلب', fmtDT(p.createdAt)),
                _InfoRow('مدة الصلاحية', durLabel(p.durationHours)),
                _InfoRow('المرجعية', p.type.std),
                if (p.approvedAt != null) ...[
                  _InfoRow('المشرف المعتمِد', p.supervisor),
                  _InfoRow('وقت الاعتماد', fmtDT(p.approvedAt!)),
                  _InfoRow('ينتهي في', fmtDT(p.expiresAt!)),
                ],
              ]),
            ),
            _Card(
              title: 'وصف العمل',
              child: Text(p.description,
                  style: const TextStyle(
                      fontSize: 13, height: 1.8, color: cInk)),
            ),
            _Card(
              title: 'معدات الوقاية الشخصية المطلوبة',
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final e in p.type.ppe) _PpeChip(e)],
              ),
            ),
            /* ═══ التحقق الميداني من الموقع ═══ */
            _Card(
              title: 'التحقق الميداني من الموقع',
              child: (st == 'بانتظار الاعتماد' && isSup)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'قم بزيارة الموقع وتأكد من البنود التالية قبل الاعتماد:',
                          style: TextStyle(fontSize: 11.5, color: cMuted),
                        ),
                        const SizedBox(height: 4),
                        for (int i = 0; i < siteCheckItems.length; i++)
                          CheckboxListTile(
                            value: p.siteChecks[i],
                            onChanged: (v) => setState(
                                () => p.siteChecks[i] = v ?? false),
                            title: Text(siteCheckItems[i],
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    height: 1.5,
                                    color: cInk)),
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            activeColor: cGreen,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                      ],
                    )
                  : Column(children: [
                      for (int i = 0; i < siteCheckItems.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  p.siteChecks[i]
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 17,
                                  color: p.siteChecks[i]
                                      ? cGreen
                                      : cMuted,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(siteCheckItems[i],
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          height: 1.5,
                                          color: cInk)),
                                ),
                              ]),
                        ),
                    ]),
            ),
            /* ═══ احتياطات السلامة ═══ */
            _Card(
              title: 'احتياطات السلامة — ${p.type.name}',
              child: (st == 'بانتظار الاعتماد' && isSup)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < p.type.precautions.length; i++)
                          CheckboxListTile(
                            value: p.checks[i],
                            onChanged: (v) =>
                                setState(() => p.checks[i] = v ?? false),
                            title: Text(p.type.precautions[i],
                                style: const TextStyle(
                                    fontSize: 12.5,
                                    height: 1.5,
                                    color: cInk)),
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            activeColor: cGreen,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        const SizedBox(height: 6),
                        Text(
                          'تم التحقق من ${p.checks.where((c) => c).length} من ${p.checks.length} احتياطات',
                          style: const TextStyle(
                              fontSize: 11.5, color: cMuted),
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: p.checks.isEmpty
                                ? 0
                                : p.checks.where((c) => c).length /
                                    p.checks.length,
                            minHeight: 8,
                            color: cGreen,
                            backgroundColor: cTrack,
                          ),
                        ),
                      ],
                    )
                  : Column(children: [
                      for (int i = 0; i < p.type.precautions.length; i++)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  p.checks[i]
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 17,
                                  color:
                                      p.checks[i] ? cGreen : cMuted,
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: Text(p.type.precautions[i],
                                      style: const TextStyle(
                                          fontSize: 12.5,
                                          height: 1.5,
                                          color: cInk)),
                                ),
                              ]),
                        ),
                    ]),
            ),
            /* ═══ اعتماد المشرف ═══ */
            if (st == 'بانتظار الاعتماد' && isSup)
              _Card(
                title: 'قرار المشرف',
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                          controller: supCtrl,
                          decoration: _dec('اسم المشرف المعتمِد')),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: cGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            onPressed: canApprove ? _approve : null,
                            child: const Text('اعتماد التصريح',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: cRejected,
                              side: const BorderSide(color: cRejected),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12)),
                            ),
                            onPressed: _rejectDialog,
                            child: const Text('رفض',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ]),
                      if (!canApprove) ...[
                        const SizedBox(height: 8),
                        Text(
                          !allSite
                              ? 'أكمل بنود التحقق الميداني من الموقع أولًا.'
                              : !allChecked
                                  ? 'لا يمكن الاعتماد قبل التحقق من جميع احتياطات السلامة.'
                                  : 'أدخل اسم المشرف لتفعيل زر الاعتماد.',
                          style: const TextStyle(
                              fontSize: 11.5, color: cRejected),
                        ),
                      ],
                    ]),
              ),
            if ((st == 'معتمد' || st == 'منتهي') && isSup)
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: cInk,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _close,
                  child: const Text('إقفال التصريح (انتهاء العمل)',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

/* ============================ عن التطبيق ============================ */
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _Head('عن التطبيق', 'معلومات المشروع وحقوق الملكية'),
        const SizedBox(height: 16),
        Center(
          child: Column(children: [
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [cGreen, cGreenLite]),
                borderRadius: BorderRadius.circular(22),
                boxShadow: softShadow,
              ),
              child:
                  const Icon(Icons.verified_user, color: cGold, size: 42),
            ),
            const SizedBox(height: 12),
            const Text('أمان',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: cInk)),
            const Text('نظام تصاريح العمل الآمن (Permit to Work)',
                style: TextStyle(fontSize: 13, color: cMuted),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: cGold.withOpacity(0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('الإصدار 2.1 — نظام ثنائي البوابات',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: cExpired)),
            ),
          ]),
        ),
        const SizedBox(height: 22),
        _Card(
          title: 'معلومات المشروع',
          child: Column(children: const [
            _AboutRow('المطوّر', 'محمد عبدالمجيد البارقي'),
            _AboutRow('التخصص', 'هندسة السلامة والصحة المهنية'),
            _AboutRow('نوع المشروع', 'تطبيق ويب — منظومة السلامة'),
            _AboutRow('التقنيات', 'Flutter · Dart'),
            _AboutRow('سنة التطوير', '2026'),
          ]),
        ),
        _Card(
          title: 'فكرة المشروع',
          child: const Text(
            'نظام متكامل لإدارة تصاريح العمل الخطر يغطي 12 نوعًا من التصاريح '
            '(العمل الساخن والبارد، الأماكن المغلقة، الحفريات، الارتفاعات، الكهرباء، '
            'الرفع، الإشعاع، المواد الكيميائية، الهدم، العمل قرب الماء، وعزل الطاقة). '
            'يعمل بنظام بوابتين: بوابة الموظف لتقديم الطلبات ببيانات المنشأة، '
            'وبوابة المشرف للتحقق الميداني من سلامة الموقع واستيفاء الاحتياطات قبل الاعتماد.',
            style: TextStyle(height: 1.8, fontSize: 13.5, color: cInk),
          ),
        ),
        _Card(
          title: 'المرجعية والمعايير',
          child: const Text(
            'رُوعي في تصميم الاحتياطات وبنود التحقق الاسترشاد بالمعايير والممارسات '
            'الدولية في السلامة المهنية، ومنها: معايير الإدارة الأمريكية للسلامة '
            'والصحة المهنية (OSHA 29 CFR)، ودليل أنظمة تصاريح العمل الصادر عن '
            'الهيئة البريطانية (HSE HSG250)، ومعايير NFPA، إضافة إلى منهجيات '
            'NEBOSH وIOSH في إدارة سلامة الأعمال الخطرة.',
            style: TextStyle(height: 1.8, fontSize: 13, color: cInk),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [cGreenDark, cGreen]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: softShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [
                Icon(Icons.copyright, color: cGold, size: 18),
                SizedBox(width: 6),
                Text('حقوق الملكية الفكرية',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ]),
              const SizedBox(height: 10),
              const Text(
                '© 2026 محمد عبدالمجيد البارقي. جميع الحقوق محفوظة.',
                style: TextStyle(
                    color: Colors.white, fontSize: 13, height: 1.7),
              ),
              const SizedBox(height: 6),
              const Text(
                'جميع حقوق هذا التطبيق (الكود المصدري، التصميم، والفكرة التنفيذية) '
                'مملوكة للمؤلّف ومحفوظة بموجب حقوق المؤلف. يُمنع نسخ أو إعادة توزيع '
                'الكود دون إذن من المؤلّف.',
                style: TextStyle(
                    color: Colors.white70, fontSize: 12, height: 1.7),
              ),
            ],
          ),
        ),
        const Center(
          child: Text('جزء من منظومة تطبيقات السلامة: حارس · أمان',
              style: TextStyle(fontSize: 11.5, color: cMuted)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/* ============================ عناصر مشتركة ============================ */
class _Head extends StatelessWidget {
  final String title, sub;
  const _Head(this.title, this.sub);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: cInk)),
          const SizedBox(height: 6),
          Container(
            width: 34,
            height: 3.5,
            decoration: BoxDecoration(
              color: cGold,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(sub, style: const TextStyle(fontSize: 12.5, color: cMuted)),
        ],
      );
}

class _Card extends StatelessWidget {
  final String? title;
  final Widget child;
  const _Card({this.title, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: cardBox(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(title!,
                  style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: cInk)),
              const SizedBox(height: 12),
            ],
            child,
          ],
        ),
      );
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(text,
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700, color: color)),
      );
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final IconData icon;
  const _Stat(this.label, this.value, this.color, this.icon);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: cardBox(),
          child: Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$value',
                      style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: cInk)),
                  Text(label,
                      style:
                          const TextStyle(fontSize: 11, color: cMuted),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ]),
        ),
      );
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 110,
                child: Text(label,
                    style:
                        const TextStyle(color: cMuted, fontSize: 12.5))),
            Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: cInk)),
            ),
          ],
        ),
      );
}

class _Banner extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  const _Banner(
      {required this.color, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: color, size: 19),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    fontSize: 12.5,
                    height: 1.6,
                    color: color,
                    fontWeight: FontWeight.w600)),
          ),
        ]),
      );
}

class _AboutRow extends StatelessWidget {
  final String label, value;
  const _AboutRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: cMuted, fontSize: 13.5)),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                      color: cInk)),
            ),
          ],
        ),
      );
}
