import 'package:bloc/bloc.dart';
import 'package:gulmate/bloc/purchase/purchase_event.dart';
import 'package:gulmate/bloc/purchase/purchase_state.dart';
import 'package:gulmate/repository/purchase_repository.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final PurchaseRepository purchaseRepository;


  PurchaseBloc(this.purchaseRepository);

  @override
  PurchaseState get initialState => PurchaseLoading();

  @override
  Stream<PurchaseState> mapEventToState(PurchaseEvent event) async* {
    if(event is FetchPurchaseList) {
      yield* _mapFetchPurchaseListToState();
    } else if(event is RefreshPurchaseList) {
      yield* _mapRefreshPurchaseListToState();
    } else if(event is AddPurchase) {
      yield* _mapAddPurchaseToState(event);
    } else if(event is UpdatePurchase) {
      yield* _mapUpdatePurchaseToState(event);
    } else if(event is DeletePurchase) {
      yield* _mapDeletePurchaseToState(event);
    }
  }

  Stream<PurchaseState> _mapFetchPurchaseListToState() async* {
    // TODO: 장보기 목록 가져오기
    yield PurchaseLoading();
    try {
      final purchaseList = await purchaseRepository.getPurchaseList();
      yield PurchaseLoaded(purchaseList);
    } catch(e) {
      yield PurchaseError();
    }
  }

  Stream<PurchaseState> _mapRefreshPurchaseListToState() async* {
    // TODO: 장보기 목록 새로고침
  }

  Stream<PurchaseState> _mapAddPurchaseToState(AddPurchase event) async* {
    // TODO: 장보기 추가
  }

  Stream<PurchaseState> _mapUpdatePurchaseToState(UpdatePurchase event) async* {
    // TODO: 장보기 수정
  }

  Stream<PurchaseState> _mapDeletePurchaseToState(DeletePurchase event) async* {
    // TODO: 장보기 삭제
  }

}