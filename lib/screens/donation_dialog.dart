// donation_dialog.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DonationDialog {
  final BuildContext context;
  final FirebaseFirestore firestore;
  final Function(Map<String, String>) onDonationSuccess;

  DonationDialog({
    required this.context,
    required this.firestore,
    required this.onDonationSuccess,
  });

  void showDonationDialog(Map<String, dynamic> fundraiser) {
    TextEditingController amountController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController(); // New controller for phone number

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
                controller: phoneController, // New TextField for phone number
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Enter your phone number", border: OutlineInputBorder()),
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
              SizedBox(height: 10),
              // Add a TextButton to show needy student info
              TextButton(
                onPressed: () {
                  _showNeedyStudentInfo();
                },
                child: Text(
                  "Learn about the needy student",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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
                String donorPhone = phoneController.text.trim(); // Get phone number
                if (amount.isNotEmpty && donorName.isNotEmpty && donorPhone.isNotEmpty) {
                  // Update the raised amount in the fundraiser
                  int donationAmount = int.tryParse(amount) ?? 0;
                  int currentRaised = fundraiser["raised"];
                  fundraiser["raised"] = currentRaised + donationAmount;

                  // Save to Firestore
                  await firestore.collection('donations').add({
                    'name': donorName,
                    'phone': donorPhone, // Save phone number
                    'amount': amount,
                    'date': DateTime.now(),
                    'fundraiser': fundraiser["name"],
                    'paymentMethod': 'bKash', // Add payment method
                  });

                  // Notify the parent widget about the donation
                  onDonationSuccess({
                    "name": donorName,
                    "phone": donorPhone, // Include phone number in the success callback
                    "amount": amount,
                    "date": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
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
    final String bkashPaymentUrl = "https://payment.bkash.com/?paymentId=TR0011RaS4u8Y1741058931452&hash=((t.AyMbyJ(9jfaW0LCy0PTSFzlBt-w6ZLXmoJy6YP3tUuCLhj_BB3zZeYOrN0oX*HwpGWMh3IaJG9SxeqxVVNtq.Ha-KjKuTk)91741058931452&mode=0011&apiVersion=v1.2.0-beta/";

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

  // Method to show needy student info
  void _showNeedyStudentInfo() async {
    try {
      // Fetch the needy student data from Firestore
      QuerySnapshot querySnapshot = await firestore.collection('needy_students').limit(1).get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No needy student data found.")),
        );
        return;
      }

      // Get the first document (you can modify this logic to fetch a specific student)
      var studentData = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Display the data in a dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("About the Needy Student"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${studentData["name"]}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text("ID: ${studentData["id"]}"),
                Text("Department: ${studentData["department"]}"),
                Text("Faculty: ${studentData["faculty"]}"),
                SizedBox(height: 10),
                Text(
                  "Background:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  studentData["background"] ?? "No background information available.",
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch student data: ${e.toString()}")),
      );
    }
  }
}