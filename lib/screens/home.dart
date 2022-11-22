import 'package:flutter/material.dart';

import '../widgets/stopwatch_widget.dart';
import 'settings.dart';

List<SingleStopWatch> stopWatches = List.empty(growable: true);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  void _addWatch() {
    var currentKey = UniqueKey();
    setState(() {
      stopWatches.add(
        SingleStopWatch(
          key: currentKey,
        ),
      );
    });
  }

  void _deleteWatch(int index) {
    setState(() {
      stopWatches.removeAt(index);
    });
  }

  void _deleteAll() {
    setState(() {
      stopWatches.clear();
    });
  }

  void _lapAll() {
    //!Bu fonksiyon çalışmıyor.
    //TODO: #1 Bütün kronometrelere aynı anda tur eklemeyi sağla.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          //kronometrelerin bulunduğu alan
          buildStopWatchList(),
          //kronometre ekleme, hepsini silme ve hepsine tur atlatma butonlarının bulunduğu alan
          buildBottomButtons(),
          const SizedBox(
            height: 12,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: stopWatches.length >= 10 ? Colors.grey : null,
        onPressed: stopWatches.length >= 10
            ? null
            : () {
                _addWatch();
              },
        tooltip: 'Yeni Kronometre Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildStopWatchList() {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView(
        semanticChildCount: stopWatches.length,
        children: stopWatches
            .asMap()
            .entries
            .map(
              (stopWatch) => Dismissible(
                key: stopWatch.value.key!,
                onDismissed: (direction) {
                  _deleteWatch(stopWatch.key);
                },
                background: Container(
                  color: colorScheme.error,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: colorScheme.error,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ),
                child: stopWatch.value,
              ),
            )
            .toList(),
      ),
    );
  }

  Container buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: stopWatches.isNotEmpty ? () {} : null,
            label: const Text('Hepsine Tur'),
            icon: const Icon(Icons.flag),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 42),
            ),
          ),
          ElevatedButton.icon(
            onPressed: stopWatches.isNotEmpty
                ? () {
                    _deleteAll();
                  }
                : null,
            label: Text(
              'Hepsini Sil',
              style: TextStyle(
                  color: stopWatches.isNotEmpty ? Colors.white : Colors.grey),
            ),
            icon: Icon(
              Icons.delete_forever,
              color: stopWatches.isNotEmpty ? Colors.white : Colors.grey,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(150, 42),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(widget.title),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ));
            },
            icon: const Icon(Icons.info))
      ],
    );
  }
}
