// 25

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class NotificationCadenceScreen extends StatefulWidget {
  const NotificationCadenceScreen({super.key});

  @override
  State<NotificationCadenceScreen> createState() =>
      _NotificationCadenceScreenState();
}

class _NotificationCadenceScreenState
    extends State<NotificationCadenceScreen> {
  bool _amReminder = true;
  bool _pmReminder = true;
  bool _insightNudges = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading
              Text(
                'Settings & Notification Cadence',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'Non-punitive mute / snooze — check-in timing entirely user-set.',
                style: GoogleFonts.jost(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.5,
                  color: AppColors.bodyMauve,
                ),
              ),
              const SizedBox(height: 32),

              // Toggle rows
              _ToggleRow(
                label: 'AM Check-in reminder',
                value: _amReminder,
                onChanged: (v) => setState(() => _amReminder = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'PM Check-in reminder',
                value: _pmReminder,
                onChanged: (v) => setState(() => _pmReminder = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'Insight-ready nudges',
                value: _insightNudges,
                onChanged: (v) => setState(() => _insightNudges = v),
              ),
              const SizedBox(height: 24),

              // Push permission card
              const _PushPermissionCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: AppColors.warmGrey.withOpacity(0.3),
        height: 1,
        thickness: 0.5,
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.jost(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColors.bodyMauve,
              ),
            ),
          ),
          const SizedBox(width: 16),
          _BrandSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Custom switch matching the brand palette: ON = Dusty Rose track,
/// OFF = Warm Grey track, white thumb, smooth 0.3s ease slide.
class _BrandSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BrandSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 48,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? AppColors.primaryAccent : AppColors.warmGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _PushPermissionCard extends StatefulWidget {
  const _PushPermissionCard();

  @override
  State<_PushPermissionCard> createState() => _PushPermissionCardState();
}

class _PushPermissionCardState extends State<_PushPermissionCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color lineColor =
    _isHovering ? AppColors.primaryAccent : AppColors.luxuryDetail;
    final Color textColor =
    _isHovering ? AppColors.primaryAccent : AppColors.darkMocha;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Push permission was denied at the OS level.',
            style: GoogleFonts.jost(
              fontSize: 13,
              fontWeight: FontWeight.w300,
              color: AppColors.warmGrey,
            ),
          ),
          const SizedBox(height: 20),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                // TODO: deep-link to OS notification settings
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 44),
                alignment: Alignment.center,
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: lineColor, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ENABLE PUSH NOTIFICATIONS',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.jost(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 3,
                    height: 1.6,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}