import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../core/theme/text_styles.dart';
import '../../providers/rituals_provider.dart';
import '../../widgets/cards/rare_card.dart';
import '../../widgets/common/aura_widget.dart';
import '../../widgets/tiles/list_tile.dart';

class RareRitualsScreen extends ConsumerStatefulWidget {
  const RareRitualsScreen({super.key});

  @override
  ConsumerState<RareRitualsScreen> createState() => _RareRitualsScreenState();
}

class _RareRitualsScreenState extends ConsumerState<RareRitualsScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(ritualsProvider.notifier).loadAll();
  }

  @override
  Widget build(BuildContext context) {
    final ritualsState = ref.watch(ritualsProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('RARE Rituals'),
        backgroundColor: AppColors.cream,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        child: ListView(
          children: [
            if (ritualsState.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: AppColors.rose),
                ),
              )
            else if (ritualsState.error != null)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Unable to load rituals',
                      style: TextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () =>
                          ref.read(ritualsProvider.notifier).loadAll(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else ...[
              if (ritualsState.featuredRitual != null)
                _buildFeaturedRitual(ritualsState.featuredRitual!)
              else
                _buildDefaultFeaturedRitual(),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  'LIBRARY',
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: 3,
                    color: AppColors.terracotta,
                  ),
                ),
              ),
              if (ritualsState.library.isEmpty)
                _buildDefaultLibraryItems()
              else
                ...ritualsState.library.map((ritual) => _libraryItem(
                      title: ritual.title,
                      subtitle: '${ritual.durationMinutes} min',
                      tag: ritual.category,
                      onTap: () {},
                    )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedRitual(dynamic ritual) {
    return RareCard(
      child: Column(
        children: [
          const Text(
            'FEATURED RITUAL',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ritual.title,
            style: TextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          const AuraWidget(
            isBreathing: true,
            opacity: 0.7,
            scale: 0.7,
          ),
          const SizedBox(height: 14),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.linen,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.replay_10,
                  size: 20,
                  color: AppColors.mocha,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              _buildPlayButton(),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  Icons.forward_10,
                  size: 20,
                  color: AppColors.mocha,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '0:00 / ${ritual.durationMinutes}:00',
            style: TextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultFeaturedRitual() {
    return RareCard(
      child: Column(
        children: [
          const Text(
            'GUIDED BREATHWORK',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Morning Calm',
            style: TextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          const AuraWidget(
            isBreathing: true,
            opacity: 0.7,
            scale: 0.7,
          ),
          const SizedBox(height: 14),
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.linen,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.replay_10,
                  size: 20,
                  color: AppColors.mocha,
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              _buildPlayButton(),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  Icons.forward_10,
                  size: 20,
                  color: AppColors.mocha,
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '4:12 / 10:30',
            style: TextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultLibraryItems() {
    return Column(
      children: [
        _libraryItem(
          title: 'Ingredient Science: Niacinamide',
          subtitle: '4 min',
          tag: 'Education',
          onTap: () {},
        ),
        _libraryItem(
          title: 'Barrier Recovery Reflection',
          subtitle: '5 min',
          tag: 'Reflection',
          onTap: () {},
        ),
        _libraryItem(
          title: 'Morning Gratitude Practice',
          subtitle: '3 min',
          tag: 'Morning Calm',
          onTap: () {},
        ),
        _libraryItem(
          title: 'Evening Wind-Down',
          subtitle: '6 min',
          tag: 'Evening',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPlayButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.mocha,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.play_arrow,
          color: AppColors.cream,
          size: 28,
        ),
      ),
    );
  }

  Widget _libraryItem({
    required String title,
    required String subtitle,
    required String tag,
    required VoidCallback onTap,
  }) {
    return ListTileWidget(
      title: title,
      subtitle: subtitle,
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.linen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 0.5),
        ),
        child: Text(
          tag,
          style: const TextStyle(
            fontSize: 9,
            color: AppColors.mauve,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
