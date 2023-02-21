import 'package:equatable/equatable.dart';

//TimerState розширює Equatable для оптимізації нашого коду, гарантуючи, що наш додаток не запускає перебудови, якщо виникає той самий стан(same state).
abstract class TimerState extends Equatable {
  const TimerState(this.duration);
  final int duration;

  @override
  List<Object> get props => [duration];
}

//готовий до початку зворотного відліку від заданої тривалості.
class TimerInitial extends TimerState {
  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial {duration : $duration}';
}

//пауза на деякий час, що залишився. користувач зможе відновити таймер і скинути таймер.
class TimerRunPause extends TimerState {
  const TimerRunPause(super.duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration}';
}

//сі TimerStates розширюють абстрактний базовий клас TimerState, який має властивість duration.
// Це тому, що незалежно від того, в якому стані знаходиться наш TimerBloc, ми хочемо знати, скільки часу залишилося.
class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);


  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

//користувач зможе скинути таймер.
class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}

