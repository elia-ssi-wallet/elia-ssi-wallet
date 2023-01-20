import 'package:elia_ssi_wallet/database/database.dart';
import 'package:elia_ssi_wallet/repositories/exchange_repository.dart';
import 'package:mobx/mobx.dart';

part 'pending_screen_viewmodel.g.dart';

class PendingScreenViewModel extends _PendingScreenViewModel with _$PendingScreenViewModel {}

abstract class _PendingScreenViewModel with Store {
  @observable
  ObservableStream<List<PendingRequest>> pendingRequests = ExchangeRepository.pendingRequestDao.requestsStream().asObservable();
}
