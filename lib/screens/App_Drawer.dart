import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade700, Colors.teal.shade300],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.volunteer_activism,
                      size: 50,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "HSTU DigiFund",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // App Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "About HSTU DigiFund",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "HSTU DigiFund is a platform for students to raise funds for medical, educational, and other urgent needs. Join us in making a difference!",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Website Link
            _buildDrawerItem(
              icon: Icons.language,
              title: "Visit Our Website",
              onTap: () async {
                const url = "https://hstu.ac.bd/"; //
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not launch website")),
                  );
                }
              },
            ),

            // Email Contact
            _buildDrawerItem(
              icon: Icons.email,
              title: "Email Us",
              onTap: () async {
                const email = "samaunislamsis0000@gmail.com";
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: email,
                );
                if (await canLaunch(emailUri.toString())) {
                  await launch(emailUri.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not launch email")),
                  );
                }
              },
            ),

            // Phone Contact
            _buildDrawerItem(
              icon: Icons.phone,
              title: "Call Us",
              onTap: () async {
                const phoneNumber = "01701399755";
                final Uri phoneUri = Uri(
                  scheme: 'tel',
                  path: phoneNumber,
                );
                if (await canLaunch(phoneUri.toString())) {
                  await launch(phoneUri.toString());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Could not launch phone call")),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      onTap: onTap,
    );
  }
}