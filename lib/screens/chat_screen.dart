import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_trial/bloc/chat_bloc.dart';
import 'package:doc_trial/models/chat_model.dart';
import 'package:doc_trial/utils/chat_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/user_bloc.dart';
import '../models/screen_argument_model.dart';

class ChatScreen extends StatefulWidget {
  final ScreenArguments screenArguments;

  const ChatScreen({Key? key, required this.screenArguments}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String name;
  late String email;

  TextEditingController chat = TextEditingController();

  @override
  void initState() {
    name = widget.screenArguments.args as String;
    email = widget.screenArguments.additionalArgs as String;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RawMaterialButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              constraints: const BoxConstraints(minWidth: 0),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('User')
                  .doc(context
                  .read<UserBloc>()
                  .userEmail)
                  .collection('messages')
                  .where('chatWith', isEqualTo: email)
                  .orderBy('date',descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('No messages has been sent yet');
                }
                final messages = snapshot.data!.docs;
                List<ChatModel> chatList = [];
                for (var message in messages) {
                  final chat = message.get('message');
                  final receiverEmail = message.get('receiverEmail');
                  final chatID = message.get('chatId');
                  final isDeleted = message.get('isDeleted');
                  chatList.add(ChatModel(
                      message: chat,
                      receiverEmail: receiverEmail,
                      chatId: chatID,
                      isDeleted: isDeleted));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: chatList.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      //TODO to fix yet
                      if (chatList[index].receiverEmail ==
                          context
                              .read<UserBloc>()
                              .userEmail &&
                          !chatList[index].isDeleted) {
                        return receivedMessage(chatList[index].message);
                      } else if (chatList[index].receiverEmail ==
                          context
                              .read<UserBloc>()
                              .userEmail &&
                          chatList[index].isDeleted) {
                        return receivedMessage('Message has been deleted');
                      } else if (chatList[index].receiverEmail !=
                          context
                              .read<UserBloc>()
                              .userEmail &&
                          chatList[index].isDeleted) {
                        return sentMessage('Message has been deleted', () {});
                      }
                      return sentMessage(chatList[index].message, () {
                        showDialog<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return ChatDialog(
                                userEmail: context
                                    .read<UserBloc>()
                                    .userEmail,
                                chatId: chatList[index].chatId,
                                receiverEmail: email,
                              );
                            });
                      });
                    },
                  ),
                );
              },
            ),
            chatRow(context: context, chat: chat, email: email),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Widget chatRow({required BuildContext context,
  required TextEditingController chat,
  required String email}) {
  return Row(
    children: [
      const SizedBox(
        width: 10,
      ),
      Expanded(
        child: TextField(
          controller: chat,
          decoration: InputDecoration(
            fillColor: Colors.grey.withOpacity(0.5),
            filled: true,
            hintText: 'Mensaje',
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      RawMaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          constraints: const BoxConstraints(minWidth: 0),
          onPressed: () =>
              context
                  .read<ChatBloc>()
                  .sentMessage(
                  chat: chat,
                  receiverEmail: email,
                  senderEmail: context
                      .read<UserBloc>()
                      .userEmail)
                  .then((value) {
                chat.clear();
              }),
          child: const Icon((Icons.send))),
      const SizedBox(
        width: 10,
      ),
    ],
  );
}

Widget receivedMessage(String messageReceive) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: Wrap(
      children: [
        const SizedBox(
          width: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              messageReceive,
              maxLines: 3,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}

Widget sentMessage(String messageSent, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3.0),
    child: Wrap(
      alignment: WrapAlignment.end,
      children: [
        const SizedBox(
          width: 10,
        ),
        RawMaterialButton(
          onPressed: onPressed,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          constraints: const BoxConstraints(minWidth: 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue.withOpacity(0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                messageSent,
                maxLines: 3,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
