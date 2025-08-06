import 'package:flutter/material.dart';
import 'package:green_stack/constants/colors.dart';

// Dummy product class
class Product {
  final String name;
  final String category;
  final String description;
  final String image;
  final String location;
  final double price;

  Product({
    required this.name,
    required this.category,
    required this.description,
    required this.image,
    required this.location,
    required this.price,
  });
}

// Dummy product list
final List<Product> allProducts = [
  Product(
    name: "Goat A",
    category: "Goat",
    description: "Fresh goat meat.",
    image: "images/goat.png",
    location: "Colombo",
    price: 12000,
  ),
  Product(
    name: "Chicken B",
    category: "Chicken",
    description: "Organic chicken.",
    image: "images/chicken.png",
    location: "Kandy",
    price: 800,
  ),
  Product(
    name: "Eggs C",
    category: "Egg",
    description: "Farm fresh eggs.",
    image: "images/egg.png",
    location: "Jaffna",
    price: 300,
  ),
  Product(
    name: "Goat B",
    category: "Goat",
    description: "Young goat.",
    image: "images/goat.png",
    location: "Galle",
    price: 11000,
  ),
];

class CategoryFilterScreen extends StatefulWidget {
  const CategoryFilterScreen({super.key});

  @override
  State<CategoryFilterScreen> createState() => _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {
  late String selectedCategory;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    selectedCategory = ModalRoute.of(context)!.settings.arguments as String;

    // Filter by category and search location
    final List<Product> filteredProducts = allProducts.where((product) {
      final matchesCategory = product.category == selectedCategory;
      final matchesSearch = product.location.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          selectedCategory,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.paleGreen,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by location...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Products grid
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Text(
                      "No products found in $selectedCategory for \"$searchQuery\".",
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(221, 211, 230, 215),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  product.image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "1kg: ${product.price.toStringAsFixed(0)} Rs",
                                style: const TextStyle(
                                  color: AppColors.paleGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "📍 ${product.location}",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
