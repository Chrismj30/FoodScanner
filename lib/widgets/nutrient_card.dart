import 'package:flutter/material.dart';
import 'package:read_the_label/logic.dart';

Widget NutrientCard(BuildContext context, Map<String, dynamic> nutrient,
    Map<String, double> dailyIntake) {
  final name = nutrient['Nutrient'];
  final current = dailyIntake[name] ?? 0.0;
  final total = double.tryParse(nutrient['Current Daily Value']
          .replaceAll(RegExp(r'[^0-9\.]'), '')) ??
      0.0;
  final percent = current / total;
  final Logic logic = Logic();

  final unit = logic.getUnit(name);

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceVariant,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: logic.getColorForPercent(percent, context).withOpacity(0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Nutrient Name and Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: logic.getColorForPercent(percent, context).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                logic.getNutrientIcon(name),
                color: logic.getColorForPercent(percent, context),
                size: 20,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Progress Indicator
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Theme.of(context).colorScheme.background.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
                logic.getColorForPercent(percent, context)),
            minHeight: 8,
          ),
        ),

        // Values
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${current.toStringAsFixed(1)}$unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: logic.getColorForPercent(percent, context).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(percent * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: logic.getColorForPercent(percent, context),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

