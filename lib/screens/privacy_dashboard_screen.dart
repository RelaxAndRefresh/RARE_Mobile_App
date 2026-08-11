// 26

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';



class PrivacyDashboardScreen extends StatefulWidget {
  const PrivacyDashboardScreen({super.key});

  @override
  State<PrivacyDashboardScreen> createState() =>
      _PrivacyDashboardScreenState();
}

class _PrivacyDashboardScreenState extends State<PrivacyDashboardScreen> {
  bool _phoneActivity = true;
  bool _pinCode = true;
  bool _cycleTracking = false;
  bool _skinPhotos = true;
  bool _purchaseHistory = true;
  bool _wearableData = false;

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
                'Privacy Dashboard',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(height: 16),

              // Body copy — never Dark Mocha
              Text(
                'Independently revocable consent — plain language always.',
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
                label: 'Phone activity',
                value: _phoneActivity,
                onChanged: (v) => setState(() => _phoneActivity = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'Pin code',
                value: _pinCode,
                onChanged: (v) => setState(() => _pinCode = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'Cycle tracking',
                value: _cycleTracking,
                onChanged: (v) => setState(() => _cycleTracking = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'Skin photos',
                value: _skinPhotos,
                onChanged: (v) => setState(() => _skinPhotos = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'Purchase history',
                value: _purchaseHistory,
                onChanged: (v) => setState(() => _purchaseHistory = v),
              ),
              _Divider(),
              _ToggleRow(
                label: 'Wearable data',
                value: _wearableData,
                onChanged: (v) => setState(() => _wearableData = v),
              ),
              const SizedBox(height: 24),

              // Pin code card
              const _PinCodeCard(),
              const SizedBox(height: 16),

              // Download my data row
              const _DownloadDataRow(),
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
          _BrandSwitch(value: value, onChanged: onChanged),
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

class _PinCodeCard extends StatefulWidget {
  const _PinCodeCard();

  @override
  State<_PinCodeCard> createState() => _PinCodeCardState();
}

class _PinCodeCardState extends State<_PinCodeCard> {
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
            'PIN CODE',
            style: GoogleFonts.jost(
              fontSize: 9,
              fontWeight: FontWeight.w400,
              letterSpacing: 3,
              color: AppColors.warmGrey,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '411001 — Pune',
                style: GoogleFonts.jost(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: AppColors.darkMocha,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      // TODO: wire up pin code update flow
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      constraints: const BoxConstraints(minHeight: 44),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: lineColor, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'UPDATE',
                        style: GoogleFonts.jost(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 3,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DownloadDataRow extends StatefulWidget {
  const _DownloadDataRow();

  @override
  State<_DownloadDataRow> createState() => _DownloadDataRowState();
}

class _DownloadDataRowState extends State<_DownloadDataRow> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          // TODO: wire up data export/download flow
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: _isHovering
                ? [
              BoxShadow(
                color: AppColors.darkMocha.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                Icons.file_download_outlined,
                size: 20,
                color: AppColors.primaryAccent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Download My Data',
                  style: GoogleFonts.jost(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkMocha,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.warmGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}