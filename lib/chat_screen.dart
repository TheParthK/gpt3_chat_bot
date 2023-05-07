import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _controller = TextEditingController();
  // final List<ChatMessage> _messages= [];
  final List<Widget> _messages= [];
  ChatGPT? chatGPT;

  StreamSubscription? _subscription;
  bool isTyping = false;

  _launchGitHubProfile() async {
  var url = Uri.parse("https://github.com/TheParthK");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  void initState() {
    super.initState();
    // chatGPT = ChatGPT.instance.builder('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', orgId: '');
  }

  @override
  void dispose() {
    chatGPT!.close();
    _subscription?.cancel();
    super.dispose();
  }
  void sendMessage(){
    chatGPT = ChatGPT.instance.builder('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', orgId: '');
    String message =  _controller.text.trim();
    _controller.clear(); 
    if(message.isNotEmpty){
      setState(() {
        _messages.add(ChatMessage(message: message, isBot: false));
        isTyping = true;
      });
    final request = CompleteReq(
      prompt: message,
      model: kTranslateModelV3,
      max_tokens: 200,
      );
    _subscription = chatGPT!
    .onCompleteStream(request: request)
    .listen((response) {
      ChatMessage botResponse = ChatMessage(message: response!.choices[0].text.trimLeft().trimRight(), isBot: true);
      // ignore: avoid_print 
      print(botResponse.message);
      setState(() {
        isTyping = false;
        _messages.add(botResponse);
      });
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: const Color.fromARGB(255, 250, 250, 250),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  color: const Color.fromARGB(255, 250, 250, 250),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(image: NetworkImage('https://openai.com/content/images/2021/09/codex-og-image-color.png'), fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          boxShadow: [
                            BoxShadow(color: Color.fromARGB(5, 0, 0, 0), blurRadius: 20)
                          ]
                        ),
                      ),
                      const SizedBox(width: 12,),
                      const Text('Chat GPT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      const SizedBox(width: 10,),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 10, 141, 119),
                          color: Color.fromARGB(255, 8, 186, 79),
                          borderRadius: BorderRadius.all(Radius.circular(2))
                          
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: _launchGitHubProfile,
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: Row(
                            children: const [
                            Expanded(child: SizedBox()),
                            Text('GitHub', style: TextStyle(fontSize: 13),),
                            SizedBox(width: 2,),
                            Icon(CupertinoIcons.arrow_up_right, size: 12,)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1.2,
                  color: const Color.fromARGB(16, 0, 0, 0),
                  width: double.infinity,
                ),
                // here 
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return (_messages[_messages.length - index - 1]).animate();
                      },
                      ),
                  )
                ),

                isTyping?Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 30,
                        width: 1.56 * 30,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage('https://support.signal.org/hc/article_attachments/360016877511/typing-animation-3x.gif'),
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                    ),
                  ],
                ):const SizedBox(),

                Container(
                  height: 1.2,
                  color: const Color.fromARGB(16, 0, 0, 0),
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      border: Border.all(width: 0.5, color: const Color.fromARGB(255, 237, 237, 237)),
                      boxShadow: const [
                        BoxShadow(color: Color.fromARGB(5, 0, 0, 0), blurRadius: 20)
                      ]
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Container(
                            // height: 60,
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
                            width: double.infinity,
                            color: Colors.transparent,
                            child: Center(
                              child: TextField(
                                controller: _controller,
                                autocorrect: true,
                                cursorColor: Colors.black,
                                maxLengthEnforcement: MaxLengthEnforcement.none,
                                onSubmitted: (value) => sendMessage(),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 7,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Ask ChatGPT ...'
                                ),
                              ),
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            color: const Color.fromARGB(255, 244, 244, 244),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              splashColor: Colors.transparent,
                              highlightColor: const Color.fromARGB(8, 0, 0, 0),
                              onTap: () {
                                sendMessage();
                              },
                              child: const SizedBox(
                                height: 60 - 16,
                                width: 60 - 16,
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromARGB(255, 11, 11, 11),
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
