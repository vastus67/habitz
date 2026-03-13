import 'package:flutter/material.dart';
import 'package:habitz/theme/app_theme.dart';

class OnboardingStepCard extends StatelessWidget {
  const OnboardingStepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.visual,
    required this.child,
    required this.onContinue,
    this.continueLabel = 'Continue',
    this.onBack,
    this.canContinue = true,
    this.isLoading = false,
  });

  final String title;
  final String subtitle;
  final Widget visual;
  final Widget child;
  final VoidCallback? onContinue;
  final String continueLabel;
  final VoidCallback? onBack;
  final bool canContinue;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(34),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF172015), Color(0xFF0C110D)],
          ),
          border: Border.all(color: const Color(0x19FFFFFF)),
          boxShadow: const [
            BoxShadow(color: Color(0x44000000), blurRadius: 22, offset: Offset(0, 12)),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: onBack == null ? Colors.transparent : AppTheme.textPrimary,
                        size: 18,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 33, fontWeight: FontWeight.w800, height: 1.05),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  subtitle,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 15),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: visual,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: child,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: canContinue && !isLoading ? onContinue : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : Text(continueLabel),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingOptionCard extends StatelessWidget {
  const OnboardingOptionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? const Color(0x26C6FF00) : AppTheme.card,
          border: Border.all(
            color: selected ? AppTheme.accent : const Color(0xFF242B24),
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: selected ? AppTheme.accent : AppTheme.cardSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: selected ? Colors.black : AppTheme.textSecondary),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: selected ? AppTheme.accent : AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
