import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import 'package:go_router/go_router.dart';

/// Screen 45 – Account Details
/// Editable fields for name, email, and phone number.
/// Reached from Profile Hub (Screen 33).
/// Email changes require OAuth re-authorization.
/// Phone changes trigger OTP verification.
class AccountDetailsScreen extends StatefulWidget {
  const AccountDetailsScreen({super.key});

  @override
  State<AccountDetailsScreen> createState() => _AccountDetailsScreenState();
}

class _AccountDetailsScreenState extends State<AccountDetailsScreen> {
  // Controllers for form fields
  final TextEditingController _nameController =
      TextEditingController(text: 'Priya Sharma');
  final TextEditingController _emailController =
      TextEditingController(text: 'priya@example.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+91 98765 43210');

  // Track which fields have been edited
  bool _nameEdited = false;
  bool _emailEdited = false;
  bool _phoneEdited = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Account Details'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit your personal information',
              style: TextStyles.bodyMedium,
            ),
            const SizedBox(height: 20),

            // Name field
            _buildDetailField(
              label: 'NAME',
              controller: _nameController,
              hint: 'Enter your full name',
              onChanged: (_) => setState(() => _nameEdited = true),
            ),
            const SizedBox(height: 16),

            // Email field (with OAuth note)
            _buildDetailField(
              label: 'EMAIL',
              controller: _emailController,
              hint: 'Enter your email address',
              onChanged: (_) => setState(() => _emailEdited = true),
              subtitle: 'Email changes require OAuth re-authorization',
              isEmail: true,
            ),
            const SizedBox(height: 16),

            // Phone field (with OTP note)
            _buildDetailField(
              label: 'PHONE NUMBER',
              controller: _phoneController,
              hint: 'Enter your phone number',
              onChanged: (_) => setState(() => _phoneEdited = true),
              subtitle: 'Phone changes trigger an OTP verification',
              isPhone: true,
            ),

            const Spacer(),

            // Save button
            PrimaryButton(
              label: 'Save Changes',
              onPressed: _nameEdited || _emailEdited || _phoneEdited
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
    // In a real app, this would:
    // 1. Validate inputs
    // 2. If email changed: show OAuth re-authorization dialog
    // 3. If phone changed: show OTP verification dialog
    // 4. Save to backend

    if (_emailEdited) {
      _showEmailReauthDialog(context);
      return;
    }

    if (_phoneEdited) {
      _showOTPDialog(context);
      return;
    }

    // If only name changed, save directly
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
              // Simulate OAuth flow
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
              // In a real app, verify OTP
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

    // Simulate OAuth completion after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      _saveChanges(context);
    });
  }

  void _saveChanges(BuildContext context) {
    // In a real app: save to backend, update user profile state
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account details updated successfully.'),
        backgroundColor: AppColors.mocha,
        duration: Duration(seconds: 2),
      ),
    );

    // Reset edit flags
    setState(() {
      _nameEdited = false;
      _emailEdited = false;
      _phoneEdited = false;
    });

    // Navigate back to Profile Hub
    Future.delayed(const Duration(milliseconds: 500), () {
      context.go(RouteNames.profileHub);
    });
  }
}
