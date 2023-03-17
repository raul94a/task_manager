

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final timerStreamProvider = Provider<TimerStreamState>((ref)=> TimerStreamState());


class TimerStreamState {

  final StreamController<int> controller  = StreamController.broadcast();
  StreamSubscription<int>? subscription;


}