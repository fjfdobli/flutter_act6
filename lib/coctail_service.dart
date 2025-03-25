import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cocktail_model.dart';

class CocktailService {
  static Future<List<Cocktail>> getCocktailsByIngredient(
    String ingredient,
  ) async {
    // Try to use the actual API first with timeout
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredient',
            ),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['drinks'] != null) {
          return (data['drinks'] as List)
              .map((drink) => Cocktail.fromJson(drink))
              .toList();
        }
      }
      // If we get here, something went wrong with the API call
      return _getMockCocktails(ingredient);
    } catch (e) {
      // If an error occurs, use mock data instead
      return _getMockCocktails(ingredient);
    }
  }

  static Future<Map<String, dynamic>?> getCocktailDetails(String id) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=$id',
            ),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['drinks'] != null && data['drinks'].isNotEmpty) {
          return data['drinks'][0];
        }
      }
      // If we get here, use mock data
      return _getMockCocktailDetails(id);
    } catch (e) {
      return _getMockCocktailDetails(id);
    }
  }

  // Mock data for cocktails based on ingredient
  static List<Cocktail> _getMockCocktails(String ingredient) {
    // Use picsum photos for reliable image loading
    const baseUrl = 'https://picsum.photos/300/200?random=';

    final Map<String, List<Cocktail>> mockData = {
      'vodka': [
        Cocktail(id: '11000', name: 'Moscow Mule', imageUrl: '${baseUrl}1'),
        Cocktail(id: '11001', name: 'Vodka Martini', imageUrl: '${baseUrl}2'),
        Cocktail(id: '11002', name: 'Bloody Mary', imageUrl: '${baseUrl}3'),
      ],
      'gin': [
        Cocktail(id: '11003', name: 'Gin and Tonic', imageUrl: '${baseUrl}4'),
        Cocktail(id: '11004', name: 'Negroni', imageUrl: '${baseUrl}5'),
        Cocktail(id: '11005', name: 'Tom Collins', imageUrl: '${baseUrl}6'),
      ],
      'rum': [
        Cocktail(id: '11006', name: 'Mojito', imageUrl: '${baseUrl}7'),
        Cocktail(id: '11007', name: 'Piña Colada', imageUrl: '${baseUrl}8'),
        Cocktail(id: '11008', name: 'Daiquiri', imageUrl: '${baseUrl}9'),
      ],
      'tequila': [
        Cocktail(id: '11009', name: 'Margarita', imageUrl: '${baseUrl}10'),
        Cocktail(
          id: '11010',
          name: 'Tequila Sunrise',
          imageUrl: '${baseUrl}11',
        ),
        Cocktail(id: '11011', name: 'Paloma', imageUrl: '${baseUrl}12'),
      ],
      'strawberries': [
        Cocktail(
          id: '11012',
          name: 'Strawberry Daiquiri',
          imageUrl: '${baseUrl}13',
        ),
        Cocktail(
          id: '11013',
          name: 'Strawberry Margarita',
          imageUrl: '${baseUrl}14',
        ),
        Cocktail(
          id: '11014',
          name: 'Strawberry Mojito',
          imageUrl: '${baseUrl}15',
        ),
      ],
      'coffee': [
        Cocktail(id: '11015', name: 'Irish Coffee', imageUrl: '${baseUrl}16'),
        Cocktail(
          id: '11016',
          name: 'Espresso Martini',
          imageUrl: '${baseUrl}17',
        ),
        Cocktail(id: '11017', name: 'White Russian', imageUrl: '${baseUrl}18'),
      ],
    };

    // Return the mock data for the requested ingredient or an empty list if not found
    return mockData[ingredient] ?? [];
  }

  // Mock data for cocktail details
  static Map<String, dynamic>? _getMockCocktailDetails(String id) {
    final Map<String, Map<String, dynamic>> mockDetails = {
      '11000': {
        'strDrink': 'Moscow Mule',
        'strInstructions':
            'Combine vodka and ginger beer in a copper mug filled with ice. Add lime juice. Garnish with a lime slice.',
        'strDrinkThumb': 'https://picsum.photos/300/200?random=1',
      },
      '11001': {
        'strDrink': 'Vodka Martini',
        'strInstructions':
            'Mix vodka and dry vermouth in a mixing glass with ice. Stir well. Strain into a chilled martini glass. Garnish with olives or a lemon twist.',
        'strDrinkThumb': 'https://picsum.photos/300/200?random=2',
      },
      // Add more as needed
    };

    // Return the mock details for the requested ID or a generic one if not found
    return mockDetails[id] ??
        {
          'strDrink': 'Generic Cocktail',
          'strInstructions':
              'This is a delicious cocktail that combines various ingredients. Mix well and enjoy!',
          'strDrinkThumb': 'https://picsum.photos/300/200?random=100',
        };
  }
}
