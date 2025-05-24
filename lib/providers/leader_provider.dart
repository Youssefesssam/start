import 'package:flutter/material.dart';

import '../models/leader_model.dart';

class LeaderProvider with ChangeNotifier {
  LeaderModel? _currentLeader;

  LeaderModel? get currentLeader => _currentLeader;

  void setCurrentLeader(LeaderModel leader) {
    _currentLeader = leader;
    notifyListeners();
  }

  void clearCurrentLeader() {
    _currentLeader = null;
    notifyListeners();
  }
}