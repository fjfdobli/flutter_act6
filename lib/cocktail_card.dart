import 'package:flutter/material.dart';
import 'cocktail_model.dart';
import 'coctail_service.dart';
import 'item_details.dart';

class CocktailCard extends StatelessWidget {
  final Cocktail cocktail;

  const CocktailCard({super.key, required this.cocktail});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          try {
            // Fetch cocktail details
            final cocktailDetails = await CocktailService.getCocktailDetails(
              cocktail.id,
            );

            if (cocktailDetails != null && context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ItemDetailsScreen(
                        title: cocktail.name,
                        description:
                            cocktailDetails['strInstructions'] ??
                            'A delicious cocktail.',
                      ),
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Image Implementation
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[300],
                child: Image.network(
                  cocktail.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_bar,
                            size: 48,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cocktail.name,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                        color: const Color(0xFF5946E8),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Cocktail name
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                cocktail.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
