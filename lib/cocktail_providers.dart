import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cocktail_model.dart';
import 'coctail_service.dart';

// Provider for the currently selected ingredient
final selectedIngredientProvider = StateProvider<String>((ref) => 'vodka');

// List of available ingredients to choose from
final ingredientsProvider = Provider<List<String>>(
  (ref) => ['vodka', 'gin', 'rum', 'tequila', 'strawberries', 'coffee'],
);

// Provider for the cocktails based on the selected ingredient
final cocktailsProvider = FutureProvider<List<Cocktail>>((ref) {
  final ingredient = ref.watch(selectedIngredientProvider);
  return CocktailService.getCocktailsByIngredient(ingredient);
});

// Provider for cocktail details
final cocktailDetailsProvider =
    FutureProvider.family<Map<String, dynamic>?, String>((ref, id) {
      return CocktailService.getCocktailDetails(id);
    });
