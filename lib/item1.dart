import 'package:flutter/material.dart';

class Item1Screen extends StatelessWidget {
  const Item1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item #1', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF5946E8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(children: [_buildItemCard("Title 1", "Description")]),
    );
  }

  Widget _buildItemCard(String title, String description) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with X
          Container(
            height: 180,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Title and description
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
