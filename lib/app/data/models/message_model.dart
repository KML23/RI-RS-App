enum ChatSender { user, ai, nurse, system }

class ChatMessage {
  final String text;
  final ChatSender sender;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.sender,
    required this.time,
  });
}