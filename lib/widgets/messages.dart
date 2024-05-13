import 'package:flutter/material.dart';

import 'message_bubble.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  Future<User?> get getCurrentUser async {
    final id = FirebaseAuth.instance.currentUser;
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCurrentUser,
      builder: (context, futureSnapshot) {
        if (futureSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chats/Rkl7f6fwAnSFFidkpFnG/messages')
                .orderBy('sentAt', descending: true)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'No any message yet.',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final snapDocs = snapshot.data!.docs;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemBuilder: (context, index) {
                  return MessageBubble(
                    snapDocs[index]['text'],
                    snapDocs[index]['uId'] == futureSnapshot.data!.uid,
                    snapDocs[index]['username'],
                    snapDocs[index]['imageUrl'],
                    key: ValueKey(snapDocs[index].id),
                  );
                },
                itemCount: snapDocs.length,
              );
            });
      },
    );
  }
}
