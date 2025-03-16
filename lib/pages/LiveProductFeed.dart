import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

class LiveProductFeedPage extends StatelessWidget {
  const LiveProductFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
       title: Text("Live Product Feed"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
    
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('addedAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No products available."));
          }

          final products = snapshot.data!.docs;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final data = products[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(data['name']),
                  subtitle: Text("Price: \$${data['price']} | Quantity: ${data['quantity']}"),
                  trailing: data['addedAt'] != null
                      ? Text((data['addedAt'] as Timestamp)
                          .toDate()
                          .toLocal()
                          .toString()
                          .split(".")[0])
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
