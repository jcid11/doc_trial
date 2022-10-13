import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChatBloc with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sentMessage(
      {required TextEditingController chat,
        required String receiverEmail,
        required String senderEmail}) async {
    String docId=DateTime.now().microsecondsSinceEpoch.toString();
    await _firestore
        .collection('User')
        .doc(senderEmail)
        .collection('messages')
        .add({
      "chatWith": receiverEmail,
      "message": chat.text,
      "date": DateTime.now().microsecondsSinceEpoch,
      "senderEmail": senderEmail,
      "receiverEmail": receiverEmail,
      "chatId":"",
      "isDeleted":false
    }).then((value)async{

      _firestore
          .collection('User')
          .doc(senderEmail)
          .collection('messages').doc(value.id).update({'chatId':value.id});

      await _firestore
          .collection('User')
          .doc(receiverEmail)
          .collection('messages').
      doc(value.id)
          .set({
        "chatWith": senderEmail,
        "message": chat.text,
        "date": DateTime.now().microsecondsSinceEpoch,
        "senderEmail": senderEmail,
        "receiverEmail": receiverEmail,
        "chatId":"",
        "isDeleted":false
      });
    });


  }

  Future<void> deleteMessage(String senderEmail,String docId,String receiverEmail)async {
    _firestore.collection('User')
        .doc(senderEmail)
        .collection('messages').doc(docId).update({'isDeleted':true});
    _firestore.collection('User')
        .doc(receiverEmail)
        .collection('messages').doc(docId).update({'isDeleted':true});
  }
}
