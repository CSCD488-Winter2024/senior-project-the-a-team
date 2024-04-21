import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final VoidCallback onClose;

  const NotificationWidget({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.notifications),
              SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  'New Notification!',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}