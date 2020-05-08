import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {

  const ChatEvent();

  @override
  List<Object> get props => [];

}

class FetchChatMessage extends ChatEvent {}

class SendChatMessage extends ChatEvent {
  final String message;

  const SendChatMessage(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() {
    return 'SendChatMessage{message: $message}';
  }
}

class ReceiveChatMessage extends ChatEvent {
  final int messageId;
  final String message;
  final int accountId;

  ReceiveChatMessage(this.message, this.messageId, this.accountId);

  factory ReceiveChatMessage.fromJson(Map<String, dynamic> json) {
    return ReceiveChatMessage(json['message'], json['id'], json['accountId']);
  }

  @override
  List<Object> get props => [message, accountId, messageId];

  @override
  String toString() {
    return 'ReceiveChatMessage{message: $message, accountId: $accountId}';
  }


}