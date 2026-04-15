import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/gratitude_entry.dart';
import '../utils/time_utils.dart';
import '../widgets/gratitude_tile.dart';

class EntryHistoryPage extends StatefulWidget {
  const EntryHistoryPage({super.key});

  @override
  State<EntryHistoryPage> createState() => _EntryHistoryPageState();
}

class _EntryHistoryPageState extends State<EntryHistoryPage> {
  final supabase = Supabase.instance.client;

  List<GratitudeEntry> items = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final response = await supabase
        .from('Gratitude Entries')
        .select()
        .order('created_at', ascending: false);

    setState(() {
      items = response
          .map<GratitudeEntry>((e) => GratitudeEntry.fromMap(e))
          .toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFF94697E);
    const topBarColor = Color(0xFFFFF1F5);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget buildBackground(Widget child) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? const [Color(0xFF1E1E2C), Color(0xFF2A2A3D)]
                : const [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),

        child: child,
      );
    }

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: isDark ? Color(0xFF2A2A3D) : topBarColor,
        appBar: AppBar(
          title: const Text('Gratitude History'),

          elevation: 0,
          foregroundColor: textColor,
        ),
        body: buildBackground(
          Center(
            child: Text(
              "No entries yet.\nAdd your first gratitude today!",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: textColor),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF2A2A3D) : topBarColor,
      appBar: AppBar(
        title: const Text('Gratitude History'),

        elevation: 0,
        foregroundColor: textColor,
      ),
      body: buildBackground(
        ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) {
            final e = items[i];
            final showHeader =
                i == 0 || !sameDay(e.createdAt, items[i - 1].createdAt);

            String two(int n) => n.toString().padLeft(2, '0');
            final dateStr =
                '${e.createdAt.year}-${two(e.createdAt.month)}-${two(e.createdAt.day)}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      dateStr,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: textColor.withOpacity(0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                GratitudeTile(
                  entry: e,
                  onDeleted: () {
                    setState(() {
                      items.removeWhere((item) => item.id == e.id);
                    });
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
