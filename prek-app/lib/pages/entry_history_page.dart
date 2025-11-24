import 'package:flutter/material.dart';
import '../data/mock_entries.dart';
import '../utils/time_utils.dart';
import '../widgets/gratitude_tile.dart';

class EntryHistoryPage extends StatelessWidget {
  const EntryHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [...mockEntries]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    const textColor = Color(0xFF94697E);
    const topBarColor = Color(0xFFFFF1F5);

    Widget buildBackground(Widget child) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF1F5), Color(0xFFFFF8EE)],
          ),
        ),
        child: child,
      );
    }

    if (items.isEmpty) {
      return Scaffold(
        backgroundColor: topBarColor,
        appBar: AppBar(
          title: const Text('Gratitude History'),
          backgroundColor: topBarColor,
          elevation: 0,
          foregroundColor: textColor,
        ),
        body: buildBackground(
          Center(
            child: Text(
              "No entries yet.\nAdd your first gratitude today!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                  ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: topBarColor,
      appBar: AppBar(
        title: const Text('Gratitude History'),
        backgroundColor: topBarColor,
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
                GratitudeTile(entry: e),
              ],
            );
          },
        ),
      ),
    );
  }
}
