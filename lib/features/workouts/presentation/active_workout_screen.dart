import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitz/core/database/database_provider.dart';
import 'package:habitz/features/plans/providers/plans_provider.dart';
import 'package:habitz/shared/widgets/neo_card.dart';
import 'package:habitz/theme/app_theme.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({
    super.key,
    required this.planId,
    required this.workoutDayId,
  });

  final String planId;
  final String workoutDayId;

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  int _remainingRest = 0;
  Timer? _timer;
  final Set<String> _completedSetIds = {};
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final setsAsync = ref.watch(planSetsProvider(widget.workoutDayId));

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Execution')),
      body: setsAsync.when(
        data: (sets) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            NeoCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rest Timer: ${_remainingRest}s'),
                  OutlinedButton(
                    onPressed: _remainingRest > 0 ? null : () => _startRest(60),
                    child: const Text('Start 60s'),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            for (final item in sets) ...[
              FutureBuilder(
                future: ref.read(plansRepositoryProvider).getExercise(item.exerciseId),
                builder: (context, snapshot) {
                  final exercise = snapshot.data;
                  return NeoCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise?.name ?? 'Exercise',
                            style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text('${item.sets} sets • ${item.reps} reps • Rest ${item.restSeconds}s'),
                        const SizedBox(height: 6),
                        CheckboxListTile(
                          value: _completedSetIds.contains(item.id),
                          onChanged: (checked) {
                            setState(() {
                              if (checked ?? false) {
                                _completedSetIds.add(item.id);
                                _startRest(item.restSeconds);
                              } else {
                                _completedSetIds.remove(item.id);
                              }
                            });
                          },
                          title: const Text('Mark complete'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Workout notes'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
              ),
              onPressed: () async {
                await ref.read(plansControllerProvider).logWorkoutSession(
                      planId: widget.planId,
                      dayId: widget.workoutDayId,
                      totalTime: 45,
                      effort: 7,
                      note: _noteController.text.trim(),
                    );
                final days = await ref.read(planDaysProvider(widget.planId).future);
                final currentIndex = days.indexWhere((d) => d.id == widget.workoutDayId);
                if (!context.mounted) return;
                if (currentIndex >= 0 && currentIndex + 1 < days.length) {
                  Navigator.pop(context);
                  context.push('/workout/${widget.planId}/${days[currentIndex + 1].id}');
                } else {
                  Navigator.pop(context);
                }
              },
              child: const Text('Finish Workout'),
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  void _startRest(int seconds) {
    _timer?.cancel();
    setState(() => _remainingRest = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingRest <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remainingRest--);
    });
  }
}
