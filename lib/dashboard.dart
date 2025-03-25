import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'cocktail_card.dart';
import 'cocktail_providers.dart';
import 'new_item.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIngredient = ref.watch(selectedIngredientProvider);
    final ingredients = ref.watch(ingredientsProvider);
    final cocktailsAsync = ref.watch(cocktailsProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF5946E8),
        foregroundColor: Colors.white,
        title: const Text(
          'Cocktails',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewItemScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Ingredient selection chips
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    ingredients.map((ingredient) {
                      final isSelected = ingredient == selectedIngredient;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          selectedColor: const Color(0xFF5946E8),
                          backgroundColor: Colors.grey[200],
                          label: Text(
                            ingredient.toUpperCase(),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight:
                                  isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          onSelected: (selected) {
                            ref
                                .read(selectedIngredientProvider.notifier)
                                .state = ingredient;
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          // Network test button (for debugging)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  final response = await http.get(
                    Uri.parse('https://picsum.photos/200'),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Network status: ${response.statusCode}'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Network error: ${e.toString()}')),
                    );
                  }
                }
              },
              child: const Text('Test Network'),
            ),
          ),

          // Cocktail list
          Expanded(
            child: cocktailsAsync.when(
              data: (cocktails) {
                if (cocktails.isEmpty) {
                  return const Center(
                    child: Text('No cocktails found for this ingredient'),
                  );
                }

                return ListView.builder(
                  itemCount: cocktails.length,
                  itemBuilder: (context, index) {
                    return CocktailCard(cocktail: cocktails[index]);
                  },
                );
              },
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF5946E8)),
                  ),
              error:
                  (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFF5946E8),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading data: ${error.toString()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Use invalidate instead of refresh for better practice
                            ref.invalidate(cocktailsProvider);
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
