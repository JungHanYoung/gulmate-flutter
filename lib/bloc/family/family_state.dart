import 'package:equatable/equatable.dart';
import 'package:gulmate/model/family.dart';

abstract class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object> get props => [];
}

class FamilyUninitialized extends FamilyState {}

class FamilyLoading extends FamilyState {}

class FamilyLoaded extends FamilyState {
  final Family family;

  const FamilyLoaded(this.family);

  @override
  List<Object> get props => [family];

  @override
  String toString() {
    return 'FamilyLoaded{family: $family}';
  }
}

class FamilyNotLoaded extends FamilyState {}