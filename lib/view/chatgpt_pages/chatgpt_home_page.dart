import 'package:chatgptuz/view/chatgpt_pages/chat_page.dart';
import 'package:chatgptuz/view/chatgpt_pages/conversation_provider.dart';
import 'package:chatgptuz/view/chatgpt_pages/drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatgptHomePage extends StatelessWidget {
  const ChatgptHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<ConversationProvider>(context, listen: true)
              .currentConversationTitle,
          style: const TextStyle(
            fontSize: 20.0,
            color: Colors.black,
            fontFamily: 'din-regular',
          ),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        // remove box shadow
        toolbarHeight: 50,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: "rename",
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Rename'),
                ),
              ),
              const PopupMenuItem(
                value: "refresh",
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text('Refresh'),
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
            ],
            elevation: 2,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            onSelected: (value) {
              if (value == "rename") {
                // rename
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String newName = '';
                    return AlertDialog(
                      title: const Text('Rename Conversation'),
                      content: TextField(
                        // display the current name of the conversation
                        decoration: InputDecoration(
                          hintText: Provider.of<ConversationProvider>(context,
                                  listen: false)
                              .currentConversation
                              .title,
                        ),
                        onChanged: (value) {
                          newName = value;
                        },
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: const Text(
                            'Rename',
                            style: TextStyle(
                              color: Color(0xff55bb8e),
                            ),
                          ),
                          onPressed: () {
                            // Call renameConversation method here with the new name
                            Provider.of<ConversationProvider>(context,
                                    listen: false)
                                .renameConversation(newName);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );

                // Provider.of<ConversationProvider>(context, listen: false)
                //     .renameCurrentConversation();
              } else if (value == "delete") {
                // delete
                Provider.of<ConversationProvider>(context, listen: false)
                    .removeCurrentConversation();
              } else if (value == "refresh") {
                // refresh
                Provider.of<ConversationProvider>(context, listen: false)
                    .clearCurrentConversation();
              }
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: const Center(
        child: ChatPage(),
      ),
    );
  }
}
