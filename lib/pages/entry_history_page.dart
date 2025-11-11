import 'package:flutter/material.dart';
import '../data/mock_entries.dart';
import '../widgets/gratitude_tile.dart';

class EntryHistoryPage extends StatelessWidget {
  const EntryHistoryPage({super.key});

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // Sort by date in descending order
    final items = [...mockEntries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    const bg = Color(0xFF6F427D);

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          title: const Text('Gratitude History'),
          backgroundColor: bg,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            "No entries yet.\nAdd your first gratitude today!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('Gratitude History'),
        backgroundColor: bg,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) {
          final e = items[i];
          final showHeader = i == 0 || !_sameDay(e.createdAt, items[i - 1].createdAt);

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
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              GratitudeTile(entry: e),
            ],
          );
        },
      ),
    );
  }
}
