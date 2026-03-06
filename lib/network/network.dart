import 'package:chat_app/env.dart';
import 'package:chat_app/network/Net.dart';
import 'package:fx_helper/network/fx_network.dart';

class Network extends FxNetwork<Net> {
  static final Network _instance = Network._internal();
  factory Network() => _instance;
  Network._internal();

  // String get xDate => Crypt().timestamp(DateTime.now());

  @override
  EnvModel get env => isDevMode ? EnvStaging() : EnvProduction();

  @override
  bool get isDevMode => true;

  /* Comment on release */
  @override
  bool get logShowFull => true;
  @override
  bool get logHideSensitiveInfo => false;
  @override
  bool get logInRelease => false;
  @override
  int get postDelayMs => 0;
  @override
  int get getDelayMs => 500;
  @override
  int get putDelayMs => 0;
  @override
  int get deleteDelayMs => 0;
  @override
  int get logTruncateAt => 100;

  @override
  Map<String, String> getHeader() {
    var h = {"Content-Type": "application/json"};
    if (token != null && token?.isNotEmpty == true) {
      h.addAll({"Authorization": "Bearer $token"});
    }
    print("header: $h");
    return h;
  }

  @override
  String getDomainName(Net net) {
    switch (net) {
      case Net.gateway:
        return env.baseUrlGateway;
    }
  }
}
