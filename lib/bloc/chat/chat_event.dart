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
  String message;
  int accountId;

  ReceiveChatMessage(Map<String, dynamic> json) {
    this.message = json['message'];
    this.accountId = json['accountId'];
  }

  @override
  List<Object> get props => [message, accountId];

  @override
  String toString() {
    return 'ReceiveChatMessage{message: $message, accountId: $accountId}';
  }


}