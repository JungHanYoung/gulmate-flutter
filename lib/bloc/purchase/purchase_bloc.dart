import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/repository/purchase_repository.dart';

import '../blocs.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseRepository _purchaseRepository;
  final AppTabBloc appTabBloc;
  final AuthenticationBloc authBloc;
  StreamSubscription _appTabSubscription;

  PurchaseBloc({
    @required this.appTabBloc,
    @required this.authBloc,
  }) {
    _purchaseRepository = GetIt.instance.get<PurchaseRepository>();
    _appTabSubscription = appTabBloc.listen((state) {
      if (state == AppTab.purchase && !(state is PurchaseLoaded)) {
        add(FetchPurchaseList());
      }
    });
  }

  @override
  PurchaseState get initialState => PurchaseLoading();


  @override
  void onError(Object error, StackTrace stacktrace) {
    if(error is DioError) {
      print(error.response.statusCode);
    }
  }

  @override
  Stream<PurchaseState> mapEventToState(PurchaseEvent event) async* {
    if (event is FetchPurchaseList) {
      yield* _mapFetchPurchaseListToState();
    } else if (event is RefreshPurchaseList) {
      yield* _mapRefreshPurchaseListToState(event);
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
    yield PurchaseLoading();
    try {
      final purchaseList = await _purchaseRepository.getPurchaseList();
      yield PurchaseLoaded(purchaseList);
    } catch (e) {
      yield PurchaseError(e.toString());
    }
  }

  Stream<PurchaseState> _mapRefreshPurchaseListToState(RefreshPurchaseList event) async* {
    if(state is PurchaseLoaded) {
      try {
        final purchaseList = await _purchaseRepository.getPurchaseList();
        event.completer.complete();
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
        final purchase = await _purchaseRepository.createPurchase(
          event.title,
          event.place,
          event.deadline,
        );
        final List<Purchase> updatedPurchaseList = List.from((state as PurchaseLoaded).purchaseList)
          ..insert(0, purchase);
        yield PurchaseLoaded(updatedPurchaseList);
      } on DioError catch(e) {
        if(e.response.statusCode == 403) {

        }
      } catch(e) {
        print(e);
        yield PurchaseLoaded((state as PurchaseLoaded).purchaseList);
      }
    }
  }

  Stream<PurchaseState> _mapUpdatePurchaseToState(UpdatePurchase event) async* {
    if(state is PurchaseLoaded) {
      try {
        final updatedId = await _purchaseRepository.updatePurchase(event.purchase);
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
      await _purchaseRepository.deletePurchase(event.purchase);
      final List<Purchase> updatedPurchaseList = (state as PurchaseLoaded)
      .purchaseList
      .where((item) => item.id != event.purchase.id)
      .toList();
      yield PurchaseLoaded(updatedPurchaseList);
    }
  }

  @override
  Future<void> close() {
    _appTabSubscription.cancel();
    return super.close();
  }

  Stream<PurchaseState> _mapCheckPurchaseToState(CheckUpdatePurchase event) async* {
    if(state is PurchaseLoaded) {
      try {
        final updatedPurchase = await _purchaseRepository.checkPurchase(event.purchase);
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
