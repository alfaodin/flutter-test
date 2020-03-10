import 'dart:async';

import 'package:flutter/foundation.dart';

class CounterNotifier extends ChangeNotifier {
  /// Internal, private state of the cart.
  int _counter = 0;

  StreamController selectedActivity$;
  StreamController _chuckListController;

  CounterNotifier() {
    selectedActivity$ = StreamController<EconomicActivity>();
    _chuckListController = StreamController<List<EconomicActivity>>();
  }

  int get counter => _counter;

  final streamTransformer =
      StreamTransformer<EconomicActivity, EconomicActivity>.fromHandlers(
    handleData: (EconomicActivity data, EventSink sink) {
      if (data != null) {
        sink.add(data);
      } else {
        sink.addError('Contraseña necesita más de 6 caracteres.');
      }
    },
    handleError: (error, stacktrace, sink) {
      sink.addError('Something went wrong: $error');
    },
    handleDone: (sink) {
      sink.close();
    },
  );

  Stream<List<EconomicActivity>> get chuckListStream =>
      _chuckListController.stream;

  Stream<EconomicActivity> get selectedActivity =>
      selectedActivity$.stream.transform(streamTransformer);

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    _counter--;
    notifyListeners();
  }

  void dispose() {
    _chuckListController.close();
    selectedActivity$.close();
    super.dispose();
  }

  void getEconomicActivities() {
    Future.delayed(Duration(seconds: 3)).then((onValue) {
      List<EconomicActivity> result = [
        EconomicActivity(1, 'test1'),
        EconomicActivity(2, 'test2'),
        EconomicActivity(3, 'test3'),
        EconomicActivity(4, 'test4'),
        EconomicActivity(5, 'test5'),
      ];
      _chuckListController.sink.add(result);
    });
  }
}

class EconomicActivity {
  final int id;
  final String name;
  final String code;

  EconomicActivity(id, name)
      : this.id = id,
        this.name = name,
        this.code = id.toString() + name;
}
