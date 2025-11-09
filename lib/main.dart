// Firestore + Flutter demo app
// Modified by Simba Z for CIS 3334 - Firestore Item List

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore List',
      theme: ThemeData(colorSchemeSeed: const Color(0xFF2962FF)),
      home: const ItemListApp(),
    );
  }
}

class ItemListApp extends StatefulWidget {
  const ItemListApp({super.key});

  @override
  State<ItemListApp> createState() => _ItemListAppState();
}

class _ItemListAppState extends State<ItemListApp> {
  // Text field controller for capturing the new item name
  final TextEditingController _newItemTextField = TextEditingController();

  // Firestore collection reference used instead of a local list
  // (Originally started with a local list in Phase 1.)
  late final CollectionReference<Map<String, dynamic>> items;

  @override
  void initState() {
    super.initState();
    // Point to the ITEMS collection in Firestore
    items = FirebaseFirestore.instance.collection('ITEMS');
  }

  // Add a new item from the text field into Firestore
  void _addItem() {
    final newItem = _newItemTextField.text.trim();
    if (newItem.isEmpty) return;
    setState(() {
      items.add({
        'item_name': newItem,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _newItemTextField.clear();
    });
  }

  // Delete a document in Firestore by its document ID
  void _removeItemAt(String id) {
    setState(() {
      items.doc(id).delete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firestore List Demo')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            // ---- Input area for creating a new item ----
            NewItemWidget(),
            // Small vertical space between input and list below
            const SizedBox(height: 24),
            Expanded(
              // ---- Main list of items (from Firestore stream) ----
              child: ItemListWidget(),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a list of items by listening to live Firestore updates
  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> ItemListWidget() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: items.snapshots(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap,
      ) {
        if (snap.hasError) {
          return Text('Firebase Snapshot Error: ${snap.error}');
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        if (snap.data == null || snap.data!.docs.isEmpty) {
          return const Text('No Items Yet...');
        }
        return ListView.builder(
          itemCount: snap.data!.docs.length,
          itemBuilder: (context, i) {
            final doc = snap.data!.docs[i];
            final String itemId = doc.id;
            final String itemName = (doc.data()['item_name']);
            return Dismissible(
              key: ValueKey(itemId),
              background: Container(color: Colors.red),
              onDismissed: (_) => _removeItemAt(itemId),
              // ---- Individual list tile for a single item ----
              child: ListTile(
                leading: const Icon(Icons.check_box),
                title: Text(itemName),
                onTap: () => _removeItemAt(itemId),
              ),
            );
          },
        );
      },
    );
  }

  // Row widget that contains the text field and "Add" button
  Widget NewItemWidget() {
    return Row(
      children: [
        // Text input for the new item label
        Expanded(
          child: TextField(
            controller: _newItemTextField,
            onSubmitted: (_) => _addItem(),
            decoration: const InputDecoration(
              labelText: 'New Item Name',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Small gap between text field and button
        const SizedBox(width: 12),
        // Button that triggers adding the item to Firestore
        FilledButton(onPressed: _addItem, child: const Text('Add')),
      ],
    );
  }
}
