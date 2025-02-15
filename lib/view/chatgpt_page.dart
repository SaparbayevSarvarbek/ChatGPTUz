import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:chatgptuz/services/api_service.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatgptPage extends StatefulWidget {
  const ChatgptPage({super.key});

  @override
  State<ChatgptPage> createState() => _ChatgptPageState();
}

class _ChatgptPageState extends State<ChatgptPage> {
  static const _token="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";
  final _openAI=OpenAI.instance.build(token: _token,baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),enableLog: true );
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Sarvarbek', lastName: 'Saparbayev');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');
  List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text(
          'GPT chat',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DashChat(
          currentUser: _currentUser,
          messageOptions:
              const MessageOptions(currentUserContainerColor: Colors.black,
              containerColor: Color.fromRGBO(0, 166, 126, 1),),
          onSend: (ChatMessage m) {
            getChatResponse(m);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });
    List<Messages> messagesHistory=_messages.reversed.map((m){
      if(m.user==_currentUser){
        return Messages(role: Role.user,content: m.text);
      }else{
        return Messages(role: Role.assistant,content: m.text);
      }
    }).toList();
    final request=ChatCompleteText(model: GptTurbo0301ChatModel(), messages: messagesHistory,maxToken: 500);
  }
}