import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  ConsumerState<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  // Colors matching the reference screenshot
  static const Color _pageBackground = Color(0xFFEEDDD5);
  static const Color _headerBackground = Color(0xFFFAF5F0);
  static const Color _inputBackground = Color(0xFFFAF5F0);
  static const Color _darkText = Color(0xFF30201E);
  static const Color _roseText = Color(0xFFC28E80);
  static const Color _inputBorder = Color(0xFFE2CCC4);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authProvider.notifier)
        .signup(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          phone: phoneController.text.trim(),
        );
  }

  InputDecoration inputDecoration({
    required IconData icon,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,

      // Left icon
      prefixIcon: Icon(icon, color: _roseText, size: 22),

      // Password eye icon
      suffixIcon: suffixIcon,

      filled: true,
      fillColor: _inputBackground,

      hintStyle: TextStyles.bodyMedium.copyWith(color: const Color(0xFFBFA79E)),

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _inputBorder, width: 1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: _roseText, width: 1),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyles.bodyMedium.copyWith(
          color: _darkText,
          letterSpacing: 1.3,
        ),
      ),
    );
  }

  Widget formField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldLabel(label),

        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,

          // KEEP YOUR EXISTING FONT
          style: TextStyles.bodyMedium.copyWith(color: _darkText),

          decoration: inputDecoration(
            icon: icon,
            hint: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(RouteNames.welcome);
      }
    });

    return Scaffold(
      // Entire page is peach
      backgroundColor: _pageBackground,

      // No AppBar.
      // No rounded corners / mobile arc.
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================================
            // TOP HEADER
            // ==========================================================
            Container(
              width: double.infinity,
              color: _headerBackground,
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // WELCOME TO RARE
                  Text(
                    'WELCOME TO RARE',
                    style: TextStyles.eyebrow.copyWith(
                      color: _roseText,
                      letterSpacing: 5.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // MISSING LINE 1
                  //
                  // Keeping TextStyles.displayMedium means
                  // your existing font-family remains unchanged.
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Elevating your ',
                          style: TextStyles.displayMedium.copyWith(
                            color: _darkText,
                          ),
                        ),
                        TextSpan(
                          text: 'daily ritual',
                          style: TextStyles.displayMedium.copyWith(
                            color: _roseText,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================================
            // MAIN FORM AREA
            // ==========================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(55, 24, 55, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MISSING LINE 2
                      Text(
                        'JOIN OUR COMMUNITY OF MINDFUL\nSELF-CARE',
                        style: TextStyles.eyebrow.copyWith(
                          color: _roseText,
                          letterSpacing: 4.5,
                          height: 1.8,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Create Account
                      Text(
                        'Create Account',
                        style: TextStyles.displayMedium.copyWith(
                          color: _darkText,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // FULL NAME
                      // ==================================================
                      formField(
                        label: 'FULL NAME',
                        hint: 'Enter your name',
                        icon: Icons.person_outline,
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // EMAIL
                      // ==================================================
                      formField(
                        label: 'EMAIL ADDRESS',
                        hint: 'name@example.com',
                        icon: Icons.mail_outline,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }

                          final emailRegExp =
                              RegExp(r'^[\w\.\+\-]+@[\w\-]+\.\w{2,}$');
                          if (!emailRegExp.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // PASSWORD
                      // ==================================================
                      formField(
                        label: 'PASSWORD',
                        hint: '........',
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: _roseText,
                            size: 21,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }

                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // CONFIRM PASSWORD
                      // ==================================================
                      formField(
                        label: 'CONFIRM PASSWORD',
                        hint: '........',
                        icon: Icons.lock_outline,
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: _roseText,
                            size: 21,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }

                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ==================================================
                      // PHONE
                      // ==================================================
                      formField(
                        label: 'PHONE NUMBER',
                        hint: '+91 00000 00000',
                        icon: Icons.phone_outlined,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }

                          final digits = value.replaceAll(RegExp(r'\D'), '');
                          if (digits.length < 7) {
                            return 'Please enter a valid phone number';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      if (authState.status == AuthStatus.error &&
                          authState.error != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: AppColors.error, width: 0.5),
                          ),
                          child: Text(
                            authState.error!,
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],

                      // ==================================================
                      // REGISTER BUTTON
                      // ==================================================
                      PrimaryButton(
                        label: 'REGISTER',
                        isLoading: authState.status == AuthStatus.loading,
                        onPressed: register,
                      ),

                      const SizedBox(height: 24),

                      // ==================================================
                      // SIGN IN
                      // ==================================================
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.push(RouteNames.signIn);
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyles.bodyMedium.copyWith(
                                color: const Color(0xFFB79789),
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Already have an account? ',
                                ),
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: _roseText,
                                    decoration: TextDecoration.underline,
                                    decorationColor: _roseText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
