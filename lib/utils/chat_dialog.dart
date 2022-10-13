import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/chat_bloc.dart';

class ChatDialog extends StatelessWidget {
  final String userEmail;
  final String chatId;
  final String receiverEmail;

  const ChatDialog(
      {super.key,
      required this.userEmail,
      required this.chatId,
      required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: SizedBox(
        height: 108,
        child: Column(
          children: [
            TextButton(
              onPressed: () => Provider.of<ChatBloc>(context, listen: false)
                  .deleteMessage(userEmail, chatId, receiverEmail)
                  .then((value) => Navigator.pop(context)),
              style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Eliminar mensaje'),
            ),
            TextButton(
              onPressed: () {},
              style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Editar mensaje'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
