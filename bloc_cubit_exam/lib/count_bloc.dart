import 'package:bloc/bloc.dart';

abstract class CountEvent {}

class AddCountEvent extends CountEvent {}

class SubtractCountEvent extends CountEvent {}

class CountBloc extends Bloc<CountEvent, int> {
  CountBloc() : super(0) {
    on<AddCountEvent>(addCount);
    on<SubtractCountEvent>(subtractCount);
  }

  void addCount(AddCountEvent e, emit) {
    emit(state + 1);
  }

  void subtractCount(SubtractCountEvent e, emit) {
    emit(state - 1);
  }
}
