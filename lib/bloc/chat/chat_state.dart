import 'package:equatable/equatable.dart';
import 'package:gulmate/model/message.dart';

abstract class ChatState extends Equatable {

  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Message> messageList;

  const ChatLoaded(this.messageList);

  @override
  List<Object> get props => [messageList];

}