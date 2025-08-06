// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OurProducts extends StatefulWidget {
  const OurProducts({super.key});

  @override
  State<OurProducts> createState() => _OurProductsState();
}

class _OurProductsState extends State<OurProducts> {
  // Current selected category index
  int selectedIndex = 0;

  // List of product categories
  final List<Map<String, String>> categories = [
    {'label': 'Goat', 'image': 'images/goat.png'},
    {'label': 'Chicken', 'image': 'images/chicken.png'},
    {'label': 'Egg', 'image': 'images/egg.png'},
    {'label': 'Rice Variety', 'image': 'images/rice.png'},
    {'label': 'Vegetables', 'image': 'images/vegetables.png'},
    {'label': 'Fruits', 'image': 'images/fruits.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 150,
          child: Row(
            children: List.generate(categories.length, (index) {
              final isSelected = selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    Navigator.pushNamed(
                      context,
                      '/categoryFilterScreen',
                      arguments: categories[index]['label'],
                    );
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.only(
                          top: 50,
                          left: 40,
                          right: 40,
                          bottom: 20,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green[800] : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color.fromARGB(
                                      255,
                                      93,
                                      113,
                                      101,
                                    ).withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: Text(
                          categories[index]['label']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -30,
                        child: Image.asset(
                          categories[index]['image']!,
                          width: 75,
                          height: 93,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
