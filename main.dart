import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BacEcoApp());
}

const bg = Color(0xFF0B0714);
const panel = Color(0xFF191129);
const purple = Color(0xFF9B5CFF);
const softPurple = Color(0xFFC9A7FF);
const gold = Color(0xFFFFD166);
const green = Color(0xFF42D6B5);

class Question {
  final String text;
  final List<String> options;
  final int answer;
  final String explanation;
  const Question(this.text, this.options, this.answer, this.explanation);
}

class Lesson {
  final String title;
  final String description;
  final List<Question> questions;
  const Lesson(this.title, this.description, this.questions);
}

class Unit {
  final String title;
  final List<Lesson> lessons;
  const Unit(this.title, this.lessons);
}

class Subject {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<Unit> units;
  const Subject(this.title, this.subtitle, this.icon, this.color, this.units);
}

const demoQuestionsEconomics = [
  Question(
    'ما المشكلة الاقتصادية الأساسية؟',
    ['ندرة الموارد وتعدد الحاجات', 'وفرة الموارد بلا حدود', 'غياب الحاجات الإنسانية', 'انعدام الإنتاج'],
    0,
    'تنشأ المشكلة الاقتصادية من ندرة الموارد مقارنة بتعدد الحاجات.',
  ),
  Question(
    'ماذا نقصد بالإنتاج؟',
    ['استهلاك السلع فقط', 'تحويل الموارد إلى سلع وخدمات', 'تخزين النقود فقط', 'تقليل الحاجات'],
    1,
    'الإنتاج نشاط يهدف إلى توفير السلع والخدمات لتلبية الحاجات.',
  ),
];

const demoQuestionsAccounting = [
  Question(
    'ماذا تمثل الأصول في الميزانية؟',
    ['موارد المؤسسة وممتلكاتها', 'الديون فقط', 'المصاريف فقط', 'الإيرادات فقط'],
    0,
    'تمثل الأصول الموارد الاقتصادية التي تملكها المؤسسة أو تسيطر عليها.',
  ),
  Question(
    'ما العلاقة الأساسية في الميزانية؟',
    ['الأصول = الخصوم', 'الأصول = الإيرادات فقط', 'المصاريف = الأصول دائمًا', 'الخزينة = رأس المال دائمًا'],
    0,
    'تتوازن الميزانية عندما يساوي مجموع الأصول مجموع الخصوم.',
  ),
];

const demoQuestionsLaw = [
  Question(
    'ما إحدى خصائص القاعدة القانونية؟',
    ['تنظم سلوك الأفراد في المجتمع', 'نصيحة شخصية فقط', 'اختيارية دائمًا', 'لا تنظم العلاقات الاجتماعية'],
    0,
    'تنظم القاعدة القانونية سلوك الأفراد وعلاقاتهم داخل المجتمع.',
  ),
  Question(
    'ما الغاية الأساسية من القانون؟',
    ['تنظيم العلاقات وحماية الحقوق', 'إلغاء جميع الحقوق', 'منع كل المعاملات', 'تنظيم الرياضة فقط'],
    0,
    'يساهم القانون في تنظيم العلاقات وحماية الحقوق وتحقيق النظام.',
  ),
];

const subjects = <Subject>[
  Subject('الاقتصاد', 'مفاهيم وتحليل اقتصادي', Icons.trending_up_rounded, purple, [
    Unit('الوحدة الأولى: مبادئ الاقتصاد', [
      Lesson('مفهوم الاقتصاد', 'أسئلة تمهيدية في المفاهيم الاقتصادية.', demoQuestionsEconomics),
    ]),
  ]),
  Subject('التسيير المحاسبي والمالي', 'المحاسبة والعمليات المالية', Icons.calculate_rounded, green, [
    Unit('الوحدة الأولى: المبادئ المحاسبية', [
      Lesson('الميزانية', 'مراجعة تمهيدية للأصول والخصوم.', demoQuestionsAccounting),
    ]),
  ]),
  Subject('القانون', 'القواعد القانونية والمفاهيم الأساسية', Icons.gavel_rounded, gold, [
    Unit('الوحدة الأولى: مدخل إلى القانون', [
      Lesson('القاعدة القانونية', 'أسئلة تمهيدية حول القانون.', demoQuestionsLaw),
    ]),
  ]),
];

class Store {
  static Future<int> points() async =>
      (await SharedPreferences.getInstance()).getInt('points') ?? 0;

  static Future<int> completedCount() async =>
      ((await SharedPreferences.getInstance()).getStringList('completed') ?? []).length;

  static Future<bool> isCompleted(String id) async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList('completed') ?? []).contains(id);
  }

  static Future<void> addPoints(int amount) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('points', (p.getInt('points') ?? 0) + amount);
  }

  static Future<void> complete(String id) async {
    final p = await SharedPreferences.getInstance();
    final list = p.getStringList('completed') ?? [];
    if (!list.contains(id)) {
      list.add(id);
      await p.setStringList('completed', list);
      await addPoints(25);
    }
  }
}

class BacEcoApp extends StatelessWidget {
  const BacEcoApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Bac Éco Challenge',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: Brightness.dark),
      useMaterial3: true,
    ),
    home: const MainShell(),
  );
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0;
  int refresh = 0;
  void updated() => setState(() => refresh++);
  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onOpenSubjects: () => setState(() => tab = 1), refresh: refresh),
      SubjectsPage(onProgressChanged: updated),
      RewardsPage(refresh: refresh),
      const DeveloperPage(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        backgroundColor: panel,
        indicatorColor: purple.withOpacity(.25),
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'الرئيسية'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'المواد'),
          NavigationDestination(icon: Icon(Icons.emoji_events_rounded), label: 'المكافآت'),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: 'المطوّر'),
        ],
      ),
    );
  }
}

Widget heading(String title, {String? subtitle}) => Padding(
  padding: const EdgeInsets.only(bottom: 14),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
    if (subtitle != null) ...[
      const SizedBox(height: 5),
      Text(subtitle, style: const TextStyle(color: Colors.white60)),
    ],
  ]),
);

Widget panelCard({required Widget child, Color? borderColor}) => Container(
  width: double.infinity,
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: panel,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: (borderColor ?? purple).withOpacity(.35)),
  ),
  child: child,
);

class HomePage extends StatefulWidget {
  final VoidCallback onOpenSubjects;
  final int refresh;
  const HomePage({super.key, required this.onOpenSubjects, required this.refresh});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int points = 0, completed = 0;
  @override
  void initState() { super.initState(); load(); }
  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refresh != widget.refresh) load();
  }
  Future<void> load() async {
    final p = await Store.points();
    final c = await Store.completedCount();
    if (mounted) setState(() { points = p; completed = c; });
  }
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      Row(children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(color: purple.withOpacity(.18), borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.bolt_rounded, color: softPurple, size: 30),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bac Éco Challenge', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
          Text('رحلتك نحو التفوق تبدأ هنا', style: TextStyle(color: Colors.white60)),
        ])),
      ]),
      const SizedBox(height: 24),
      panelCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('مرحبًا بك في تحدّي البكالوريا! 👋', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('تعلّم، اختبر معلوماتك، واجمع النقاط خطوة بخطوة.', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 18),
        Row(children: [
          Expanded(child: _stat('⭐ النقاط', '$points', gold)),
          const SizedBox(width: 10),
          Expanded(child: _stat('📚 دروس مكتملة', '$completed', green)),
        ]),
      ])),
      const SizedBox(height: 26),
      heading('ابدأ التعلّم', subtitle: 'اختر مادة وواصل التقدم'),
      ...subjects.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _subjectTile(context, s, () => widget.onOpenSubjects()),
      )),
      const SizedBox(height: 8),
      panelCard(child: const Row(children: [
        Icon(Icons.tips_and_updates_outlined, color: gold, size: 30),
        SizedBox(width: 12),
        Expanded(child: Text('نصيحة اليوم\nخصص وقتًا قصيرًا كل يوم للمراجعة وحل الأسئلة.', style: TextStyle(height: 1.5))),
      ])),
      const SizedBox(height: 12),
      const Text('ملاحظة: الأسئلة الحالية تجريبية وتحتاج إلى مراجعة وفق المنهاج الرسمي.', style: TextStyle(color: Colors.white38, fontSize: 12)),
    ],
  );
}

Widget _stat(String label, String value, Color color) => Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(color: color.withOpacity(.10), borderRadius: BorderRadius.circular(15)),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
    const SizedBox(height: 5),
    Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
  ]),
);

Widget _subjectTile(BuildContext context, Subject s, VoidCallback onTap) => InkWell(
  onTap: onTap,
  borderRadius: BorderRadius.circular(20),
  child: panelCard(borderColor: s.color, child: Row(children: [
    Container(
      width: 52, height: 52,
      decoration: BoxDecoration(color: s.color.withOpacity(.13), borderRadius: BorderRadius.circular(16)),
      child: Icon(s.icon, color: s.color, size: 29),
    ),
    const SizedBox(width: 14),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(s.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(s.subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
    ])),
    const Icon(Icons.arrow_forward_ios_rounded, size: 17, color: Colors.white54),
  ])),
);

class SubjectsPage extends StatelessWidget {
  final VoidCallback onProgressChanged;
  const SubjectsPage({super.key, required this.onProgressChanged});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: [
      heading('المواد الدراسية', subtitle: 'اختر المادة ثم الوحدة فالدرس'),
      ...subjects.map((s) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _subjectTile(context, s, () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => UnitsPage(subject: s, onProgressChanged: onProgressChanged),
        ))),
      )),
    ],
  );
}

class UnitsPage extends StatelessWidget {
  final Subject subject;
  final VoidCallback onProgressChanged;
  const UnitsPage({super.key, required this.subject, required this.onProgressChanged});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(subject.title)),
    body: ListView(padding: const EdgeInsets.all(20), children: [
      heading('الوحدات والدروس', subtitle: subject.subtitle),
      ...subject.units.map((unit) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: panelCard(borderColor: subject.color, child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(unit.title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...unit.lessons.map((lesson) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.play_circle_fill_rounded, color: subject.color, size: 32),
              title: Text(lesson.title),
              subtitle: Text('${lesson.questions.length} أسئلة تجريبية'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => QuizPage(
                  subject: subject, unit: unit, lesson: lesson,
                  onProgressChanged: onProgressChanged,
                ),
              )),
            )),
          ],
        )),
      )),
    ]),
  );
}

class QuizPage extends StatefulWidget {
  final Subject subject;
  final Unit unit;
  final Lesson lesson;
  final VoidCallback onProgressChanged;
  const QuizPage({super.key, required this.subject, required this.unit, required this.lesson, required this.onProgressChanged});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0, earned = 0;
  int? selected;
  bool answered = false;
  bool finished = false;

  Future<void> choose(int i) async {
    if (answered) return;
    final q = widget.lesson.questions[index];
    setState(() { selected = i; answered = true; });
    if (i == q.answer) {
      await Store.addPoints(5);
      earned += 5;
    }
    if (mounted) setState(() {});
  }

  Future<void> next() async {
    if (index + 1 < widget.lesson.questions.length) {
      setState(() { index++; selected = null; answered = false; });
    } else {
      final id = '${widget.subject.title}/${widget.unit.title}/${widget.lesson.title}';
      await Store.complete(id);
      widget.onProgressChanged();
      if (mounted) setState(() => finished = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finished) {
      return Scaffold(
        appBar: AppBar(title: const Text('نتيجة الاختبار')),
        body: Center(child: Padding(
          padding: const EdgeInsets.all(24),
          child: panelCard(child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, color: gold, size: 70),
              const SizedBox(height: 12),
              const Text('أحسنت! أكملت الدرس', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text('حصلت على $earned نقطة من الإجابات الصحيحة.', textAlign: TextAlign.center),
              const SizedBox(height: 8),
              const Text('مكافأة إكمال الدرس: 25 نقطة لأول إكمال.', style: TextStyle(color: Colors.white60)),
              const SizedBox(height: 22),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: purple),
                onPressed: () => Navigator.pop(context),
                child: const Text('العودة إلى الدروس'),
              ),
            ],
          )),
        )),
      );
    }

    final q = widget.lesson.questions[index];
    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        LinearProgressIndicator(
          value: (index + 1) / widget.lesson.questions.length,
          minHeight: 7,
          borderRadius: BorderRadius.circular(10),
          backgroundColor: Colors.white12,
          color: purple,
        ),
        const SizedBox(height: 16),
        Text('السؤال ${index + 1} من ${widget.lesson.questions.length}', style: const TextStyle(color: softPurple)),
        const SizedBox(height: 12),
        panelCard(child: Text(q.text, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold, height: 1.5))),
        const SizedBox(height: 18),
        ...List.generate(q.options.length, (i) {
          Color border = Colors.white12;
          Color fill = panel;
          if (answered && i == q.answer) { border = green; fill = green.withOpacity(.12); }
          else if (answered && i == selected) { border = Colors.redAccent; fill = Colors.redAccent.withOpacity(.10); }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: InkWell(
              onTap: () => choose(i),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
                child: Row(children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: purple.withOpacity(.2),
                    child: Text(String.fromCharCode(65 + i), style: const TextStyle(color: softPurple)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(q.options[i], style: const TextStyle(fontSize: 15))),
                ]),
              ),
            ),
          );
        }),
        if (answered) ...[
          panelCard(borderColor: selected == q.answer ? green : gold, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selected == q.answer ? 'إجابة صحيحة! +5 نقاط 🎉' : 'ليست الإجابة الصحيحة', style: TextStyle(fontWeight: FontWeight.bold, color: selected == q.answer ? green : gold)),
              const SizedBox(height: 8),
              Text(q.explanation, style: const TextStyle(height: 1.5)),
            ],
          )),
          const SizedBox(height: 16),
          SizedBox(height: 50, child: FilledButton(
            style: FilledButton.styleFrom(backgroundColor: purple),
            onPressed: next,
            child: Text(index + 1 == widget.lesson.questions.length ? 'إنهاء الاختبار' : 'السؤال التالي'),
          )),
        ],
      ]),
    );
  }
}

class RewardsPage extends StatefulWidget {
  final int refresh;
  const RewardsPage({super.key, required this.refresh});
  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int points = 0, completed = 0;
  @override
  void initState() { super.initState(); load(); }
  @override
  void didUpdateWidget(covariant RewardsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refresh != widget.refresh) load();
  }
  Future<void> load() async {
    final p = await Store.points();
    final c = await Store.completedCount();
    if (mounted) setState(() { points = p; completed = c; });
  }
  @override
  Widget build(BuildContext context) {
    final level = points >= 500 ? 'أسطورة الاقتصاد' : points >= 250 ? 'خبير البكالوريا' : points >= 100 ? 'متفوّق' : points >= 25 ? 'مجتهد' : 'مبتدئ';
    return ListView(padding: const EdgeInsets.all(20), children: [
      heading('المكافآت والإنجازات', subtitle: 'كل إجابة صحيحة تقرّبك من هدفك'),
      panelCard(child: Column(children: [
        const Icon(Icons.workspace_premium_rounded, color: gold, size: 68),
        const SizedBox(height: 10),
        Text(level, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: gold)),
        const SizedBox(height: 8),
        Text('$points نقطة', style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 14),
        LinearProgressIndicator(value: (points % 100) / 100, color: purple, backgroundColor: Colors.white12, minHeight: 8),
        const SizedBox(height: 8),
        Text('الدروس المكتملة: $completed', style: const TextStyle(color: Colors.white60)),
      ])),
      const SizedBox(height: 22),
      heading('كيف تجمع النقاط؟'),
      _rewardRow(Icons.check_circle_outline, 'إجابة صحيحة', '+5 نقاط', green),
      _rewardRow(Icons.menu_book_rounded, 'إكمال درس لأول مرة', '+25 نقطة', purple),
      _rewardRow(Icons.flag_rounded, 'تحديات إضافية', 'تُضاف لاحقًا', gold),
      const SizedBox(height: 12),
      const Text('المكافآت محلية على هذا الجهاز في هذه النسخة.', style: TextStyle(color: Colors.white38, fontSize: 12)),
    ]);
  }
}

Widget _rewardRow(IconData icon, String title, String reward, Color color) => Padding(
  padding: const EdgeInsets.only(bottom: 10),
  child: panelCard(child: Row(children: [
    Icon(icon, color: color, size: 28),
    const SizedBox(width: 12),
    Expanded(child: Text(title)),
    Text(reward, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
  ])),
);

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});
  static final Uri instagramUri = Uri.parse('https://www.instagram.com/RN6._.hh/');
  Future<void> openInstagram(BuildContext context) async {
    if (!await launchUrl(instagramUri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تعذر فتح Instagram. تحقق من اتصال الإنترنت.')));
      }
    }
  }
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: [
    heading('عن المطوّر', subtitle: 'صاحب فكرة Bac Éco Challenge'),
    panelCard(child: Column(children: [
      Container(
        width: 100, height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(colors: [purple, purple.withOpacity(.35)]),
        ),
        child: const Icon(Icons.code_rounded, size: 48, color: Colors.white),
      ),
      const SizedBox(height: 16),
      const Text('RAYAN METALESS', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      const Text('مطور Bac Éco Challenge', style: TextStyle(color: softPurple)),
      const SizedBox(height: 18),
      const Text(
        'تطبيق تعليمي لمساعدة تلاميذ السنة الثالثة ثانوي، شعبة تسيير واقتصاد، على المراجعة بطريقة تفاعلية.',
        textAlign: TextAlign.center,
        style: TextStyle(height: 1.7, color: Colors.white70),
      ),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: FilledButton.icon(
        style: FilledButton.styleFrom(backgroundColor: purple, padding: const EdgeInsets.all(14)),
        onPressed: () => openInstagram(context),
        icon: const Icon(Icons.camera_alt_outlined),
        label: const Text('تابعني على Instagram: RN6._.hh'),
      )),
    ])),
    const SizedBox(height: 18),
    panelCard(child: const Row(children: [
      Icon(Icons.info_outline_rounded, color: softPurple),
      SizedBox(width: 12),
      Expanded(child: Text('الإصدار 1.0.0 • نسخة تجريبية قابلة للتطوير', style: TextStyle(color: Colors.white70))),
    ])),
  ]);
}
