import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  // ============================================================
  // RARE COLORS
  // ============================================================

  static const Color _pageBackground = Color(0xFFEEDDD5);
  static const Color _headerBackground = Color(0xFFFAF5F0);
  static const Color _inputBackground = Color(0xFFFAF5F0);

  static const Color _darkText = Color(0xFF30201E);
  static const Color _roseText = Color(0xFFC28E80);
  static const Color _inputBorder = Color(0xFFE2CCC4);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> signIn() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authProvider.notifier).login(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration inputDecoration({
    required IconData icon,
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,

      prefixIcon: Icon(
        icon,
        color: _roseText,
        size: 22,
      ),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: _inputBackground,

      hintStyle: TextStyles.bodyMedium.copyWith(
        color: const Color(0xFFBFA79E),
      ),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: _inputBorder,
          width: 1,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: _roseText,
          width: 1,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyles.bodyMedium.copyWith(
          color: _darkText,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  // ============================================================
  // FORM FIELD
  // ============================================================

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

          style: TextStyles.bodyMedium.copyWith(
            color: _darkText,
          ),

          decoration: inputDecoration(
            icon: icon,
            hint: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        context.go(RouteNames.home);
      }
    });

    return Scaffold(
      backgroundColor: _pageBackground,

      body: SafeArea(
        child: Column(
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Container(
              width: double.infinity,
              color: _headerBackground,
              padding: const EdgeInsets.fromLTRB(
                32,
                16,
                32,
                16,
              ),
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

                  // Elevating your daily ritual
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

            // ======================================================
            // BODY
            // ======================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  55,
                  24,
                  55,
                  40,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // YOUR SANCTUARY AWAITS
                      Text(
                        'YOUR SANCTUARY AWAITS',
                        style: TextStyles.eyebrow.copyWith(
                          color: _roseText,
                          letterSpacing: 5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Welcome Back
                      Text(
                        'Welcome Back',
                        style: TextStyles.displayMedium.copyWith(
                          color: _darkText,
                        ),
                      ),

                      const SizedBox(height: 32),

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
                            size: 22,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          return null;
                        },
                      ),

                      // ==================================================
                      // FORGOT PASSWORD
                      // ==================================================

                      const SizedBox(height: 16),

                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            // Add forgot password route here
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyles.bodyMedium.copyWith(
                              color: _roseText,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: _roseText,
                            ),
                          ),
                        ),
                      ),

                      // ==================================================
                      // ERROR MESSAGE
                      // ==================================================

                      if (authState.status == AuthStatus.error &&
                          authState.error != null) ...[
                        const SizedBox(height: 24),
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
                      // SIGN IN BUTTON
                      // ==================================================

                      const SizedBox(height: 32),

                      PrimaryButton(
                        label: 'SIGN IN',
                        isLoading: authState.status == AuthStatus.loading,
                        onPressed: signIn,
                      ),

                      // ==================================================
                      // CREATE ACCOUNT
                      // ==================================================

                      const SizedBox(height: 32),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            context.go(
                              RouteNames.createAccount,
                            );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyles.bodyMedium.copyWith(
                                color: const Color(0xFFB79789),
                              ),
                              children: [
                                const TextSpan(
                                  text: "Don't have an account? ",
                                ),
                                TextSpan(
                                  text: 'Create one',
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: _roseText,
                                    fontSize: 16,
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