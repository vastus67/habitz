import 'package:flutter/material.dart';
import 'package:habitz/theme/app_theme.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.label,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 180,
            width: 180,
            child: CircularProgressIndicator(
              value: progress.clamp(0, 1),
              strokeWidth: 14,
              backgroundColor: AppTheme.cardSoft,
              valueColor: const AlwaysStoppedAnimation(AppTheme.accent),
            ),
          ),
          Container(
            height: 136,
            width: 136,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.card,
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(progress * 100).round()}%',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          )
        ],
      ),
    );
  }
}
