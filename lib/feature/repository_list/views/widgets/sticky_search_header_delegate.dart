import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';

class StickySearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final String currentUserName;
  final int totalCount;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClearSearch;

  const StickySearchHeaderDelegate({
    required this.searchController,
    required this.currentUserName,
    required this.totalCount,
    required this.onSubmitted,
    required this.onClearSearch,
  });

  @override
  double get minExtent => 82.0;

  @override
  double get maxExtent => 82.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final appColor = context.color;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchBar(
            controller: searchController,
            elevation: const WidgetStatePropertyAll(0),
            backgroundColor: WidgetStatePropertyAll(
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
            ),
            constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 12),
            ),
            leading: Icon(
              Icons.alternate_email_rounded,
              size: 16,
              color: appColor.primaryColor,
            ),
            hintText: 'Search username (e.g. flutter, google)...',
            hintStyle: WidgetStatePropertyAll(
              AppTextStyle.bodySmall.copyWith(
                color: appColor.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            textStyle: WidgetStatePropertyAll(
              AppTextStyle.bodySmall.copyWith(
                color: appColor.textPrimary,
              ),
            ),
            trailing: [
              if (searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.cancel_rounded,
                    size: 16,
                    color: appColor.textSecondary,
                  ),
                  onPressed: onClearSearch,
                  splashRadius: 16,
                ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                color: appColor.primaryColor,
                onPressed: () => onSubmitted(searchController.text),
                splashRadius: 16,
              ),
            ],
            onSubmitted: onSubmitted,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Showing $totalCount repositories for @$currentUserName',
                style: AppTextStyle.labelSmall.copyWith(
                  color: appColor.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                'Infinite Scroll',
                style: AppTextStyle.labelSmall.copyWith(
                  color: appColor.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant StickySearchHeaderDelegate oldDelegate) =>
      oldDelegate.currentUserName != currentUserName ||
      oldDelegate.totalCount != totalCount;
}
