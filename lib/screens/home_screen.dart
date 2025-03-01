import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import at the top
import 'profile_screen.dart';
import 'App_Drawer.dart';
import 'donation_request_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Declare Firestore instance here
  String selectedCategory = "All";

  final List<Map<String, dynamic>> fundraisers = [
    {"name": "Medical Aid for John", "category": "Medical", "raised": 700, "goal": 2000},
    {"name": "Help for Education", "category": "Education", "raised": 1200, "goal": 3000},
    {"name": "Sports Club Fund", "category": "Sports", "raised": 800, "goal": 1500},
    {"name": "Local School Support", "category": "Education", "raised": 3000, "goal": 5000},
    {"name": "Heart Surgery Support", "category": "Medical", "raised": 1500, "goal": 5000},
  ];

  List<String> categories = ["All", "Medical", "Education", "Clubs", "Sports", "Others"];
  List<Map<String, String>> recentDonationsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HSTU DigiFund"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      drawer: AppDrawer(),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.shade100, // Lighter teal for a softer look
              Colors.white, // Keep white at the bottom for contrast
            ],
            stops: [0.3, 0.7], // Adjust the stops for smoother transitions
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            carouselSlider(),
            SizedBox(height: 20),
            Text("Featured Emergency Fundraiser", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            featuredEmergencyFundraiser(),
            SizedBox(height: 20),
            Text("Fundraiser Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            categorySelector(),
            SizedBox(height: 20),
            Text("Ongoing Fundraisers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ongoingFundraisers(),
            SizedBox(height: 20),
            Text("Recent Donations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            recentDonations(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.list, color: Colors.white),
              onPressed: () {
                // Navigate to the DonationRequestPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonationRequestPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget carouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9, // Slightly shrink the images for a nice effect
      ),
      items: [
        // Add your image assets here
        Image.asset('assets/Images/h1.jpg', fit: BoxFit.cover),
        Image.asset('assets/Images/h2.jpg', fit: BoxFit.cover),
        Image.asset('assets/Images/h3.jpg', fit: BoxFit.cover),
      ].map((image) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Subtle shadow
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16), // Clip image with rounded corners
                child: image, // Display each image here
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget featuredEmergencyFundraiser() {
    int raised = 5000; // Example raised amount
    int goal = 10000; // Example goal amount
    bool isCompleted = raised >= goal; // Check if the goal is met or exceeded

    return Card(
      elevation: 4, // Add shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
      color: Colors.redAccent,
      child: ListTile(
        title: Text("Emergency: Help for Flood Victims", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Raised: \$$raised / Goal: \$$goal", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: raised / goal, // Progress value (raised / goal)
              backgroundColor: Colors.white.withOpacity(0.3), // Background color of the progress bar
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Progress bar color
            ),
            if (isCompleted) // Show completion status if the goal is met
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green, // Green background for completion status
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, color: Colors.white, size: 16), // Tick mark icon
                    SizedBox(width: 4),
                    Text("Completed", style: TextStyle(color: Colors.white)), // "Completed" text
                  ],
                ),
              ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            showDonationDialog({"name": "Help for Flood Victims", "raised": raised, "goal": goal});
          },
          child: Text("Donate"),
        ),
      ),
    );
  }
  Widget categorySelector() {
    return Wrap(
      spacing: 8.0,
      children: categories.map((category) {
        return ChoiceChip(
          label: Text(category),
          selected: selectedCategory == category,
          onSelected: (selected) {
            setState(() {
              selectedCategory = category;
            });
          },
          selectedColor: Colors.teal, // Teal color for selected chip
          labelStyle: TextStyle(color: selectedCategory == category ? Colors.white : Colors.black),
        );
      }).toList(),
    );
  }

  Widget ongoingFundraisers() {
    return Column(
      children: fundraisers.where((fundraiser) => selectedCategory == "All" || fundraiser["category"] == selectedCategory).map((fundraiser) {
        int raised = fundraiser["raised"];
        int goal = fundraiser["goal"];
        bool isCompleted = raised >= goal;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(fundraiser["name"]),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Raised: \$$raised / Goal: \$$goal"),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: raised / goal,
                  backgroundColor: Colors.teal.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
                if (isCompleted)
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Text("Completed", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                showDonationDialog(fundraiser);
              },
              child: Text("Donate"),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget recentDonations() {
    return Column(
      children: recentDonationsList.isEmpty
          ? [Text("No recent donations yet", style: TextStyle(color: Colors.grey))]
          : recentDonationsList.map((donation) {
        return Card(
          elevation: 2, // Add shadow
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Rounded corners
          child: ListTile(
            leading: Icon(Icons.person, color: Colors.teal),
            title: Text("${donation["name"]} donated \$${donation["amount"]}"),
            subtitle: Text(donation["date"] ?? ""),
          ),
        );
      }).toList(),
    );
  }

  void showDonationDialog(Map<String, dynamic> fundraiser) {
    TextEditingController amountController = TextEditingController();
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Donate to ${fundraiser["name"]}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Raised: \$${fundraiser["raised"]} / Goal: \$${fundraiser["goal"]}"),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Enter your name", border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Enter donation amount", border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Simulate bKash payment process
                  _processBkashPayment(amountController.text.trim());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // bKash brand color
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.payment, color: Colors.white),
                    SizedBox(width: 10),
                    Text("Pay with bKash", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                String amount = amountController.text.trim();
                String donorName = nameController.text.trim();
                if (amount.isNotEmpty && donorName.isNotEmpty) {
                  // Update the raised amount in the fundraiser
                  int donationAmount = int.tryParse(amount) ?? 0;
                  int currentRaised = fundraiser["raised"];
                  fundraiser["raised"] = currentRaised + donationAmount;

                  // Save to Firestore
                  await _firestore.collection('donations').add({
                    'name': donorName,
                    'amount': amount,
                    'date': DateTime.now(),
                    'fundraiser': fundraiser["name"],
                    'paymentMethod': 'bKash', // Add payment method
                  });

                  // Update the local state
                  setState(() {
                    recentDonationsList.insert(0, {
                      "name": donorName,
                      "amount": amount,
                      "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    });
                  });

                  Navigator.pop(context);
                }
              },
              child: Text("Donate"),
            ),
          ],
        );
      },
    );
  }

  void _processBkashPayment(String amount) async {
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter an amount to proceed with bKash payment.")),
      );
      return;
    }

    // Official bKash payment link
    final String bkashPaymentUrl = "https://bka.sh/next";

    try {
      // Use url_launcher to open the bKash payment URL
      if (await canLaunch(bkashPaymentUrl)) {
        await launch(bkashPaymentUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open bKash. Please make sure the app is installed or try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred: ${e.toString()}")),
      );
    }
  }
}