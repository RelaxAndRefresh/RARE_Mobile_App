import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';

class BookingWebviewScreen extends ConsumerWidget {
  const BookingWebviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final selectedService = bookingState.services.isNotEmpty
        ? bookingState.services.first
        : null;
    final selectedSlot = bookingState.availability.isNotEmpty
        ? bookingState.availability.first
        : null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Booking'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.linen,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.circle,
                    size: 7,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.circle,
                    size: 7,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'relaxedandrefresh.com/book',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (bookingState.isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.mocha),
                ),
              )
            else
              Expanded(
                child: RareCard(
                  backgroundColor: AppColors.cream,
                  elevation: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedSlot != null
                            ? '${(selectedSlot['date'] ?? DateTime.now().toIso8601String()).toString().substring(0, 10).toUpperCase()} · ${selectedSlot['time'] ?? '3:30 PM'}'
                            : 'THURSDAY · 3:30 PM',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        selectedService != null
                            ? '${selectedService.name} — ${selectedService.durationMinutes} min'
                            : 'Restorative Facial — 60 min',
                        style: TextStyles.headlineMedium,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        selectedService?.description ??
                            'Same anonymous-user and offline pre‑flight checks '
                                'as Screen 21 apply here.',
                        style: TextStyles.bodySmall,
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        label: bookingState.isLoading
                            ? 'Confirming...'
                            : 'Confirm & Pay',
                        onPressed: bookingState.isLoading
                            ? null
                            : () async {
                                final serviceId =
                                    selectedService?.id ?? '';
                                final practitionerId = selectedSlot != null
                                    ? (selectedSlot['practitioner_id'] ??
                                            '')
                                        .toString()
                                    : '';
                                final scheduledAt = selectedSlot != null
                                    ? (selectedSlot['date'] ?? '')
                                        .toString()
                                    : DateTime.now()
                                        .add(const Duration(days: 3))
                                        .toIso8601String();
                                final duration =
                                    selectedService?.durationMinutes ?? 60;

                                await ref
                                    .read(bookingProvider.notifier)
                                    .createBooking({
                                  'service_id': serviceId,
                                  'practitioner_id': practitionerId,
                                  'scheduled_at': scheduledAt,
                                  'duration_minutes': duration,
                                });

                                if (context.mounted) {
                                  final updatedState =
                                      ref.read(bookingProvider);
                                  if (updatedState.error == null) {
                                    context.go(
                                      '${RouteNames.checkoutState}?isSuccess=true',
                                    );
                                  } else {
                                    context.go(
                                      '${RouteNames.checkoutState}?isSuccess=false',
                                    );
                                  }
                                }
                              },
                      ),
                      const SizedBox(height: 8),
                      GhostButton(
                        label: 'Cancel',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
