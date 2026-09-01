import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/legal_provider.dart';

class LegalDocumentsScreen extends ConsumerStatefulWidget {
  final String documentType;

  const LegalDocumentsScreen({
    super.key,
    this.documentType = 'privacy-policy',
  });

  @override
  ConsumerState<LegalDocumentsScreen> createState() =>
      _LegalDocumentsScreenState();
}

class _LegalDocumentsScreenState extends ConsumerState<LegalDocumentsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(legalProvider.notifier).loadDocument(widget.documentType);
  }

  @override
  Widget build(BuildContext context) {
    final legalState = ref.watch(legalProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text(legalState.document?.title ?? 'Privacy Policy'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (legalState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: AppColors.rose),
                  ),
                )
              else if (legalState.error != null)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Unable to load document',
                        style: TextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => ref
                            .read(legalProvider.notifier)
                            .loadDocument(widget.documentType),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              else if (legalState.document != null) ...[
                Text(
                  legalState.document!.title,
                  style: TextStyles.headlineMedium,
                ),
                const SizedBox(height: 16),
                if (legalState.document!.lastUpdated != null) ...[
                  Text(
                    'Last updated: ${legalState.document!.lastUpdated}',
                    style: TextStyles.bodySmall,
                  ),
                  const SizedBox(height: 24),
                ],
                ..._parseDocumentContent(legalState.document!.content),
              ] else ...[
                Text(
                  'Privacy Policy',
                  style: TextStyles.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Last updated: July 2026',
                  style: TextStyles.bodySmall,
                ),
                const SizedBox(height: 24),
                _buildSection(
                  'Introduction',
                  'RARE collects only what\'s needed to personalize your wellness experience, governed under India\'s DPDP framework. This policy explains how we collect, use, and protect your data.',
                ),
                _buildSection(
                  'What We Collect',
                  '• Phone activity (sleep inference)\n'
                      '• Pin code (environmental data)\n'
                      '• Cycle tracking (if you choose to share)\n'
                      '• Skin photo storage (with your consent)\n'
                      '• Purchase history (Shelf / Auto-Swap)\n'
                      '• Wearable & health data (Apple Health / Google Fit)',
                ),
                _buildSection(
                  'How We Use It',
                  'All data is used solely for personalizing your RARE experience. We do not sell or share your data with third parties for advertising. Aggregated, anonymized data may be used for research to improve our Precision Engine.',
                ),
                _buildSection(
                  'Your Rights (DPDP)',
                  '• Right to Access: Download your data at any time.\n'
                      '• Right to Correction: Edit your logs and profile.\n'
                      '• Right to Erasure: Use the Kill Switch to delete all app data.\n'
                      '• Right to Withdraw Consent: Toggle permissions off anytime in Privacy Dashboard.',
                ),
                _buildSection(
                  'Data Security',
                  'We use industry-standard encryption for data at rest and in transit. Access to personal data is strictly limited to essential service provision.',
                ),
                _buildSection(
                  'Contact',
                  'For any privacy-related questions, please contact us through the Help & Support section.',
                ),
              ],
              const SizedBox(height: 32),
              Text(
                'RARE — Unified Wellness Atmosphere',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.grey,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _parseDocumentContent(String content) {
    final sections = <Widget>[];
    final lines = content.split('\n');

    String? currentHeading;
    final currentBody = StringBuffer();

    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;

      if (_isHeading(trimmed)) {
        if (currentHeading != null && currentBody.isNotEmpty) {
          sections.add(_buildSection(currentHeading, currentBody.toString()));
          currentBody.clear();
        }
        currentHeading = trimmed;
      } else {
        if (currentBody.isNotEmpty) currentBody.write('\n');
        currentBody.write(trimmed);
      }
    }

    if (currentHeading != null && currentBody.isNotEmpty) {
      sections.add(_buildSection(currentHeading, currentBody.toString()));
    }

    if (sections.isEmpty) {
      sections.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            content,
            style: TextStyles.bodyMedium.copyWith(height: 1.6),
          ),
        ),
      );
    }

    return sections;
  }

  bool _isHeading(String line) {
    return line == line.toUpperCase() && line.length < 60 && !line.startsWith('•');
  }

  Widget _buildSection(String heading, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: TextStyles.titleLarge),
          const SizedBox(height: 6),
          Text(
            body,
            style: TextStyles.bodyMedium.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
