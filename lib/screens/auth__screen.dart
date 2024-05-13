import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth_screen_header.dart';
import '../widgets/auth_screen_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;

  void submitAuthForm(String name, String email, String password, bool isLogin,
      File? image, BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });
    UserCredential authResult;
    try {
      if (isLogin) {
        authResult = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('userImages')
            .child('${authResult.user!.uid}.jpg');
        await ref.putFile(image!);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'name': name, 'email': email, 'imageUrl': url});
      }
    } on FirebaseAuthException catch (err) {
      var message = 'Invalid credentials. Please enter valid credentials.';
      if (err.message != null) {
        message = err.message.toString();
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).colorScheme.error,
      ));
    } catch (err) {
      //print(err);
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondary,
              Theme.of(context).primaryColor,
              Colors.brown
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AuthScreenHeader(),
              AuthScreenForm(submitAuthForm, isLoading),
            ],
          ),
        ),
      ),
    );
  }
}
