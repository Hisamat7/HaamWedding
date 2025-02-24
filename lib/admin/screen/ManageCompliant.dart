import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the timestamp

class AdminComplaintsPage extends StatelessWidget {
  const AdminComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text('All Complaints',
            style: TextStyle(color: Color.fromARGB(255, 4, 72, 61))),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('timestamp',
                descending: true) // Order by timestamp (newest first)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No complaints found.'));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint =
                  complaints[index].data() as Map<String, dynamic>;
              final userName = complaint['userName'] ?? 'Anonymous';
              final userId = complaint['userId'] ?? 'Unknown User';
              final complaintText =
                  complaint['complaint'] ?? 'No complaint text';
              final timestamp = complaint['timestamp'] as Timestamp?;

              // Format the timestamp
              final formattedDate = timestamp != null
                  ? DateFormat('dd MMM yyyy, hh:mm a')
                      .format(timestamp.toDate())
                  : 'No date';

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name and ID
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Complaint Text
                      Text(
                        complaintText,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Timestamp
                      Text(
                        'Submitted on: $formattedDate',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
