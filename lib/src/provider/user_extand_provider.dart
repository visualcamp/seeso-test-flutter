import 'package:flutter/widgets.dart';

class UserExtandProvider with ChangeNotifier {
  bool isExtand = false;

  void changeIsExtand() {
    isExtand = !isExtand;
    notifyListeners();
  }
}
