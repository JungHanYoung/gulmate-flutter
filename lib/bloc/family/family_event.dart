import 'package:equatable/equatable.dart';
import 'package:gulmate/model/family_type.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object> get props => [];
}

class LoadFamily extends FamilyEvent {}

class CreateFamily extends FamilyEvent {
  final String familyName;
  final FamilyType familyType;

  const CreateFamily(this.familyName, this.familyType);

  @override
  List<Object> get props => [familyName, familyType];

  @override
  String toString() {
    return 'createFamily{familyName: $familyName, familyType: $familyType}';
  }
}

class JoinFamily extends FamilyEvent {
  final String inviteKey;

  const JoinFamily(this.inviteKey);

  @override
  List<Object> get props => [inviteKey];

  @override
  String toString() {
    return 'JoinFamily{inviteKey: $inviteKey}';
  }
}