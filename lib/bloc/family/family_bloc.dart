import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/family/family_event.dart';
import 'package:gulmate/bloc/family/family_state.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view_bloc.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view_event.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/repository/family_repository.dart';


class FamilyBloc extends Bloc<FamilyEvent, FamilyState> {
  FamilyRepository _familyRepository;
  final AuthenticationBloc authenticationBloc;
  final CheckInviteViewBloc checkInviteViewBloc;
  StreamSubscription authSubscription;

  FamilyBloc({
    @required this.authenticationBloc,
    @required this.checkInviteViewBloc,
  })  : assert(authenticationBloc != null),
        assert(checkInviteViewBloc != null) {
    _familyRepository = GetIt.instance.get<FamilyRepository>();
    authSubscription = authenticationBloc.listen((state) {
      if (state is AuthenticationAuthenticatedWithoutFamily) {
        add(LoadFamily());
      }
    });
  }

  @override
  // TODO: implement initialState
  FamilyState get initialState => FamilyLoading();

  @override
  Stream<FamilyState> mapEventToState(FamilyEvent event) async* {
    if (event is LoadFamily) {
      yield* _mapLoadFamilyToState(event);
    } else if (event is CreateFamily) {
      yield* _mapCreateFamilyToState(event);
    } else if (event is JoinFamily) {
      yield* _mapJoinFamilyToState(event);
    }
  }

  Stream<FamilyState> _mapLoadFamilyToState(LoadFamily event) async* {
    try {
      yield FamilyLoading();
      final Family family =
          await _familyRepository.getMyFamily();
      authenticationBloc.add(WithFamily(family));
      yield FamilyLoaded(family);
    } catch (_) {
      yield FamilyNotLoaded();
    }
  }

  @override
  Future<Function> close() {
    authSubscription.cancel();
    return super.close();
  }

  Stream<FamilyState> _mapCreateFamilyToState(CreateFamily event) async* {
    try {
      yield FamilyLoading();
      final Family family = await _familyRepository.createFamily(
          event.familyName, event.familyType);
//      authenticationBloc.add(WithFamily(family));
      checkInviteViewBloc
          .add(UpdateCheckInviteView(CheckInviteViewState.welcome));
      yield FamilyLoaded(family);
    } catch (e) {
      yield FamilyNotLoaded();
    }
  }

  Stream<FamilyState> _mapJoinFamilyToState(JoinFamily event) async* {
    try {
      yield FamilyLoading();
      final Family family = await _familyRepository.joinFamily(event.inviteKey);
      authenticationBloc.add(WithFamily(family));
      yield FamilyLoaded(family);
    } catch(e) {
      yield FamilyNotLoaded();
    }
  }
}
