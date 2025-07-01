import "package:flutter/material.dart";
import "package:green_stack/widgets/main_layout.dart";

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(child: Text("Hi"), currentIndex: 1);
  }
}