import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_test/counter_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CounterNotifier(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    Provider.of<CounterNotifier>(context, listen: false).incrementCounter();
  }

  void _decrementCounter() {
    Provider.of<CounterNotifier>(context, listen: false).decrementCounter();
  }

  void _callRestData() {
    Provider.of<CounterNotifier>(context, listen: false)
        .getEconomicActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Consumer<CounterNotifier>(
              builder: (BuildContext context, CounterNotifier counter,
                  Widget witget) {
                return Text(
                  '${counter.counter}',
                  style: Theme.of(context).textTheme.display1,
                );
              },
            ),
            test(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _callRestData,
            tooltip: 'Call Economic Activities',
            child: Icon(Icons.perm_phone_msg),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: Icon(Icons.navigate_before),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.navigate_next),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget test() {
    return StreamBuilder(
      stream:
          Provider.of<CounterNotifier>(context, listen: false).chuckListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return testW(snapshot.data);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget testW(List<EconomicActivity> activities) {
    Widget testW = StreamBuilder(
      stream: Provider.of<CounterNotifier>(context, listen: false)
          .selectedActivity$
          .stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButton<EconomicActivity>(
            isExpanded: true,
            hint: Text(
              'Sector de actividad económica',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            value: snapshot.data,
            items: activities.map((EconomicActivity value) {
              return new DropdownMenuItem<EconomicActivity>(
                value: value,
                child: new Text(value.name),
              );
            }).toList(),
            onChanged: (data) {
              Provider.of<CounterNotifier>(context, listen: false)
                  .selectedActivity$
                  .sink
                  .add(data);
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
    return testW;
  }

  Future<int> sumStream(Stream<int> stream) async {
    var sum = 0;
    await for (var value in stream) {
      sum += value;
    }
    return sum;
  }

  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      yield i;
    }
  }
}
