import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateChanged =
    ChangeNotifierProvider.autoDispose<BeUserState>((ref) => BeUserState());

class BeUserState extends ChangeNotifier {
  void setNotifyUserChange() {
    notifyListeners();
  }
}
