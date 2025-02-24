import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class TodosHome extends StatefulWidget {
  const TodosHome({super.key});

  @override
  State<TodosHome> createState() => _TodoshomeState();
}

class _TodoshomeState extends State<TodosHome> {
  TextEditingController addController = TextEditingController();
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  // Add task to Firestore
  Future<void> _addTask() async {
    if (addController.text.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        await _todosCollection.add({
          'title': addController.text,
          'isCompleted': false,
          'createdAt': Timestamp.now(),
          'userId': userId, // Add the userId field
        });
        addController.clear();
      }
    }
  }

  // Update task completion status
  Future<void> _toggleComplete(String docId, bool newValue) async {
    await _todosCollection.doc(docId).update({'isCompleted': newValue});
  }

  // Delete task from Firestore
  Future<void> _deleteTask(String docId) async {
    await _todosCollection.doc(docId).delete();
  }

  // Edit task title in Firestore
  Future<void> _editTask(String docId, String newTitle) async {
    if (newTitle.isNotEmpty) {
      await _todosCollection.doc(docId).update({'title': newTitle});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 225, 255, 235),
        title: Text("TO-DO LIST"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDialog,
        backgroundColor: const Color.fromARGB(255, 200, 254, 217),
        child: Icon(
          Icons.add,
          color: Colors.teal[900],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _todosCollection
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid) // Filter by userId
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No tasks found"));
          }

          final todos = snapshot.data!.docs;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return listContainer(
                docId: todo.id,
                title: todo['title'],
                isComplete: todo['isCompleted'],
                onChanged: (value) => _toggleComplete(todo.id, value!),
                onTap: () => _editDialog(todo.id, todo['title']),
              );
            },
          );
        },
      ),
    );
  }

  // Add task dialog
  Future<void> _addDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50],
          content: TextField(
            controller: addController,
            decoration: InputDecoration(
              hintText: "Add new task",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.teal)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.teal[300]!)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color.fromARGB(255, 255, 110, 110),
              ),
            ),
            TextButton(
              onPressed: () {
                _addTask();
                Navigator.of(context).pop();
              },
              child: Text("Save", style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color.fromARGB(255, 2, 120, 108),
              ),
            ),
          ],
        );
      },
    );
  }

  // Edit task dialog
  Future<void> _editDialog(String docId, String currentTitle) async {
    TextEditingController editController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50],
          content: TextField(
            controller: editController,
            decoration: InputDecoration(
              hintText: "Edit task",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.teal)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7),
                  borderSide: BorderSide(color: Colors.teal[300]!)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color.fromARGB(255, 255, 110, 110),
              ),
            ),
            TextButton(
              onPressed: () {
                _editTask(docId, editController.text);
                Navigator.of(context).pop();
              },
              child: Text("Save", style: TextStyle(color: Colors.white)),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                backgroundColor: const Color.fromARGB(255, 2, 120, 108),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget listContainer({
    required String docId,
    required String title,
    required bool isComplete,
    required Function(bool?) onChanged,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete_outline_outlined,
              label: "Delete",
              onPressed: (context) => _deleteTask(docId),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 183, 236, 209),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Checkbox(
                  fillColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 7, 169, 148)),
                  checkColor: Colors.teal[100],
                  value: isComplete,
                  onChanged: onChanged,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: isComplete
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}