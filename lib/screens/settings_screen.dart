import "package:flutter/material.dart";
import "package:green_stack/widgets/main_layout.dart";

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(child: Text("Hi"), currentIndex: 3);
  }
}
