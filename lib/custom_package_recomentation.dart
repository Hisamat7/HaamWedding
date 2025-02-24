import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedweel/user/profile/bookings/UserBookingScreen.dart';

class BestServiceScreen extends StatefulWidget {
  const BestServiceScreen({super.key});

  @override
  _BestServiceScreenState createState() => _BestServiceScreenState();
}

class _BestServiceScreenState extends State<BestServiceScreen> {
  final TextEditingController _venueController =
      TextEditingController(); // For number of people
  final TextEditingController _photoController = TextEditingController();
  final TextEditingController _makeupController = TextEditingController();
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _decorationController = TextEditingController();

  // Define the order of categories
  final List<String> categoryOrder = [
    'venue',
    'photo',
    'makeup',
    'food',
    'decoration'
  ];

  bool _isLoading = false; // Track loading state

  Future<Map<String, Map<String, dynamic>>> findBestPackages() async {
    Map<String, Map<String, dynamic>> bestPackages = {};

    // Fetch best packages for each category in the defined order
    for (var category in categoryOrder) {
      double budget = 0;
      switch (category) {
        case 'venue':
          // Venue is based on number of people, so skip budget filtering
          bestPackages[category] =
              await _fetchBestPackage(category, double.infinity);
          break;
        case 'photo':
          budget = double.tryParse(_photoController.text) ?? 0;
          bestPackages[category] = await _fetchBestPackage(category, budget);
          break;
        case 'makeup':
          budget = double.tryParse(_makeupController.text) ?? 0;
          bestPackages[category] = await _fetchBestPackage(category, budget);
          break;
        case 'food':
          budget = double.tryParse(_foodController.text) ?? 0;
          bestPackages[category] = await _fetchBestPackage(category, budget);
          break;
        case 'decoration':
          budget = double.tryParse(_decorationController.text) ?? 0;
          bestPackages[category] = await _fetchBestPackage(category, budget);
          break;
      }
    }

    return bestPackages;
  }

  Future<Map<String, dynamic>> _fetchBestPackage(
      String category, double budget) async {
    var services = await FirebaseFirestore.instance
        .collection('services')
        .where('category', isEqualTo: category)
        .where('price', isLessThanOrEqualTo: budget.toString())
        .get();

    Map<String, dynamic>? bestService;
    double highestRating = 0;

    for (var service in services.docs) {
      var data = service.data();
      var vendorDoc = await FirebaseFirestore.instance
          .collection('vendor')
          .doc(data['vendor_id'])
          .get();
      if (vendorDoc.exists && vendorDoc.data()?['IsAdminApproved'] == true) {
        var reviewsSnapshot = await FirebaseFirestore.instance
            .collection('reviews')
            .where('vendorId', isEqualTo: data['vendor_id'])
            .get();

        double avgRating = reviewsSnapshot.docs.isNotEmpty
            ? reviewsSnapshot.docs
                    .map((r) => r['rating'] as num)
                    .reduce((a, b) => a + b) /
                reviewsSnapshot.docs.length
            : 0;

        if (avgRating > highestRating) {
          highestRating = avgRating;
          bestService = {...data, 'avgRating': avgRating};
        }
      }
    }

    // If no package matches the budget, return an empty map
    return bestService ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Custom package",
          style: TextStyle(color: Colors.teal[700]),
        ),
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Venue (Number of People)
            Text("Venue",
                style: TextStyle(fontSize: 18, color: Colors.teal[800])),
            const SizedBox(height: 10),
            TextField(
              controller: _venueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "number of people",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 2, 122, 108)),
                    borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 101, 255, 181)),
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(height: 10),

            // Photo Budget
            Text("photography",
                style: TextStyle(fontSize: 18, color: Colors.teal[800])),
            const SizedBox(height: 10),
            TextField(
              controller: _photoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your budget",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 2, 122, 108)),
                    borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 101, 255, 181)),
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(height: 10),

            // Makeup Budget
            Text("Makeup",
                style: TextStyle(fontSize: 18, color: Colors.teal[800])),
            const SizedBox(height: 10),
            TextField(
              controller: _makeupController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your budget",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 2, 122, 108)),
                    borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 101, 255, 181)),
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(height: 10),

            // Food Budget
            Text("Food",
                style: TextStyle(fontSize: 18, color: Colors.teal[800])),
            const SizedBox(height: 10),
            TextField(
              controller: _foodController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your budget",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 2, 122, 108)),
                    borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 101, 255, 181)),
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(height: 10),

            // Decoration Budget
            Text("Decoration",
                style: TextStyle(fontSize: 18, color: Colors.teal[800])),
            const SizedBox(height: 10),
            TextField(
              controller: _decorationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter your budget",
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 2, 122, 108)),
                    borderRadius: BorderRadius.circular(6)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: const Color.fromARGB(255, 101, 255, 181)),
                    borderRadius: BorderRadius.circular(6)),
              ),
            ),
            const SizedBox(height: 30),

            // Find Best Packages Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 139, 222, 212),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    )),
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true; // Show loading indicator
                        });

                        var bestPackages = await findBestPackages();

                        setState(() {
                          _isLoading = false; // Hide loading indicator
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BestPackageResultPage(
                                bestPackages: bestPackages),
                          ),
                        );
                      },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        "Find Best Packages",
                        style: TextStyle(color: Colors.teal[700]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BestPackageResultPage extends StatelessWidget {
  final Map<String, Map<String, dynamic>> bestPackages;

  const BestPackageResultPage({super.key, required this.bestPackages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Best Packages",
            style: TextStyle(color: Colors.teal[800], fontSize: 18)),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: bestPackages.length,
        itemBuilder: (context, index) {
          String category = bestPackages.keys.elementAt(index);
          Map<String, dynamic> package = bestPackages[category] ?? {};

          // If no package is found for the category, show a message
          if (package.isEmpty) {
            return Card(
              color: const Color.fromARGB(255, 233, 252, 248),
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text("No package available for your price in $category",
                    style: const TextStyle(color: Colors.red)),
              ),
            );
          }

          // Display the package details
          String name = package['name'];
          double price = double.tryParse(package['price'].toString()) ?? 0.0;
          double? avgRating = package['avgRating']?.toDouble();
          String imageUrl =
              package['image'] ?? "https://via.placeholder.com/50";

          return Card(
            color: const Color.fromARGB(255, 233, 252, 248),
            elevation: 5,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(imageUrl,
                    width: 50, height: 50, fit: BoxFit.cover),
              ),
              title: Text(name,
                  style: TextStyle(fontSize: 16, color: Colors.teal[700])),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Price: ₹$price",
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 1, 77, 68))),
                    Text(
                        "Rating: ${avgRating != null ? avgRating.toStringAsFixed(1) : 'No rating'} ⭐",
                        style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 0, 71, 63))),
                  ],
                ),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 208, 255, 250),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserBookingScreen(
                                vendorId: package['vendor_id'],
                              )));
                },
                child: Text("Book",
                    style: TextStyle(
                      color: Colors.teal[700],
                    )),
              ),
            ),
          );
        },
      ),
    );
  }
}
