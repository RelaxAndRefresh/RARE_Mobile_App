import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/cards/rare_card.dart';

class PlanMyReliefScreen extends ConsumerStatefulWidget {
  const PlanMyReliefScreen({super.key});

  @override
  ConsumerState<PlanMyReliefScreen> createState() => _PlanMyReliefScreenState();
}

class _PlanMyReliefScreenState extends ConsumerState<PlanMyReliefScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(bookingProvider.notifier).loadServices());
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);

    ref.listen<BookingState>(bookingProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.terracotta,
          ),
        );
        ref.read(bookingProvider.notifier).clearError();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Plan My Relief')),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Center(
          child: bookingState.isLoading
              ? const CircularProgressIndicator(color: AppColors.mocha)
              : bookingState.services.isEmpty
                  ? RareCard(
                      child: Column(
                        children: [
                          Text(
                            'Would a guided facial help with what you\'ve been feeling?',
                            style: TextStyles.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Based on your recent skin logs — no pressure, only if it feels right.',
                            style: TextStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            label: 'See Available Slots',
                            onPressed: () {
                              context.go(RouteNames.bookingWebview);
                            },
                          ),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...bookingState.services.map(
                          (service) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: RareCard(
                              child: Column(
                                children: [
                                  Text(
                                    service.name,
                                    style: TextStyles.headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                  if (service.description != null) ...[
                                    const SizedBox(height: 6),
                                    Text(
                                      service.description!,
                                      style: TextStyles.bodySmall,
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                  const SizedBox(height: 6),
                                  Text(
                                    '${service.durationMinutes} min · ₹${service.price.toStringAsFixed(0)}',
                                    style: TextStyles.bodySmall.copyWith(
                                      color: AppColors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  PrimaryButton(
                                    label: 'See Available Slots',
                                    onPressed: () async {
                                      await ref
                                          .read(bookingProvider.notifier)
                                          .loadAvailability(
                                            service.id,
                                            DateTime.now(),
                                          );
                                      if (context.mounted) {
                                        context.go(RouteNames.bookingWebview);
                                      }
                                    },
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
    );
  }
}
