import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  Stream<QuerySnapshot> getProductsStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .orderBy('addedAt', descending: true)
        .snapshots();
  }

  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (newQuantity < 0) return;

    await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .set({
          'quantity': newQuantity,
        }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Products"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No products found."));
          }

          final productDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: productDocs.length,
            itemBuilder: (context, index) {
              final doc = productDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              final productId = doc.id;
              final name = data['name'] ?? 'Unnamed';
              final price = data['price'] ?? 0.0;
              final quantity = data['quantity'] ?? 0;
              final timestamp = data['addedAt'] as Timestamp?;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: \$${price.toStringAsFixed(2)}"),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("Qty: "),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => updateQuantity(productId, quantity - 1),
                          ),
                          Text(quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => updateQuantity(productId, quantity + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: timestamp != null
                      ? Text(
                          timestamp.toDate().toLocal().toString().split(".")[0],
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
