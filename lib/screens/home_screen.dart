import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HSTU DigiFund"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          carouselSlider(),
          const SizedBox(height: 20),

          sectionTitle("Featured Fundraiser"),
          featuredFundraiser(),
          const SizedBox(height: 20),

          sectionTitle("Fundraiser Categories"),
          categoryList(),
          const SizedBox(height: 20),

          sectionTitle("Ongoing Fundraisers"),
          fundraiserList(),
          const SizedBox(height: 20),

          sectionTitle("Recent Donations"),
          recentDonations(),
        ],
      ),
      drawer: appDrawer(context),
      bottomNavigationBar: bottomNavBar(),
    );
  }

  Widget sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

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

  Widget categoryList() {
    return SizedBox(
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
    );
  }

  Widget categoryCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget fundraiserList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) => fundraiserCard(),
    );
  }

  Widget fundraiserCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on, color: Colors.teal),
        title: const Text("Student Medical Aid"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Raised: \$500 / Goal: \$1000"),
            const SizedBox(height: 5),
            const LinearProgressIndicator(value: 0.5, color: Colors.teal),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Donate"),
        ),
      ),
    );
  }

  Widget featuredFundraiser() {
    return Card(
      color: Colors.amber,
      child: ListTile(
        title: const Text("Urgent Medical Assistance Needed", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Help a student with emergency surgery!"),
        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text("Support Now"),
        ),
      ),
    );
  }

  Widget recentDonations() {
    return Column(
      children: const [
        ListTile(
          leading: Icon(Icons.person, color: Colors.teal),
          title: Text("Samaun Islam \$50"),
          subtitle: Text("2 hours ago"),
        ),
        ListTile(
          leading: Icon(Icons.person, color: Colors.teal),
          title: Text("Hasnain \$30"),
          subtitle: Text("5 hours ago"),
        ),
      ],
    );
  }

  Widget appDrawer(BuildContext context) {
    return Drawer(
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
              child: const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavBar() {
    return BottomAppBar(
      color: Colors.teal,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
