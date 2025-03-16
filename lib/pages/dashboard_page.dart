import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/user_provider.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Provider.of<UserProvider>(context, listen: false).setUser(null);
              context.go('/');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome ${user?.email ?? 'User'}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/add-product'),
              child: Text("Add Product"),
            ),
            ElevatedButton(
              onPressed: () => context.go('/products'),
              child: Text("Update Products"),
            ),
            ElevatedButton(
              onPressed: () => context.go('/live-feed'),
              child: Text("Live Product Feed"),
            ),
          ],
        ),
      ),
    );
  }
}
