import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

class AccountDetailsScreen extends ConsumerStatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  ConsumerState<AccountDetailsScreen> createState() =>
      _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends ConsumerState<AccountDetailsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _nameEdited = false;
  bool _emailEdited = false;
  bool _phoneEdited = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileProvider.notifier).loadAll();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initControllersIfNeeded(dynamic user) {
    if (!_initialized && user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phone ?? '';
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final user = profileState.user;
    final isLoading = profileState.isLoading;
    final error = profileState.error;

    _initControllersIfNeeded(user);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Account Details'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: isLoading && user == null
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.rose),
            )
          : error != null && user == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Failed to load account details.',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.terracotta,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Retry',
                        onPressed: () =>
                            ref.read(profileProvider.notifier).loadAll(),
                        width: null,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Edit your personal information',
                        style: TextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      _buildDetailField(
                        label: 'NAME',
                        controller: _nameController,
                        hint: 'Enter your full name',
                        onChanged: (_) => setState(() => _nameEdited = true),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailField(
                        label: 'EMAIL',
                        controller: _emailController,
                        hint: 'Enter your email address',
                        onChanged: (_) => setState(() => _emailEdited = true),
                        subtitle: 'Email changes require OAuth re-authorization',
                        isEmail: true,
                      ),
                      const SizedBox(height: 16),
                      _buildDetailField(
                        label: 'PHONE NUMBER',
                        controller: _phoneController,
                        hint: 'Enter your phone number',
                        onChanged: (_) => setState(() => _phoneEdited = true),
                        subtitle: 'Phone changes trigger an OTP verification',
                        isPhone: true,
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: isLoading ? 'Saving...' : 'Save Changes',
                        onPressed: (_nameEdited || _emailEdited || _phoneEdited) &&
                                !isLoading
                            ? () => _handleSave(context)
                            : null,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
    );
  }

  Widget _buildDetailField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    String? subtitle,
    bool isEmail = false,
    bool isPhone = false,
  }) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: isEmail
                ? TextInputType.emailAddress
                : isPhone
                    ? TextInputType.phone
                    : TextInputType.text,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.grey),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.mocha,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  isEmail ? Icons.link : Icons.verified,
                  size: 12,
                  color: AppColors.gold,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _handleSave(BuildContext context) {
    if (_emailEdited) {
      _showEmailReauthDialog(context);
      return;
    }
    if (_phoneEdited) {
      _showOTPDialog(context);
      return;
    }
    _saveChanges(context);
  }

  void _showEmailReauthDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Re-authorize Email Change',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            color: AppColors.mocha,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.security_outlined,
              size: 48,
              color: AppColors.gold,
            ),
            const SizedBox(height: 12),
            Text(
              'To change your email, you\'ll need to re-authorize via OAuth.',
              style: TextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll be redirected to relaxedandrefresh.com to confirm.',
              style: TextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          GhostButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
            width: null,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            label: 'Continue with OAuth',
            onPressed: () {
              Navigator.pop(context);
              _showOAuthInProgress(context);
            },
            width: null,
          ),
        ],
      ),
    );
  }

  void _showOTPDialog(BuildContext context) {
    final TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        title: const Text(
          'Verify Your Phone Number',
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
              'We\'ve sent a 6-digit OTP to ${_phoneController.text}.',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                  borderSide: const BorderSide(color: AppColors.rose),
                ),
                counterText: '',
              ),
            ),
          ],
        ),
        actions: [
          GhostButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
            width: null,
          ),
          const SizedBox(width: 8),
          PrimaryButton(
            label: 'Verify & Save',
            onPressed: () {
              Navigator.pop(context);
              _saveChanges(context);
            },
            width: null,
          ),
        ],
      ),
    );
  }

  void _showOAuthInProgress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cream,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.rose,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Opening OAuth flow...',
              style: TextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _saveChanges(context);
    });
  }

  void _saveChanges(BuildContext context) {
    final data = <String, dynamic>{};
    if (_nameEdited) data['name'] = _nameController.text;
    if (_emailEdited) data['email'] = _emailController.text;
    if (_phoneEdited) data['phone'] = _phoneController.text;

    ref.read(profileProvider.notifier).updateAccountDetails(data);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details updated successfully.'),
        backgroundColor: AppColors.mocha,
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      _nameEdited = false;
      _emailEdited = false;
      _phoneEdited = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      context.go(RouteNames.profileHub);
    });
  }
}
