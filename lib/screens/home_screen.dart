import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_stack/widgets/banner_slider.dart';
import 'package:green_stack/widgets/our_products.dart';
import '../widgets/main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        "name": "Basumathy Rice",
        'image':
            'https://www.world-grain.com/ext/resources/Article-Images/2020/05/Rice_AdobeStock_64819529_E.jpg?height=667&t=1591304238&width=1080',
        'price': '₹250',
        'discount': '10% OFF',
      },
      {
        "name": "Kurakan Rice",
        'image':
            'https://www.world-grain.com/ext/resources/Article-Images/2020/05/Rice_AdobeStock_64819529_E.jpg?height=667&t=1591304238&width=1080',
        'price': '₹500',
        'discount': '20% OFF',
      },
      {
        "name": "Saamai Rice",
        'image':
            'https://www.world-grain.com/ext/resources/Article-Images/2020/05/Rice_AdobeStock_64819529_E.jpg?height=667&t=1591304238&width=1080',
        'price': '₹320',
        'discount': '15% OFF',
      },
    ];

    return MainLayout(
      currentIndex: 0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const BannerSlider(),
            const SizedBox(height: 10),
            const OurProducts(),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 0,
                ),
                child: Text(
                  'Famous Search',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                    color: const Color.fromARGB(221, 92, 92, 92),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // 🛒 Product cards list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/product',
                    arguments: product,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: Colors.green.shade800,
                          width: 6,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                            ),
                            child: Image.network(
                              product['image'],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name: ${product['name']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 98, 98, 98),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Price: ${product['price']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 98, 98, 98),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Discount: ${product['discount']}',
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
