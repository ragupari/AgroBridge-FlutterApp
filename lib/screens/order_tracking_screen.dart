import "package:flutter/material.dart";

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  // Example: You’d fetch from DB using orderId
  final List<Map<String, dynamic>> _statusSteps = const [
    {
      'title': 'Order Placed',
      'subtitle': 'Received',
      'completed': true,
      'time': '10:30 AM',
    },
    {
      'title': 'Preparing',
      'subtitle': 'Packing items',
      'completed': true,
      'time': '10:45 AM',
    },
    {
      'title': 'Out for Delivery',
      'subtitle': 'Rider on the way',
      'completed': false,
      'time': '',
    },
    {
      'title': 'Delivered',
      'subtitle': 'Order delivered',
      'completed': false,
      'time': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tracking Order #$orderId")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: _statusSteps.asMap().entries.map((entry) {
            int idx = entry.key;
            var step = entry.value;
            bool isLast = idx == _statusSteps.length - 1;
            bool isCompleted = step['completed'];

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: isCompleted
                          ? Colors.green
                          : Colors.grey.shade300,
                      child: Icon(
                        isCompleted ? Icons.check : Icons.circle,
                        size: 12,
                        color: isCompleted ? Colors.white : Colors.grey,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 50,
                        color: isCompleted
                            ? Colors.green
                            : Colors.grey.shade300,
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        step['subtitle'],
                        style: const TextStyle(color: Colors.grey),
                      ),
                      if (step['time'] != '')
                        Text(
                          step['time'],
                          style: const TextStyle(fontSize: 12),
                        ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
