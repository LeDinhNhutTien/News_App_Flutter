import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class ChatGptScreen extends StatefulWidget {
  const ChatGptScreen({super.key});

  @override
  State<ChatGptScreen> createState() => _ChatGptScreenState();
}

class _ChatGptScreenState extends State<ChatGptScreen> {

  final _openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5,
    ),
    ),
      enableLog: true,
  );

  final ChatUser _currentUser = ChatUser(
      id: '1', firstName: "Tien", lastName: "Le");
  final ChatUser _gptChatUser = ChatUser(
      id: '2', firstName: "Chat", lastName: "GPT");

  final List<ChatMessage> _message = <ChatMessage>[];
  final List<ChatUser> _tyingUsers = <ChatUser>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 166, 126, 1),
        title: const Text("My ChatGPT",
          style: TextStyle(
              color: Colors.white
          ),),
      ),
      body: DashChat(
          currentUser: _currentUser,
          typingUsers: _tyingUsers,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black,
            containerColor: Color.fromRGBO(0, 166, 126, 1),
            textColor: Colors.white,
          ),
          onSend: (ChatMessage m) {
            getChatResponse(m);
      }, messages: _message)
      ,
    );
  }
  Future<void> getChatResponse(ChatMessage m) async {
    setState(() {
      _message.insert(0, m);
      _tyingUsers.add(_gptChatUser);
    });
    List<Messages> _messagesHistory = _message.reversed.map((m){
      if(m.user == _currentUser){
        return Messages(role: Role.user, content: m.text);
      }else{
        return Messages(role: Role.assistant, content: m.text);
      }
    }).toList();
    final request = ChatCompleteText(model: GptTurbo0301ChatModel(),
        messages: _messagesHistory,
        maxToken: 200,
    );
    final response = await _openAI.onChatCompletion(request: request);
    for(var element in response!.choices){
      if(element.message != null){
        setState(() {
          _message.insert(0,
              ChatMessage(
                  user: _gptChatUser,
                  createdAt: DateTime.now(),
                  text: element.message!.content));
        });
      }
    }
    setState(() {
      _tyingUsers.remove(_gptChatUser);
    });
  }
}