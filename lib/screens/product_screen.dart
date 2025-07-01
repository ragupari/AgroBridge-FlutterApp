import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    // Retrieve the product data passed from previous screen
    final Map<String, dynamic> product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Image.network(
                product['image'],
                fit: BoxFit.cover,
                height: 300,
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

                        // Price & Discount Row
                        Row(
                          children: [
                            Text(
                              'Price: ${product['price']}',
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromARGB(255, 118, 118, 118),
                              ),
                            ),
                            const SizedBox(width: 100),
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
                        const Text(
                          'This rice is organically grown and sourced from trusted local farms. Ideal for daily consumption and packed with nutrients.',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),

                        const SizedBox(height: 20),

                        // Quantity selector
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

                            // Decrement button
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

                            // Quantity display
                            Text(
                              quantity.toString(),
                              style: GoogleFonts.outfit(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // Increment button
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

                        const SizedBox(
                          height: 80,
                        ), // leave space for Add to Cart button
                      ],
                    ),
                  ),
                );
              },
            ),

            // Add to Cart button fixed at bottom
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
                    // TODO: Add your add to cart logic here
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
