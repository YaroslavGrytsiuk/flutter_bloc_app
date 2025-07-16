import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/counter/bloc/counter_event.dart';
import 'package:flutter_bloc_app/counter/bloc/counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(0)) {
    on<CounterIncrementEvent>((event, emit) {
      emit(CounterState(state.count + 1));
    });
    on<CounterDecrementEvent>((event, emit) {
      emit(CounterState(state.count - 1));
    });
    on<CounterResetEvent>((event, emit) {
      emit(CounterState(0));
    });
  }
}
