import 'package:bloc/bloc.dart';

class CountCubit extends Cubit<int> {
  CountCubit() : super(0);

  void addCount() {
    emit(state + 1);
  }

  void subtractCount() {
    emit(state - 1);
  }
}
