import 'package:flutter/widgets.dart';

class UserExtendProvider with ChangeNotifier {
  bool isExtend = false;

  void changeIsExtend() {
    isExtend = !isExtend;
    notifyListeners();
  }
}
