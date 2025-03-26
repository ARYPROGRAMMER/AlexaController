import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../common/widgets/Elevated_Button/basic_elevated_button.dart';
import '../../../core/configs/constants/app_urls.dart';
import '../../../routes/app_router_constants.dart';

final box = Hive.box('authBox');

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "my Wonder",
        style: TextStyle(
          color: Colors.orange.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            _buildHighlightedProductSection(),
            _buildTrendingBuddiesSection(),
            _buildActivitySection(),
            _buildPromotionalSection(),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: 0.5,
                      offset: Offset(0, 4),
                      color: Color(0xfffEC34E),
                    ),
                  ],
                ),
                child: ElevatedBtn(
                    text: "Signout",
                    onPressed: () async {
                      await signOut();
                      context.goNamed(MyAppRouteConstants.getNumber);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    // final _dio = Dio();

    if (box.get('log') == '0') {
      print("No user token found. Cannot sign out.");
      return;
    }

    try {
      // final response = await _dio.post(
      //   AppUrls.supabaseUrl!,
      //   options: Options(
      //     headers: {
      //       'apikey': AppUrls.supabaseKey,
      //       'Content-Type': 'application/json',
      //       'Authorization': 'Bearer $userToken',
      //     },
      //   ),
      // );
      //
      // if (response.statusCode == 200 ||
      //     response.statusCode == 204 ||
      //     response.statusCode == 404) {
      box.put('log', '0');
      // } else {
      //   print("Failed to sign out: ${response.data}");
      // }
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }

  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Hi, Arya",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Avenir",
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Welcome to your Wonder experience!",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Avenir",
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHighlightedProductSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Meet kid's favourite",
                  style: TextStyle(
                    color: Colors.black54,
                    fontFamily: "Avenir",
                    fontSize: 16,
                  ),
                ),
                const Text(
                  "Ninja Dadi",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Buy Now"),
                ),
              ],
            ),
          ),
          Image.asset(
            "assets/images/ninja_dadi.png",
            height: 150,
            width: 150,
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingBuddiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Trending Buddies",
          style: TextStyle(
            fontSize: 22,
            fontFamily: "Avenir",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Arya loves to listen to stories, and these buddies would become his great friend",
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 20),
        _buildTrendingBuddyCard(),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("View All"),
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingBuddyCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.asset(
              "assets/images/christmas_santa.png",
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 10),
            const Text(
              "Santa: Christmas Special",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Avenir",
                fontSize: 18,
              ),
            ),
            const Text(
              "Music & Sound",
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "Avenir",
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "₹320 20% OFF!",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_circle_fill),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Activity",
          style: TextStyle(
            fontSize: 22,
            fontFamily: "Avenir",
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "10hr spent this week",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Avenir",
                    fontSize: 18,
                  ),
                ),
                const Text(
                  "↑ 25% more than last week",
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(height: 10),
                const Text("What are Arya's interests?"),
                const SizedBox(height: 10),
                _buildInterestProgressBars(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInterestProgressBars() {
    return Column(
      children: [
        _buildProgressRow("Science", Colors.purple, 7),
        _buildProgressRow("Space", Colors.blue, 3),
        _buildProgressRow("Plants", Colors.green, 2),
        _buildProgressRow("Animals", Colors.orange, 1),
      ],
    );
  }

  Widget _buildProgressRow(String label, Color color, int hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Avenir",
              )),
          const SizedBox(width: 10),
          Expanded(
            child: LinearProgressIndicator(
              value: hours / 10,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          const SizedBox(width: 10),
          Text('${hours}h',
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Avenir",
              )),
        ],
      ),
    );
  }

  Widget _buildPromotionalSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(height: 10),
                Text(
                  "Explore Wonder World",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            padding: const EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 15,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "Shop Now",
            style: TextStyle(
              fontSize: 18,
              fontFamily: "Avenir",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_basket),
          label: 'Shop',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
