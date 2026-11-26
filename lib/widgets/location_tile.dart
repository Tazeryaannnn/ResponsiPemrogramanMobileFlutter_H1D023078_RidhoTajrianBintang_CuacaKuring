import 'package:cuaca_kuring/models/location_model.dart';
import 'package:cuaca_kuring/utils/app_strings.dart';
import 'package:flutter/material.dart';

class LocationTile extends StatelessWidget {
  final LocationModel location;
  final bool isFavorite;
  final AppLanguage language;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onRemoveHistory;

  const LocationTile({
    super.key,
    required this.location,
    required this.isFavorite,
    required this.language,
    required this.onTap,
    required this.onToggleFavorite,
    this.onRemoveHistory,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(language);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withAlpha(120)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.location_city_rounded, size: 20),
        ),
        title: Text(
          location.name,
          style: textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${location.displaySubtitle}  •  ${location.shortCoordinate}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: isFavorite
                  ? strings.removeFavoriteTooltip
                  : strings.addFavoriteTooltip,
              icon: Icon(
                isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                color: isFavorite ? Colors.amber.shade700 : null,
              ),
              onPressed: onToggleFavorite,
            ),
            if (onRemoveHistory != null)
              IconButton(
                tooltip: strings.removeHistoryTooltip,
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: onRemoveHistory,
              ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
