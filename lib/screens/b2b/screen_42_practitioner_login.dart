import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/routes/route_names.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/practitioner_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

class PractitionerLoginScreen extends ConsumerStatefulWidget {
  const PractitionerLoginScreen({super.key});

  @override
  ConsumerState<PractitionerLoginScreen> createState() =>
      _PractitionerLoginScreenState();
}

class _PractitionerLoginScreenState
    extends ConsumerState<PractitionerLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _clientIdController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _clientIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(practitionerAuthProvider);
    final clientState = ref.watch(clientSummaryProvider);

    ref.listen<PractitionerAuthState>(practitionerAuthProvider, (prev, next) {
      if (next.isLoggedIn && next.error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful. Loading client data...'),
            backgroundColor: AppColors.mocha,
            duration: Duration(seconds: 2),
          ),
        );
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(practitionerAuthProvider.notifier).reset();
      }
    });

    ref.listen<ClientSummaryState>(clientSummaryProvider, (prev, next) {
      if (next.client != null) {
        context.go(RouteNames.preTreatmentSync);
      }
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
        ref.read(clientSummaryProvider.notifier).clear();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Practitioner View'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!authState.isLoggedIn) ...[
              _buildLoginForm(authState),
            ] else ...[
              if (clientState.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(color: AppColors.rose),
                  ),
                )
              else if (clientState.client != null)
                _buildClientSummary(clientState.client!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(PractitionerAuthState authState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RareCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PRACTITIONER CREDENTIALS',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  hintStyle: TextStyle(color: AppColors.grey, fontSize: 13),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.rose),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                style: TextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle:
                      const TextStyle(color: AppColors.grey, fontSize: 13),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.rose),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                style: TextStyles.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryButton(
          label: 'Login',
          isLoading: authState.isLoading,
          onPressed: _handleLogin,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.linen,
            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
            border: Border.all(color: AppColors.gold, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: AppColors.gold,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'SECURE SESSION',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 2,
                      color: AppColors.gold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Wiped from tablet storage the moment the appointment is marked complete.',
                style: TextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClientSummary(dynamic client) {
    final skinSummary = client.skinSummary ?? {};
    final activeRoutines = client.activeRoutines ?? [];
    final latestCheckin = client.latestCheckin ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RareCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CLIENT SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                client.userName,
                style: TextStyles.displayMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Skin type: ${skinSummary['skin_type'] ?? 'N/A'} · '
                'Recent tags: ${skinSummary['concerns'] ?? 'N/A'} · '
                'No active pauses.',
                style: TextStyles.bodyMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _statChip(
                      '${activeRoutines.length} routines', AppColors.rose),
                  const SizedBox(width: 8),
                  _statChip(
                      '${latestCheckin['visits'] ?? 0} visits', AppColors.gold),
                  const SizedBox(width: 8),
                  _statChip(
                      '${latestCheckin['insights'] ?? 0} insights',
                      AppColors.terracotta),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Client data is available for review. '
          'All data is read-only and session-limited.',
          style: TextStyles.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        RareCard(
          child: Column(
            children: [
              const Text(
                'ACTIONS',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                label: 'Start Appointment',
                onPressed: () {
                  context.go(RouteNames.preTreatmentSync);
                },
              ),
              const SizedBox(height: 8),
              GhostButton(
                label: 'View Full Profile',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening read-only profile...'),
                      backgroundColor: AppColors.mocha,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter email and password.'),
          backgroundColor: AppColors.error,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    ref.read(practitionerAuthProvider.notifier).login(
          email: email,
          password: password,
        );
  }

  Widget _statChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
        ),
      ),
    );
  }
}
