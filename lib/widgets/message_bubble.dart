import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, this.isMe, this.username, this.imageUrl,
      {super.key});
  final String message;
  final bool isMe;
  final String username;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 150,
              constraints: const BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: !isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(20),
                      bottomRight: isMe
                          ? const Radius.circular(0)
                          : const Radius.circular(20)),
                  color: !isMe
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.secondary),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe ? Colors.black : Colors.white),
                  ),
                  Text(
                    message,
                    style:
                        TextStyle(color: !isMe ? Colors.white : Colors.black),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: isMe ? 145 : null,
              left: isMe ? null : 145,
              child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
            ),
          ],
        ),
      ],
    );
  }
}
