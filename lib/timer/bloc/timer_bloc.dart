import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_timer_bloc/timer/bloc/timer_event.dart';
import 'package:flutter_timer_bloc/timer/bloc/timer_state.dart';

import '../../ticker.dart';


//1) Перше, що нам потрібно зробити, це визначити початковий стан нашого TimerBloc.
// У цьому випадку ми хочемо, щоб TimerBloc запускався в стані TimerInitial із попередньо встановленою тривалістю 1 хвилина (60 секунд).
//2) Далі нам потрібно визначити залежність від нашого Ticker.
//На цьому етапі все, що залишилося зробити, це реалізувати обробники подій.
//3) Для кращої читабельності я люблю розбивати кожен обробник подій на окрему допоміжну функцію. Ми почнемо з події TimerStarted.
class TimerBloc extends Bloc<TimerEvent, TimerState> {
  //set initial state
  final Ticker _ticker;
  static const int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerInitial(_duration)) {
    //реалізувати обробники подій
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
  }
  
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  //Якщо TimerBloc отримує подію TimerStarted, він надсилає стан TimerRunInProgress із початковою тривалістю.
  // Крім того, якщо вже була відкрита підписка _tickerSubscription, нам потрібно скасувати її, щоб звільнити пам’ять.
  // Нам також потрібно перевизначити метод close у нашому TimerBloc, щоб ми могли скасувати підписку _tickerSubscription, коли TimerBloc закрито.
  // Нарешті, ми слухаємо потік _ticker.tick і на кожному тику додаємо подію TimerTicked із залишковою тривалістю.
  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration));
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
      .tick(ticks: event.duration)
      .listen((duration) => add(TimerTicked(duration: duration)));
  }

//якщо стан нашого TimerBloc TimerRunInProgress, ми можемо призупинити _tickerSubscription і надіслати стан TimerRunPause із поточною тривалістю таймера.
  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if(state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  //Обробник події TimerResumed дуже схожий на обробник події TimerPaused.
  // Якщо TimerBloc має стан TimerRunPause і отримує подію TimerResumed, тоді він відновлює _tickerSubscription і надсилає стан TimerRunInProgress із поточною тривалістю.
  void _onResumed(TimerResumed resume, Emitter<TimerState> emit) {
    if(state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  //Якщо TimerBloc отримує подію TimerReset, йому потрібно скасувати поточну підписку _tickerSubscription,
  // щоб він не отримував сповіщення про будь-які додаткові тіки, і передає стан TimerInitial із початковою тривалістю.
  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }

  //Щоразу, коли надходить подія TimerTicked, якщо тривалість тика перевищує 0, нам потрібно надіслати оновлений стан TimerRunInProgress із новою тривалістю.
  // В іншому випадку, якщо тривалість тика дорівнює 0, наш таймер закінчився, і нам потрібно натиснути стан TimerRunComplete.
  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : const TimerRunComplete(),
    );
  }
}