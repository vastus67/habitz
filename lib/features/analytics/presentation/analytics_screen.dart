import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitz/features/dashboard/providers/dashboard_provider.dart';
import 'package:habitz/features/workouts/providers/workout_session_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class AnalyticsOverviewScreen extends ConsumerWidget {
  const AnalyticsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    final history = ref.watch(workoutHistoryProvider).valueOrNull ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: dashboard.when(
        data: (data) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            NeoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance intelligence',
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text('See how consistency is moving.', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 220,
                    child: LineChart(
                      LineChartData(
                        minY: 0,
                        maxY: 1,
                        gridData: const FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: const FlTitlesData(show: false),
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
                            belowBarData: BarAreaData(
                              show: true,
                              color: AppTheme.accent.withValues(alpha: 0.15),
                            ),
                            dotData: const FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
            NeoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent workouts', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  if (history.isEmpty)
                    const Text(
                      'Complete your first workout to unlock recent-session analytics.',
                      style: TextStyle(color: AppTheme.textSecondary),
                    )
                  else
                    for (final item in history.take(4)) ...[
                      Container(
                        padding: const EdgeInsets.all(14),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSoft,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.workoutDayId, style: const TextStyle(fontWeight: FontWeight.w700)),
                                const SizedBox(height: 4),
                                Text(
                                  '${item.duration} min • ${item.completedExercises} exercises',
                                  style: const TextStyle(color: AppTheme.textSecondary),
                                ),
                              ],
                            ),
                            Text(
                              '${item.date.month}/${item.date.day}',
                              style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                ],
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
