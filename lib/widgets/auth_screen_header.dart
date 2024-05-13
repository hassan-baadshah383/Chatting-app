import 'package:flutter/material.dart';

class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(top: 100),
      height: 60,
      width: 150,
      child: const Center(
        child: Text(
          'Auth Screen',
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
    );
  }
}
