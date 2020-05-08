import 'package:equatable/equatable.dart';

abstract class FamilyEvent extends Equatable {
  const FamilyEvent();

  @override
  List<Object> get props => [];
}

class LoadFamily extends FamilyEvent {}

class CreateFamily extends FamilyEvent {
  final String familyName;

  const CreateFamily(this.familyName);

  @override
  List<Object> get props => [familyName];

  @override
  String toString() {
    return 'createFamily{familyName: $familyName}';
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

class WithdrawFamily extends FamilyEvent {

  const WithdrawFamily();

  @override
  String toString() {
    return 'WithdrawFamily{}';
  }
}

class UpdateMemberInfo extends FamilyEvent {
  final String nickname;

  const UpdateMemberInfo(this.nickname);

  @override
  List<Object> get props => [nickname];

  @override
  String toString() {
    return 'UpdateMemberInfo{nickname: $nickname}';
  }
}

class UploadFamilyPhoto extends FamilyEvent {

  const UploadFamilyPhoto();

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'UploadFamilyPhoto{}';
  }
}

