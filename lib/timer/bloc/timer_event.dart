//Наш TimerBlock має знати як обробляти такі події як

abstract class TimerEvent {
  const TimerEvent();
}

// TimerStarted  - Початок роботи таймера
class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

// TimerPaused - повідомляє TimerBloc, що таймер слід призупинити.
class TimerPaused extends TimerEvent {
  const TimerPaused();
}

// TimerResumed - повідомляє TimerBloc, що таймер слід відновити.
class TimerResumed extends TimerEvent {
  const TimerResumed();
}

// TimerReset - повідомляє TimerBloc, що таймер слід скинути до вихідного стану.
class TimerReset extends TimerEvent {
  const TimerReset();
}

//_TimerTicked - повідомляє TimerBloc про те, що стався тік(tick), і йому потрібно відповідно оновити свій стан.
class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});

  final int duration;
}

