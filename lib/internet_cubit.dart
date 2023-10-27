import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetCubit extends Cubit<InternetState> {
  StreamSubscription? streamSubscription;
  final Connectivity _connectivity = Connectivity();
  InternetCubit() : super(InternetState.init) {
    streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi ||
          event == ConnectivityResult.mobile) {
        emit(InternetState.gain);
      } else {
        emit(InternetState.error);
      }
    });
  }
  final username = "Ali jawad subhan";
}

enum InternetState { init, gain, error }
