import 'package:flutter/material.dart';
import 'item1.dart'; // Import the item1 screen
import 'new_item.dart'; // Import the new item screen
import 'item_details.dart'; // Import the item details screen

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> items = [
    {
      'title': 'Item #1',
      'icon': Icons.local_shipping,
      'color': Colors.blue,
      'isDefaultItem': true,
    },
    {
      'title': 'Item #2',
      'icon': Icons.analytics,
      'color': Colors.orange,
      'isDefaultItem': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF5946E8),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add new item screen and wait for result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewItemScreen()),
          );

          // If result is not null, add the new item to the dashboard
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              items.add({
                'title': result['title'],
                'description': result['description'],
                'color': _getRandomColor(),
                'icon': _getRandomIcon(),
                'isDefaultItem': false,
              });
            });
          }
        },
        backgroundColor: Color(0xFF5946E8),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              color: Color(0xFF5946E8).withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to Clearfreight Dashboard",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Manage your shipments and track deliveries",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Dashboard content - dynamic cards based on items
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildDashboardCard(
                      context,
                      items[index]['title'],
                      items[index]['icon'],
                      items[index]['color'],
                      () {
                        if (items[index]['isDefaultItem'] == true) {
                          // Handle default items (Item #1 and Item #2)
                          if (items[index]['title'] == 'Item #1') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Item1Screen(),
                              ),
                            );
                          } else {
                            // For Item #2 or other default actions
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${items[index]['title']} feature coming soon',
                                ),
                              ),
                            );
                          }
                        } else {
                          // Navigate to item details for added items
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ItemDetailsScreen(
                                    title: items[index]['title'],
                                    description:
                                        items[index]['description'] ??
                                        'No description available',
                                  ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF5946E8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Clearfreight',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Shipping Management System',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard, color: Color(0xFF5946E8)),
              title: Text('Dashboard'),
              selected: true,
              selectedColor: Color(0xFF5946E8),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text('Item #1'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Item1Screen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text('Add New Item'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewItemScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods to generate random colors and icons for new items
  Color _getRandomColor() {
    List<Color> colors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.teal,
      Colors.amber,
      Colors.indigoAccent,
    ];
    return colors[DateTime.now().microsecond % colors.length];
  }

  IconData _getRandomIcon() {
    List<IconData> icons = [
      Icons.star,
      Icons.favorite,
      Icons.shopping_cart,
      Icons.work,
      Icons.description,
      Icons.category,
      Icons.assignment,
    ];
    return icons[DateTime.now().microsecond % icons.length];
  }
}
