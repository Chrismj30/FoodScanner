import 'package:flutter/material.dart';
import 'package:read_the_label/logic.dart';
import 'package:read_the_label/main.dart';
import 'package:read_the_label/widgets/food_nutreint_tile.dart';
import '../models/food_item.dart';
import 'nutrient_tile.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final Function setState;
  final Logic logic;

  const FoodItemCard({
    super.key,
    required this.item,
    required this.setState,
    required this.logic,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  Theme.of(context).colorScheme.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${item.quantity}${item.unit}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _showEditDialog(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Nutrient grid
          GridView.count(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 3.0,
            children: [
              FoodNutrientTile(
                label: 'Calories',
                value: item
                        .calculateTotalNutrients()['calories']
                        ?.toStringAsFixed(1) ??
                    '0',
                unit: 'kcal',
                icon: Icons.local_fire_department_outlined,
              ),
              FoodNutrientTile(
                label: 'Protein',
                value: item
                        .calculateTotalNutrients()['protein']
                        ?.toStringAsFixed(1) ??
                    '0',
                unit: 'g',
                icon: Icons.fitness_center_outlined,
              ),
              FoodNutrientTile(
                label: 'Carbohydrates',
                value: item
                        .calculateTotalNutrients()['carbohydrates']
                        ?.toStringAsFixed(1) ??
                    '0',
                unit: 'g',
                icon: Icons.grain_outlined,
              ),
              FoodNutrientTile(
                label: 'Fat',
                value:
                    item.calculateTotalNutrients()['fat']?.toStringAsFixed(1) ??
                        '0',
                unit: 'g',
                icon: Icons.opacity_outlined,
              ),
              FoodNutrientTile(
                label: 'Fiber',
                value: item
                        .calculateTotalNutrients()['fiber']
                        ?.toStringAsFixed(1) ??
                    '0',
                unit: 'g',
                icon: Icons.grass_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Edit Quantity',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Poppins',
          ),
        ),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter quantity in ${item.unit}',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontFamily: 'Poppins',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontFamily: 'Poppins',
          ),
          onChanged: (value) {
            double? newQuantity = double.tryParse(value);
            if (newQuantity != null) {
              setState(() {
                item.quantity = newQuantity;
                logic.updateTotalNutrients();
              });
            }
          },
        ),
        actions: [
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Poppins',
              ),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                logic.updateTotalNutrients();
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

