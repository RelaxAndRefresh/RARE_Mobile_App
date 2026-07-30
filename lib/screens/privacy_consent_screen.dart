import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/primary_button.dart';
import 'cycle_baseline_screen.dart';

class PrivacyConsentScreen extends StatefulWidget {
  const PrivacyConsentScreen({super.key});

  @override
  State<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  final List<_ConsentItem> permissions = [
    _ConsentItem(
      title: "Phone activity (sleep inference)",
      subtitle: "Used only for the feature it names.",
      enabled: true,
    ),
    _ConsentItem(
      title: "Pin code (environmental data)",
      subtitle: "Used only for the feature it names.",
      enabled: true,
    ),
    _ConsentItem(
      title: "Cycle tracking",
      subtitle: "Used only for the feature it names.",
      enabled: true,
    ),
    _ConsentItem(
      title: "Skin photo storage",
      subtitle: "Used only for the feature it names.",
      enabled: true,
    ),
    _ConsentItem(
      title: "Purchase history (Shelf / Auto-Swap)",
      subtitle: "Used only for the feature it names.",
      enabled: false,
    ),
    _ConsentItem(
      title: "Wearable & health data (Apple Health / Google Fit)",
      subtitle: "Used only for the feature it names.",
      enabled: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              const SizedBox(height: 16),

              Text(
                "Privacy / DPDP Consent\nGate",
                style: AppTypography.h1,
              ),

              const SizedBox(height: 18),

              Text(
                "Granular, independently toggleable — plain language,\nno legal boilerplate.",
                style: AppTypography.body,
              ),

              const SizedBox(height: 32),

              Expanded(
                child: ListView.separated(
                  itemCount: permissions.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColors.bodyMauve.withOpacity(.18),
                    height: 26,
                  ),
                  itemBuilder: (context, index) {
                    final item = permissions[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: AppTypography.body.copyWith(
                                    fontSize: 15,
                                    color: AppColors.darkMocha,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.bodyMauve,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Switch(
                          value: item.enabled,
                          activeColor: Colors.white,
                          activeTrackColor: AppColors.primaryAccent,
                          inactiveThumbColor: Colors.white,
                          inactiveTrackColor:
                          AppColors.primaryAccent.withOpacity(.55),
                          onChanged: (value) {
                            setState(() {
                              item.enabled = value;
                            });
                          },
                        )
                      ],
                    );
                  },
                ),
              ),

              PrimaryButton(
                text: "Continue",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CycleBaselineScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsentItem {
  final String title;
  final String subtitle;
  bool enabled;

  _ConsentItem({
    required this.title,
    required this.subtitle,
    required this.enabled,
  });
}