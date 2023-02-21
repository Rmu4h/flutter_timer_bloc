
//Тікер буде джерелом даних для програми таймера. Це відкриє потік галочок(stream of ticks), на які ми можемо підписатися та реагувати.
// клас Ticker, — надає функцію tick, яка бере потрібну нам кількість тактів (у секундах) і повертає потік, який щосекунди видає секунди
class Ticker{
  const Ticker();

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }
}