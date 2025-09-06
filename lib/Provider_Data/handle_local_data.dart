import 'package:flutter/material.dart';

class HandleLocal extends ChangeNotifier {

  String _localPath = "";
  String get localPath => _localPath;

  getLocal(String val){
    _localPath = val;
    notifyListeners();
  }


}
