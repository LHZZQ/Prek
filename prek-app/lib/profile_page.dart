import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  String profileName = "";
  String profileEmail = "";
  int reflectionsCount = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadReflectionsCount();
    _loadUsername();
    _loadEmail();
  }

  Future<void> _loadReflectionsCount() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('Gratitude Entries')
          .select('id')
          .eq('user_id', user.id);

      setState(() {
        reflectionsCount = response.length;
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading reflections count: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _loadUsername() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final response = await supabase
          .from('Profiles')
          .select('username')
          .eq('id', user.id);

      if (response.isNotEmpty) {
        setState(() {
          profileName = response[0]['username'] as String;
          loading = false;
        });
      }
    } catch (e) {
      profileName = "error";
      debugPrint('Error loading username: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _loadEmail() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    try {
      final response = await supabase
          .from('Profiles')
          .select('email')
          .eq('id', user.id);

      if (response.isNotEmpty) {
        setState(() {
          profileEmail = response[0]['email'] as String;
          loading = false;
        });
      }
    } catch (e) {
      profileEmail = "error";
      debugPrint('Error loading email: $e');
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pink = Color(0xFFFB7DA8);
    const yellow = Color(0xFFFFC567);
    const blue = Color(0xFF058CD7);
    // const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
    const bgTop = Color(0xFFFFF1F5);
    const bgBottom = Color(0xFFFFF8EE);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: bgTop,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textColor),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Profile",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),

        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("not available right now")),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: textColor),
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: kToolbarHeight - 12),

                _ProfileTopCard(
                  displayName: profileName,
                  email: profileEmail,
                  reflections: reflectionsCount.toString(),
                  streak: "06",
                  daysActive: "12",
                ),
                const SizedBox(height: 14),

                const _FunInfoPill(
                  leftText: "PREK",
                  rightText: "Member since 2025",
                ),
                const SizedBox(height: 18),

                const Text(
                  "Your wellness",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 12),

                _SectionCard(
                  children: [
                    _SectionRow(
                      icon: Icons.auto_awesome_rounded,
                      iconBg: pink.withValues(alpha: 0.55),
                      title: "Reflections saved",
                      badgeText: reflectionsCount.toString(),
                      badgeBg: pink.withValues(alpha: 0.18),
                      onTap: () {},
                    ),

                    _SectionRow(
                      icon: Icons.local_fire_department_rounded,
                      iconBg: yellow.withValues(alpha: 0.55),
                      title: "Reflection streak",
                      badgeText: "6",
                      badgeBg: yellow.withValues(alpha: 0.20),
                      onTap: () {},
                    ),

                    _SectionRow(
                      icon: Icons.flag_rounded,
                      iconBg: blue.withValues(alpha: 0.45),
                      title: "Reflection goals",
                      onTap: () {},
                    ),

                    _SectionRow(
                      icon: Icons.emoji_emotions_rounded,
                      iconBg: pink.withValues(alpha: 0.35),
                      title: "Memory Highlights",
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                const Text(
                  "Mood board",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                const _MoodBoardSection(),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileTopCard extends StatelessWidget {
  final String displayName;
  final String email;
  final String reflections;
  final String streak;
  final String daysActive;

  const _ProfileTopCard({
    required this.displayName,
    required this.email,
    required this.reflections,
    required this.streak,
    required this.daysActive,
  });

  @override
  Widget build(BuildContext context) {
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);
    const pink = Color(0xFFFB7DA8);
    //const peach = Color(0xFFFFE4B5);
    const blue = Color(0xFF058CD7);
    const yellow = Color(0xFFFFC567);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: softWhite.withOpacity(0.78),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: softWhite.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [pink, yellow]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 38),
              ),
              Positioned(
                right: -4,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  email,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.75),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _MiniChip(
                      label: "Reflections",
                      value: reflections,
                      accent: pink,
                    ),
                    _MiniChip(label: "Streak", value: streak, accent: yellow),
                    _MiniChip(label: "Days", value: daysActive, accent: blue),
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

class _MiniChip extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _MiniChip({
    required this.label,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    const softWhite = Color(0xFFFFFFFF);
    const textColor = Color(0xFF94697E);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: softWhite.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: textColor.withValues(alpha: 0.75)),
          ),
        ],
      ),
    );
  }
}

class _FunInfoPill extends StatelessWidget {
  final String leftText;
  final String rightText;

  const _FunInfoPill({required this.leftText, required this.rightText});

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFC567);
    const pink = Color(0xFFFB7DA8);
    const blue = Color(0xFF058CD7);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [yellow, pink, blue]),
        borderRadius: BorderRadius.circular(999),
      ),

      child: Row(
        children: [
          Text(
            leftText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          Text(rightText, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    const softWhite = Color(0xFFFFFFFF);
    return Container(
      decoration: BoxDecoration(
        color: softWhite.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(children: children),
    );
  }
}

class _SectionRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final String title;
  final String? badgeText;
  final Color? badgeBg;
  final VoidCallback onTap;

  const _SectionRow({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.onTap,
    this.badgeText,
    this.badgeBg,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      minVerticalPadding: 16,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: textColor),
      ),
      title: Text(
        title,
        style: const TextStyle(color: textColor, fontWeight: FontWeight.w800),
      ),
      trailing: badgeText != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: badgeBg ?? textColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(badgeText!, style: const TextStyle(color: textColor)),
            )
          : const Icon(Icons.chevron_right_rounded, color: textColor),
    );
  }
}

class _MoodBoardSection extends StatefulWidget {
  final String userId;
  const _MoodBoardSection({required this.userId});

  @override
  State<_MoodBoardSection> createState() => _MoodBoardSectionState();
}

class _MoodBoardSectionState extends State<_MoodBoardSection> {
  static const textColor = Color(0xFF94697E);
  static const softWhite = Color(0xFFFFFFFF);
  static const pink = Color(0xFFFB7DA8);
  static const yellow = Color(0xFFFFC567);
  static const blue = Color(0xFF058CD7);

  static const moods = [
    (Icons.sentiment_very_satisfied_rounded, 'Happy'),
    (Icons.sentiment_satisfied_rounded, 'Good'),
    (Icons.sentiment_neutral_rounded, 'Neutral'),
    (Icons.psychology_alt_rounded, 'Confused'),
    (Icons.sentiment_dissatisfied_rounded, 'Sad'),
    (Icons.warning_amber_rounded, 'Overwhelmed'),
    (Icons.whatshot_rounded, 'Frustrated'),
    (Icons.mood_bad_rounded, 'Angry'),
  ];

  static final Map<String, IconData> _iconForLabel = {
    for (final m in moods) m.$2: m.$1,
  };

  DateTime shownMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final Map<String, String> moodByDay = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('Gratitude Entries')
          .select('mood,created_at')
          .eq('user_id', user.id)
          .not('mood', 'is', null)
          .order('created_at', ascending: true);

      final Map<String, String> fetched = {};
      for (final row in response) {
        final date = DateTime.parse(row['created_at']).toLocal();
        final key =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        if (!fetched.containsKey(key)) {
          fetched[key] = row['mood'] as String;
        }
      }

      setState(() {
        moodByDay.clear();
        moodByDay.addAll(fetched);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error loading moods: $e');
      setState(() => _loading = false);
    }
  }

  String _keyFor(DateTime d) {
    return d.toUtc().toIso8601String().split('T').first;
  }

  String _monthName(int month) {
    const names = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];

    return names[month - 1];
  }

  void _prevMonth() {
    setState(() {
      shownMonth = DateTime(shownMonth.year, shownMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      shownMonth = DateTime(shownMonth.year, shownMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    final daysInMonth = DateUtils.getDaysInMonth(
      shownMonth.year,
      shownMonth.month,
    );
    final firstDay = DateTime(shownMonth.year, shownMonth.month, 1);

    final leadingEmpty =
        (firstDay.weekday - DateTime.monday) %
        7; //bcs monday is the start of the week so im going based off it

    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final gridCount = rows * 7;

    return Container(
      decoration: BoxDecoration(
        color: softWhite.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: softWhite.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _MoodBoardHeader(
            title: "${_monthName(shownMonth.month)} ${shownMonth.year}",
            onPrev: _prevMonth,
            onNext: _nextMonth,
          ),
          const SizedBox(height: 10),

          const _WeekdayRow(),

          const SizedBox(height: 10),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gridCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - leadingEmpty + 1;

              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return _MoodCell.empty();
              }

              final date = DateTime(
                shownMonth.year,
                shownMonth.month,
                dayNumber,
              );
              final label = moodByDay[_keyFor(date)];
              final icon = label == null ? null : _iconForLabel[label];

              return _MoodCell(
                day: dayNumber,
                icon: icon,
                accent: _accentForLabel(label),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _accentForLabel(String? label) {
    if (label == null) return textColor.withValues(alpha: 0.10);
    if (label == "Happy" || label == "Good") {
      return yellow.withValues(alpha: 0.18);
    }
    if (label == "Neutral" || label == "Confused") {
      return blue.withValues(alpha: 0.16);
    }

    return pink.withValues(alpha: 0.16);
  }
}

class _MoodBoardHeader extends StatelessWidget {
  final String title;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MoodBoardHeader({
    required this.title,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);

    return Row(
      children: [
        IconButton(
          onPressed: onPrev,
          icon: const Icon(Icons.chevron_left_rounded, color: textColor),
          splashRadius: 22,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded, color: textColor),
          splashRadius: 22,
        ),
      ],
    );
  }
}

class _WeekdayRow extends StatelessWidget {
  const _WeekdayRow();

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    const labels = ["M", "T", "W", "T", "F", "S", "S"];

    return Row(
      children: [
        for (final l in labels)
          Expanded(
            child: Center(
              child: Text(
                l,
                style: TextStyle(
                  color: textColor.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MoodCell extends StatelessWidget {
  final int? day;
  final IconData? icon;
  final Color? accent;

  const _MoodCell({this.day, this.icon, this.accent});

  factory _MoodCell.empty() => const _MoodCell();

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    const softWhite = Color(0xFFFFFFFF);

    final isEmpty = day == null;

    return Container(
      decoration: BoxDecoration(
        color: isEmpty
            ? textColor.withValues(alpha: 0.06)
            : (accent ?? textColor.withValues(alpha: 0.10)),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isEmpty
              ? Colors.transparent
              : softWhite.withValues(alpha: 0.60),
        ),
      ),
      child: isEmpty
          ? const SizedBox.shrink()
          : Stack(
              children: [
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    "$day",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: textColor.withValues(alpha: 0.70),
                    ),
                  ),
                ),
                Center(child: Icon(icon, size: 37, color: textColor)),
              ],
            ),
    );
  }
}
