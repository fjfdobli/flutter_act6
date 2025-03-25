class Cocktail {
  final String id;
  final String name;
  final String imageUrl;

  Cocktail({required this.id, required this.name, required this.imageUrl});

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
      id: json['idDrink'] ?? '',
      name: json['strDrink'] ?? '',
      imageUrl: json['strDrinkThumb'] ?? '',
    );
  }
}
