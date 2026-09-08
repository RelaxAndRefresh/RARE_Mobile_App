import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/support_provider.dart';
import '../../widgets/tiles/list_tile.dart';

class HelpSupportScreen extends ConsumerStatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  ConsumerState<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends ConsumerState<HelpSupportScreen> {
  final _issueController = TextEditingController();
  String _selectedCategory = 'Data Accuracy';

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supportState = ref.watch(supportProvider);

    ref.listen<SupportState>(supportProvider, (prev, next) {
      if (next.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(supportProvider.notifier).clearMessages();
        Navigator.pop(context);
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(supportProvider.notifier).clearMessages();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            ListTileWidget(
              title: 'Manage Bookings',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.rose,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening booking management...'),
                    backgroundColor: AppColors.mocha,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTileWidget(
              title: 'Report a Data Issue',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.rose,
              ),
              onTap: () {
                _showReportIssueDialog(context, supportState);
              },
            ),
            ListTileWidget(
              title: 'Contact Concierge',
              trailing: const Icon(
                Icons.chevron_right,
                color: AppColors.rose,
              ),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opening concierge contact...'),
                    backgroundColor: AppColors.mocha,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
              child: Text(
                'Report a Data Issue is firewalled: staff see only '
                'the flagged insight and her note, never raw biometric logs.',
                style: TextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportIssueDialog(BuildContext context, SupportState supportState) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
          ),
          title: const Text(
            'Report a Data Issue',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 18,
              color: AppColors.mocha,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please describe the issue you\'re experiencing with your data.',
                style: TextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: AppColors.cream,
                    style: TextStyles.bodyMedium,
                    items: const [
                      DropdownMenuItem(
                        value: 'Data Accuracy',
                        child: Text('Data Accuracy'),
                      ),
                      DropdownMenuItem(
                        value: 'Missing Data',
                        child: Text('Missing Data'),
                      ),
                      DropdownMenuItem(
                        value: 'Incorrect Insight',
                        child: Text('Incorrect Insight'),
                      ),
                      DropdownMenuItem(
                        value: 'Other',
                        child: Text('Other'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => _selectedCategory = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _issueController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe the issue...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.rose),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Staff will see only your flagged insight and this note. '
                'Your raw biometric data is never shared.',
                style: TextStyles.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.grey),
              ),
            ),
            TextButton(
              onPressed: supportState.isLoading
                  ? null
                  : () {
                      final description = _issueController.text.trim();
                      if (description.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please describe the issue.'),
                            backgroundColor: AppColors.error,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return;
                      }
                      ref.read(supportProvider.notifier).createTicket(
                            category: _selectedCategory,
                            description: description,
                          );
                      _issueController.clear();
                    },
              child: supportState.isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.rose,
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(color: AppColors.rose),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
