import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/modules/counter/cubit/states.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterInitailState());

  static CounterCubit get(context) => BlocProvider.of(context);
  int counter = 1;

  void plusCounter() {
    counter++;
    emit(CounterPlusState(counter));
  }

  void minusCounter() {
    counter--;
    emit(CounterMinusState(counter));
  }
}
