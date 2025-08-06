// ignore_for_file: sort_child_properties_last

import "package:flutter/material.dart";
import "package:green_stack/widgets/main_layout.dart";

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(child: Text("Hi"), currentIndex: 2);
  }
}
