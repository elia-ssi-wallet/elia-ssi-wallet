import 'package:elia_ssi_wallet/base/globals.dart';
import 'package:elia_ssi_wallet/database/dao/connections_dao.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

part 'qr_code_scanner_viewmodel.g.dart';

class QrCodeScannerViewModel extends _QrCodeScannerViewModel with _$QrCodeScannerViewModel {}

abstract class _QrCodeScannerViewModel with Store {
  @observable
  MobileScannerController mobileScannerController = MobileScannerController();

  @observable
  ConnectionsDao dao = ConnectionsDao(database);

  @observable
  ObservableList connections = ObservableList();

  _QrCodeScannerViewModel() {
    getConnections();
  }

  getConnections() async {
    connections = (await dao.getConnections()).map((e) => e.name).toList().asObservable();
  }
}
