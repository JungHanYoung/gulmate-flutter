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
    } else if (event is CheckUpdatePurchase) {
      yield* _mapCheckPurchaseToState(event);
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
    if(state is PurchaseLoaded) {
      try {
        final purchaseList = await purchaseRepository.getPurchaseList();
        yield PurchaseLoaded(purchaseList);
      } catch(e) {
        yield PurchaseLoaded((state as PurchaseLoaded).purchaseList);
      }
    }
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
      } catch(e) {
        print(e);
        yield PurchaseLoaded((state as PurchaseLoaded).purchaseList);
      }
    }
  }

  Stream<PurchaseState> _mapUpdatePurchaseToState(UpdatePurchase event) async* {
    // TODO: 장보기 수정
    if(state is PurchaseLoaded) {
      try {
        final updatedId = await purchaseRepository.updatePurchase(event.purchase);
        final List<Purchase> updatedPurchaseList = (state as PurchaseLoaded).purchaseList.map((purchase) {
          return updatedId != purchase.id ? purchase : event.purchase.copyWith(
            creator: purchase.creator,
          );
        }).toList();

        yield PurchaseLoaded(updatedPurchaseList);
      } catch(_) {
        yield PurchaseLoaded((state as PurchaseLoaded).purchaseList);
      }
    }
  }

  Stream<PurchaseState> _mapDeletePurchaseToState(DeletePurchase event) async* {
    if(state is PurchaseLoaded) {
      await purchaseRepository.deletePurchase(event.purchase);
      final List<Purchase> updatedPurchaseList = (state as PurchaseLoaded)
      .purchaseList
      .where((item) => item.id != event.purchase.id)
      .toList();
      yield PurchaseLoaded(updatedPurchaseList);
    }
  }

  @override
  Future<Function> close() {
    _appTabSubscription.cancel();
    return super.close();
  }

  Stream<PurchaseState> _mapCheckPurchaseToState(CheckUpdatePurchase event) async* {
    if(state is PurchaseLoaded) {
      try {
        final updatedPurchase = await purchaseRepository.checkPurchase(event.purchase);
        final List<Purchase> updatedPurchaseList = (state as PurchaseLoaded).purchaseList.map((purchase) {
          return updatedPurchase.id != purchase.id ? purchase : updatedPurchase;
        }).toList();
        yield PurchaseLoaded(updatedPurchaseList);
      } catch(_) {
        print(_);
//        yield PurchaseLoaded((state as PurchaseLoaded).purchaseList);
      }
    }
  }
}
