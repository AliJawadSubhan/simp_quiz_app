import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simp_quiz_app/sccreen/qeue/queu_state.dart';

class QeueuCubit extends Cubit<QueueState> {
  QeueuCubit()
      : super(
          QueueInit(),
        );
}
