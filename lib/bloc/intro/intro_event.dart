import 'package:equatable/equatable.dart';

import 'intro_bloc.dart';

abstract class IntroEvent extends Equatable {

  const IntroEvent();

  @override
  List<Object> get props => [];
}

class IntroUpdateEvent extends IntroEvent {
  final IntroState intro;

  const IntroUpdateEvent(this.intro);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'IntroUpdateEvent{intro: $intro}';
  }


}