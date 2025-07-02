import 'package:flutter/material.dart';
import 'package:green_stack/widgets/main_layout.dart';
import 'order_tracking_screen.dart'; // create this next

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  final List<Map<String, dynamic>> orders = const [
    {'id': 'ORD123', 'date': 'Jul 2, 2025', 'status': 'Out for Delivery'},
    {'id': 'ORD122', 'date': 'Jun 30, 2025', 'status': 'Delivered'},
    {'id': 'ORD121', 'date': 'Jun 28, 2025', 'status': 'Preparing'},
  ];
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'out for delivery':
        return Colors.orange;
      case 'delivered':
        return Colors.green;
      case 'preparing':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: orders.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: order['id']),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _getStatusColor(
                            order['status'],
                          ), // you can implement this method
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order['id']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Status: ${order['status']}'),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
