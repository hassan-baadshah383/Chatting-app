import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/messages.dart';
import '../widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Let's Chat",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 36, 37),
          centerTitle: true,
          actions: [
            DropdownButton(
                icon: Icon(Icons.more_vert,
                    color: Theme.of(context).primaryIconTheme.color),
                items: const [
                  DropdownMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        Text('Logout')
                      ],
                    ),
                  )
                ],
                onChanged: (item) {
                  if (item == 'logout') {
                    FirebaseAuth.instance.signOut();
                  }
                })
          ],
        ),
        body: Container(
          color: const Color.fromARGB(255, 118, 68, 131),
          // decoration: BoxDecoration(gradient: LinearGradient(colors: [])),
          child: const Column(
            children: [
              Expanded(child: Messages()),
              NewMessage(),
            ],
          ),
        ));
  }
}
