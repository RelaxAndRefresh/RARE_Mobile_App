import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/booking_provider.dart';
import '../../providers/commerce_provider.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';

class OrderBookingHistoryScreen extends ConsumerStatefulWidget {
  const OrderBookingHistoryScreen({super.key});

  @override
  ConsumerState<OrderBookingHistoryScreen> createState() =>
      _OrderBookingHistoryScreenState();
}

class _OrderBookingHistoryScreenState
    extends ConsumerState<OrderBookingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(bookingProvider.notifier).loadBookings();
      ref.read(commerceProvider.notifier).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingProvider);
    final commerceState = ref.watch(commerceProvider);

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

    ref.listen<CommerceState>(commerceProvider, (prev, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.terracotta,
          ),
        );
        ref.read(commerceProvider.notifier).clearError();
      }
    });

    final upcomingBookings = bookingState.bookings
        .where((b) => b['status'] == 'confirmed' || b['status'] == 'pending')
        .toList();
    final pastBookings = bookingState.bookings
        .where((b) => b['status'] == 'completed' || b['status'] == 'cancelled')
        .toList();
    final pastOrders = commerceState.recentOrders;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Orders & Bookings'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: bookingState.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.mocha),
              )
            : ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      'UPCOMING',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 3,
                        color: AppColors.terracotta,
                      ),
                    ),
                  ),
                  if (upcomingBookings.isEmpty)
                    RareCard(
                      child: Text(
                        'No upcoming bookings',
                        style: TextStyles.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else ...[
                    for (final booking in upcomingBookings)
                      _buildUpcomingBooking(context, booking),
                  ],
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 4),
                    child: Text(
                      'PAST',
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 3,
                        color: AppColors.terracotta,
                      ),
                    ),
                  ),
                  if (pastBookings.isEmpty && pastOrders.isEmpty)
                    const ListTileWidget(
                      leading: Icon(Icons.calendar_today,
                          size: 16, color: AppColors.grey),
                      title: 'No past bookings or orders',
                    )
                  else ...[
                    for (final booking in pastBookings)
                      ListTileWidget(
                        leading: const Icon(Icons.calendar_today,
                            size: 16, color: AppColors.grey),
                        title: booking['service_name']?.toString() ?? 'Booking',
                        subtitle: _formatDate(booking['scheduled_at']?.toString()),
                        trailing:
                            const Icon(Icons.chevron_right, color: AppColors.rose),
                      ),
                    for (final order in pastOrders)
                      ListTileWidget(
                        leading: const Icon(Icons.shopping_bag,
                            size: 16, color: AppColors.grey),
                        title: order['order_number']?.toString() ?? 'Order',
                        subtitle: _formatDate(order['created_at']?.toString()),
                        trailing:
                            const Icon(Icons.chevron_right, color: AppColors.rose),
                      ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Need to reschedule? We can help with that.',
                    style: TextStyles.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildUpcomingBooking(BuildContext context, Map<String, dynamic> booking) {
    final scheduledAt = booking['scheduled_at'] != null
        ? DateTime.tryParse(booking['scheduled_at'].toString())
        : null;

    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: AppColors.rose),
              const SizedBox(width: 8),
              Text(
                scheduledAt != null
                    ? '${_dayName(scheduledAt.weekday)}, ${scheduledAt.hour}:${scheduledAt.minute.toString().padLeft(2, '0')} ${scheduledAt.hour >= 12 ? 'PM' : 'AM'}'
                    : 'TBD',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            booking['service_name']?.toString() ?? 'Booking',
            style: TextStyles.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'RARE Studio, Bengaluru',
            style: TextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.mocha,
              borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
              border: Border.all(color: AppColors.gold, width: 0.5),
            ),
            child: Center(
              child: Text(
                'CHECK-IN QR',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.cream,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GhostButton(
            label: 'Manage Booking',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Manage booking flow would open here.'),
                  backgroundColor: AppColors.mocha,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    final dt = DateTime.tryParse(dateStr);
    if (dt == null) return dateStr;
    return '${dt.day} ${_monthName(dt.month)} ${dt.year}';
  }

  String _dayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
