
class ChatModel{
  final String message;
  final String receiverEmail;
  final String chatId;
  final bool isDeleted;

  ChatModel({required this.message, required this.receiverEmail, required this.chatId,required this.isDeleted});
}