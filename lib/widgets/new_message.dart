import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var message = '';
  final _controller = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    final id = FirebaseAuth.instance.currentUser!.uid;
    final user =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    FirebaseFirestore.instance
        .collection('chats/Rkl7f6fwAnSFFidkpFnG/messages')
        .add({
      'text': message,
      'sentAt': Timestamp.now(),
      'uId': id,
      'username': user['name'],
      'imageUrl': user['imageUrl']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  hintText: 'Send a Message...',
                  hintStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                setState(() {
                  message = value;
                });
              },
            ),
          ),
          IconButton(
              onPressed: message.trim().isEmpty ? null : sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
