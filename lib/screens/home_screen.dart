import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HSTU DigiFund"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView( // Replace the body with a ListView to make it scrollable
        padding: const EdgeInsets.all(16.0),
        children: [
          // Carousel Slider
          carouselSlider(),
          SizedBox(height: 20),

          Text("Featured Fundraiser", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          featuredFundraiser(),
          SizedBox(height: 20),

          Text("Fundraiser Categories", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryCard("Education", Icons.school),
                categoryCard("Medical", Icons.local_hospital),
                categoryCard("Emergency", Icons.warning),
                categoryCard("Clubs", Icons.groups),
                categoryCard("Sports", Icons.sports_soccer),
              ],
            ),
          ),
          SizedBox(height: 20),

          Text("Ongoing Fundraisers", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true, // Ensures it takes only the needed space
            physics: NeverScrollableScrollPhysics(), // Disable scrolling here
            itemCount: 3,
            itemBuilder: (context, index) => fundraiserCard(),
          ),
          SizedBox(height: 20),

          Text("Recent Donations", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          recentDonations(),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.favorite),
      //   backgroundColor: Colors.teal,
      // ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Log Out'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        shape: CircularNotchedRectangle(), // Optional: Adds a floating effect
        notchMargin: 6.0, // Space around the notch
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Navigate to Home
              },
            ),
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                // Navigate to Requests
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigate to Profile
              },
            ),
          ],
        ),
      ),

    );
  }

  // Carousel Slider Widget
  Widget carouselSlider() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        enableInfiniteScroll: true,
      ),
      items: [
        "assets/Images/h1.jpg",
        "assets/Images/h2.jpg",
        "assets/Images/h3.jpg",
      ].map((imagePath) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
        );
      }).toList(),
    );
  }

  Widget categoryCard(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          SizedBox(height: 5),
          Text(title, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget fundraiserCard() {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on, color: Colors.teal),
        title: Text("Student Medical Aid"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Raised: \$500 / Goal: \$1000"),
            SizedBox(height: 5),
            LinearProgressIndicator(value: 0.5, color: Colors.teal),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("Donate"),
        ),
      ),
    );
  }

  Widget featuredFundraiser() {
    return Card(
      color: Colors.amber,
      child: ListTile(
        title: Text("Urgent Medical Assistance Needed", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Help a student with emergency surgery!"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: Text("Support Now"),
        ),
      ),
    );
  }

  Widget recentDonations() {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.person, color: Colors.teal),
          title: Text("Samaun Islam \$50"),
          subtitle: Text("2 hours ago"),
        ),
        ListTile(
          leading: Icon(Icons.person, color: Colors.teal),
          title: Text("Hasnain  \$30"),
          subtitle: Text("5 hours ago"),
        ),
      ],
    );
  }
}
