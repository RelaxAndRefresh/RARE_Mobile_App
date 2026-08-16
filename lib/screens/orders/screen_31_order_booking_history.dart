import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../core/routes/route_names.dart';
import '../../widgets/buttons/ghost_button.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/tiles/list_tile.dart';

/// Screen 31 – Order & Booking History
/// Separates upcoming bookings from past orders and completed Rituals.
class OrderBookingHistoryScreen extends StatelessWidget {
  const OrderBookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Orders & Bookings'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            // Upcoming section
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
            // Upcoming booking with Manage Booking option
            _buildUpcomingBooking(context),
            const SizedBox(height: 16),

            // Past section
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
            const ListTileWidget(
              leading:
                  Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
              title: 'Barrier Repair Serum',
              subtitle: '12 Jul 2026',
              trailing: Icon(Icons.chevron_right, color: AppColors.rose),
            ),
            const ListTileWidget(
              leading:
                  Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
              title: 'Guided Reflexology',
              subtitle: '2 Jul 2026',
              trailing: Icon(Icons.chevron_right, color: AppColors.rose),
            ),
            const ListTileWidget(
              leading:
                  Icon(Icons.calendar_today, size: 16, color: AppColors.grey),
              title: 'Restorative Facial',
              subtitle: '22 Jun 2026',
              trailing: Icon(Icons.chevron_right, color: AppColors.rose),
            ),

            const SizedBox(height: 16),

            // Help text
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

  Widget _buildUpcomingBooking(BuildContext context) {
    return RareCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and time
          const Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: AppColors.rose),
              SizedBox(width: 8),
              Text(
                'Thu, 3:30 PM',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Service name
          Text(
            'Restorative Facial — 60 min',
            style: TextStyles.headlineMedium,
          ),
          const SizedBox(height: 4),
          // Location details (simulated)
          Text(
            'RARE Studio, Bengaluru',
            style: TextStyles.bodySmall,
          ),
          const SizedBox(height: 12),
          // Check-in QR placeholder
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
          // Manage Booking button
          GhostButton(
            label: 'Manage Booking',
            onPressed: () {
              // Navigate to booking management webview
              // For now, show a snackbar
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
}
