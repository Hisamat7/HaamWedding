import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedweel/user/SearchDetailPage.dart';

class Searchpage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<Searchpage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<String> _suggestions = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  // Fetch suggestions dynamically as user types
  void _fetchSuggestions(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isEmpty) {
        setState(() => _suggestions = []);
        return;
      }

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('services')
            .orderBy('name')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThan: '$query\uf8ff')
            .limit(5)
            .get();

        setState(() {
          _suggestions =
              snapshot.docs.map((doc) => doc['name'] as String).toList();
        });
      } catch (e) {
        print("Error fetching suggestions: $e");
      }
    });
  }

  // Perform search when user submits query
  Future<void> _searchServices(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _suggestions = [];
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('services')
          .orderBy('name')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '$query\uf8ff')
          .get();

      setState(() {
        _searchResults = snapshot.docs
            .map((doc) => {
                  'id': doc.id, // Ensure ID is included
                  ...doc.data(),
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter Vendor name...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search, color: Colors.teal[600]),
              onPressed: () => _searchServices(_searchController.text.trim()),
            ),
          ),
          onChanged: (value) => _fetchSuggestions(value.trim()),
          onSubmitted: (value) => _searchServices(value.trim()),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            // Show suggestions dynamically
            if (_searchController.text.isNotEmpty && _suggestions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_suggestions[index]),
                    onTap: () {
                      _searchController.text = _suggestions[index];
                      _searchServices(_suggestions[index]);
                    },
                  );
                },
              ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _searchResults.isEmpty
                      ? Center(child: Text('No vendors found'))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final service = _searchResults[index];
                            final category =
                                service['category'] ?? 'Unknown Category';
                            final guestcount =
                                service['number_of_guests']?.toString() ??
                                    'N/A';

                            return ListTile(
                              leading: service['image'] != null &&
                                      service['image'].isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        service['image'],
                                        width: 70.w,
                                        height: 70.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.broken_image,
                                                    size: 50.w),
                                      ),
                                    )
                                  : Icon(Icons.image, size: 50.w),
                              title: Text(service['name'] ?? 'No Name',
                                  style: TextStyle(
                                    color: Colors.teal[700],
                                  )),
                              subtitle:
                                  Text(service['location'] ?? 'No location',
                                      style: TextStyle(
                                        color: Colors.teal[700],
                                      )),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Searchdetailpage(
                                      guestnumber: category == 'venue'
                                          ? guestcount
                                          : 'N/A',
                                      id: service['vendor_id'] ?? '',
                                      isVenueVendor: category == 'venue',
                                      location:
                                          service['location'] ?? 'No location',
                                      price: service['price'] ?? 0,
                                      vendordescription:
                                          service['description'] ?? '',
                                      vendorimage: service['image'] ?? '',
                                      vendorname: service['name'] ?? '',
                                      phonenumber:
                                          service['phone'] ?? 'No phone number',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
