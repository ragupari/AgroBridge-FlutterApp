// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_stack/constants/colors.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;

  void increment() {
    setState(() {
      quantity++;
    });
  }

  void decrement() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(fontWeight: FontWeight.bold);
    TextStyle valueStyle = TextStyle(color: Colors.grey[800]);

    Widget buildRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.paleGreen),
            SizedBox(width: 8),
            Text("$label: ", style: labelStyle.copyWith(fontSize: 17)),
            Expanded(
              child: Text(value, style: valueStyle.copyWith(fontSize: 17)),
            ),
          ],
        ),
      );
    }

    // 🔒 Hardcoded product data (temporary until backend integration)
    final Map<String, dynamic> product = {
      "name": "Raw Red Rice",
      "category": "Rice",
      "price": "250",
      "discount": "10%",
      "unit_type": "kg",
      "location": "Thanjavur",
      "remaining_quantity": 120,
      "cultivate_date": "2025-06-01",
      "expiry_date": "2026-01-01",
      "is_negotiable": 1,
      "status": "Available",
      "description":
          "This rice is organically grown and sourced from trusted local farms. Ideal for daily consumption and packed with nutrients.",
      "image":
          "https://www.world-grain.com/ext/resources/Article-Images/2020/05/Rice_AdobeStock_64819529_E.jpg?height=667&t=1591304238&width=1080",
    };

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              // width: 600,
              child: Image.network(
                product['image'],
                fit: BoxFit.cover,
                height: 300,
                errorBuilder: (context, error, stackTrace) {
                  return const Text('⚠️ Image failed to load');
                },
              ),
            ),

            // Back button with blur effect
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Scrollable bottom sheet with product info
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              maxChildSize: 1,
              minChildSize: 0.65,
              builder: (context, scrollController) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Drag indicator bar
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          child: Center(
                            child: Container(
                              height: 5,
                              width: 35,
                              color: Colors.black12,
                            ),
                          ),
                        ),

                        // Product name
                        Text(
                          product['name'],
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: const Color.fromARGB(255, 116, 116, 116),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Price & Discount
                        Row(
                          children: [
                            Text(
                              '₹${product['price']} / ${product['unit_type']}',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 118, 118, 118),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Discount: ${product['discount']}',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Description
                        Text(
                          "Description",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 116, 116, 116),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product['description'],
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Product Details Section
                        Text(
                          "Details",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: const Color.fromARGB(255, 116, 116, 116),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow(
                              Icons.category,
                              "Category",
                              product['category'] ?? "N/A",
                            ),
                            buildRow(
                              Icons.location_on,
                              "Location",
                              product['location'] ?? "N/A",
                            ),
                            buildRow(
                              Icons.home_work,
                              "Unit Type",
                              product['unit_type'] ?? "N/A",
                            ),
                            buildRow(
                              Icons.format_list_numbered,
                              "Remaining Quantity",
                              "${product['remaining_quantity'] ?? '0'}",
                            ),
                            buildRow(
                              Icons.info,
                              "Status",
                              product['status'] ?? "Unknown",
                            ),
                            buildRow(
                              product['is_negotiable'] == 1
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              "Is Negotiable",
                              product['is_negotiable'] == 1 ? "Yes" : "No",
                            ),
                            buildRow(
                              Icons.event,
                              "Cultivate Date",
                              product['cultivate_date'] ?? "N/A",
                            ),
                            buildRow(
                              Icons.event_busy,
                              "Expiry Date",
                              product['expiry_date'] ?? "N/A",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Quantity Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Quantity:",
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 116, 116, 116),
                              ),
                            ),
                            const SizedBox(width: 20),

                            // Decrement
                            InkWell(
                              onTap: decrement,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(Icons.remove),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Count Display
                            Text(
                              quantity.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Increment
                            InkWell(
                              onTap: increment,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade700,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Add to Cart button fixed
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                color: Colors.white,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added ${quantity} x ${product['name']} to cart!',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Add to Cart',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
