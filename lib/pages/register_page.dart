import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/user_provider.dart';

class RegisterPage extends StatelessWidget {
  final _email = TextEditingController();
  final _password = TextEditingController();

  Future<void> _register(BuildContext context) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      final user = userCredential.user;
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Provider.of<UserProvider>(context, listen: false).setUser(user);
      context.go('/dashboard');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [   
            TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            ElevatedButton(onPressed: () => _register(context), child: Text("Register")),
          ],
        ),
      ),
    );
  }
}
