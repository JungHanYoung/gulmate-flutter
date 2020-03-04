import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'account.dart';

class Message extends Equatable {

  final String message;
  final Account creator;

  const Message({
    @required this.message,
    this.creator
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        message: json['message'],
        creator: Account.fromJson(json['creator']),
    );
  }

  @override
  List<Object> get props => [message, creator];

}