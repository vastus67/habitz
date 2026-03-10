import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/features/dashboard/providers/dashboard_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class AnalyticsOverviewScreen extends ConsumerWidget {
  const AnalyticsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: dashboard.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            NeoCard(
              child: SizedBox(
                height: 220,
                child: LineChart(
                  LineChartData(
                    minY: 0,
                    maxY: 1,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 0.45),
                          const FlSpot(1, 0.50),
                          const FlSpot(2, 0.6),
                          const FlSpot(3, 0.55),
                          const FlSpot(4, 0.7),
                          const FlSpot(5, 0.8),
                          FlSpot(6, data.completion),
                        ],
                        isCurved: true,
                        color: AppTheme.accent,
                        barWidth: 4,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: NeoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Weekly Consistency'),
                        const SizedBox(height: 8),
                        Text('${(data.score.weeklyConsistency * 100).round()}%'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: NeoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Daily Score'),
                        const SizedBox(height: 8),
                        Text('${data.score.dailyScore}/100'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const NeoCard(
              child: Text(
                'Correlation signal: Sleep consistency and workout completion trend upward together. '
                'Hydration also aligns with higher energy logs.',
              ),
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }
}
