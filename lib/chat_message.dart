import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isBot;

  const ChatMessage({
    super.key,
    required this.message,
    required this.isBot
  });
  final Radius borderRadius = const Radius.circular(15);
  @override
  Widget build(BuildContext context) {
    BorderRadius botBorders = BorderRadius.only(topLeft: borderRadius, topRight: borderRadius, bottomRight: borderRadius);
    BorderRadius userBorders = BorderRadius.only(topLeft: borderRadius, topRight: borderRadius, bottomLeft: borderRadius);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: !isBot?MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isBot?
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(right: 5),
            decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage('https://openai.com/content/images/2021/09/codex-og-image-color.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),
            ):const SizedBox(),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isBot?Colors.white:const Color.fromARGB(255, 75, 160, 130),
                border: Border.all(width: 1, color: const Color.fromARGB(20, 0, 0, 0)),
                borderRadius: isBot?botBorders:userBorders,
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(12, 0, 0, 0), blurRadius: 20)
                ]
              ),
              child: Text(message, style: TextStyle(color:isBot?Colors.black:Colors.white),),
            ),
            !isBot?
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(image: NetworkImage('https://avatars.githubusercontent.com/u/95091403?s=400&u=c34d9f11d35d1f3e49fb50657ae7b1e46ab5bf8b&v=4'), fit: BoxFit.cover)
              ),
            ):const SizedBox(),
        ],
      ),
    );
  }
}