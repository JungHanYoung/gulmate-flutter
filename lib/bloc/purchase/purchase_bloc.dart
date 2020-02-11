import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gulmate/bloc/purchase/purchase_event.dart';
import 'package:gulmate/bloc/purchase/purchase_state.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/repository/purchase_repository.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository purchaseRepository;
  final AppTabBloc appTabBloc;
  StreamSubscription _appTabSubscription;

  PurchaseBloc(
    this.purchaseRepository, {
    @required this.appTabBloc,
  }) {
    _appTabSubscription = appTabBloc.listen((state) {
      if (state == AppTab.purchase) {
        add(FetchPurchaseList());
      }
    });
  }

  @override
  PurchaseState get initialState => PurchaseLoading();

  @override
  Stream<PurchaseState> mapEventToState(PurchaseEvent event) async* {
    if (event is FetchPurchaseList) {
      yield* _mapFetchPurchaseListToState();
    } else if (event is RefreshPurchaseList) {
      yield* _mapRefreshPurchaseListToState();
    } else if (event is AddPurchase) {
      yield* _mapAddPurchaseToState(event);
    } else if (event is UpdatePurchase) {
      yield* _mapUpdatePurchaseToState(event);
    } else if (event is DeletePurchase) {
      yield* _mapDeletePurchaseToState(event);
    }
  }

  Stream<PurchaseState> _mapFetchPurchaseListToState() async* {
    // TODO: 장보기 목록 가져오기
    yield PurchaseLoading();
    try {
      final purchaseList = await purchaseRepository.getPurchaseList();
      yield PurchaseLoaded(purchaseList);
    } catch (e) {
      yield PurchaseError(e.toString());
    }
  }

  Stream<PurchaseState> _mapRefreshPurchaseListToState() async* {
    // TODO: 장보기 목록 새로고침
  }

  Stream<PurchaseState> _mapAddPurchaseToState(AddPurchase event) async* {
    if(state is PurchaseLoaded) {
      try {
        final state = this.state;
        final purchase = await purchaseRepository.createPurchase(
          event.title,
          event.place,
          event.deadline,
        );
        final List<Purchase> updatedPurchaseList = List.from((state as PurchaseLoaded).purchaseList)
          ..insert(0, purchase);
        yield PurchaseLoaded(updatedPurchaseList);
      }catch(e) {
        yield PurchaseLoaded((state as PurchaseLoaded).purchaseList);
      }
    }
  }

  Stream<PurchaseState> _mapUpdatePurchaseToState(UpdatePurchase event) async* {
    // TODO: 장보기 수정
  }

  Stream<PurchaseState> _mapDeletePurchaseToState(DeletePurchase event) async* {
    // TODO: 장보기 삭제
  }

  @override
  Future<Function> close() {
    _appTabSubscription.cancel();
    return super.close();
  }
}
