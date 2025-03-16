import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class AddProductPage extends StatelessWidget {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();

  Future<void> _addProduct(BuildContext context) async {
    final user = Provider.of<UserProvider>(context, listen: false).user;

    final name = _name.text.trim();
    final price = double.tryParse(_price.text.trim());
    final qty = int.tryParse(_quantity.text.trim());

    if (name.isEmpty || price == null || qty == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid input")));
      return;
    }

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'price': price,
      'quantity': qty,
      'userId': user!.uid,
      'addedAt': FieldValue.serverTimestamp(),
    });

    _name.clear();
    _price.clear();
    _quantity.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product added")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Products"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: 'Name')),
            TextField(controller: _price, decoration: InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextField(controller: _quantity, decoration: InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            ElevatedButton(onPressed: () => _addProduct(context), child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
