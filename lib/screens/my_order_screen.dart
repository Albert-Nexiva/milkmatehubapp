import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final Icon icon;
  final String title;
  final String description;

  const NotificationItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          NotificationItem(
            icon: Icon(Icons.notification_important),
            title: 'Notification 1',
            description: 'This is the description for notification 1.',
          ),
          NotificationItem(
            icon: Icon(Icons.notification_important),
            title: 'Notification 2',
            description: 'This is the description for notification 2.',
          ),
          // Add more NotificationItems as needed
        ],
      ),
    );
  }
}
