import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/family/family_event.dart';
import 'package:gulmate/bloc/family/family_state.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view_bloc.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view_event.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/repository/family_repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


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
  FamilyState get initialState => FamilyLoading();

  @override
  Stream<FamilyState> mapEventToState(FamilyEvent event) async* {
    if (event is LoadFamily) {
      yield* _mapLoadFamilyToState(event);
    } else if (event is CreateFamily) {
      yield* _mapCreateFamilyToState(event);
    } else if (event is JoinFamily) {
      yield* _mapJoinFamilyToState(event);
    } else if (event is WithdrawFamily) {
      yield* _mapWithdrawFamilyToState(event);
    } else if (event is UpdateMemberInfo) {
      yield* _mapUpdateMemberInfoToState(event);
    } else if (event is UploadFamilyPhoto) {
      yield* _mapUploadFamilyPhotoToState(event);
    }
  }

  Stream<FamilyState> _mapLoadFamilyToState(LoadFamily event) async* {
    try {
      yield FamilyLoading();
      final Family family =
          await _familyRepository.getMyFamily();
      final currentAccount = (authenticationBloc.state as AuthenticationAuthenticatedWithoutFamily).currentAccount;
      currentAccount.nickname = family.accountList.firstWhere((el) => el.id == currentAccount.id).nickname;
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
          event.familyName);
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

  Stream<FamilyState> _mapWithdrawFamilyToState(WithdrawFamily event) async* {
    try {
      await _familyRepository.withdrawFamily();
      authenticationBloc.add(WithoutFamily());
      checkInviteViewBloc.add(UpdateCheckInviteView(CheckInviteViewState.selectBetween));
    } catch(e) {
      yield FamilyNotLoaded();
    }
  }

  Stream<FamilyState> _mapUpdateMemberInfoToState(UpdateMemberInfo event) async* {
    try {
      final currentAccount = (authenticationBloc.state as AuthenticationAuthenticatedWithFamily).currentAccount;
      final currentFamily = (authenticationBloc.state as AuthenticationAuthenticatedWithFamily).currentFamily;
      await _familyRepository.modifyMemberInfo(event.nickname);
      currentAccount.nickname = event.nickname;
      final updatedFamily = currentFamily.copyWith(accountList: currentFamily.accountList.map((el) => el.id == currentAccount.id ? currentAccount.copyWith(nickname: event.nickname) : el).toList());
      authenticationBloc.add(WithFamily(updatedFamily));
      yield FamilyLoaded(updatedFamily);
    } catch(e) {
      print(e);
    }
  }

  Stream<FamilyState> _mapUploadFamilyPhotoToState(UploadFamilyPhoto event) async* {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if(imageFile != null) {
      final croppedImageFile = await ImageCropper.cropImage(sourcePath: imageFile.path, aspectRatio: CropAspectRatio(ratioX: 2, ratioY: 1));
      if(croppedImageFile != null) {
        try {
          final formData = FormData.fromMap({
            'file': MultipartFile.fromFileSync(croppedImageFile.path, filename: imageFile.path.split("/").last),
          });
          final imageUrl = await _familyRepository.uploadFamilyPhoto(formData);
          final updatedFamily = (authenticationBloc.state as AuthenticationAuthenticatedWithFamily).currentFamily.copyWith(familyPhotoUrl: imageUrl);
          authenticationBloc.add(WithFamily(updatedFamily));
          yield FamilyLoaded(updatedFamily);
        } catch(e) {
          print(e);
        }

      }
    }
  }
}
