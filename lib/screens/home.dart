import 'package:badges/badges.dart';
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
  void callback() {
    setState(() {});
  }

  void _addWatch() {
    var currentKey = UniqueKey();
    setState(() {
      stopWatches.add(
        SingleStopWatch(
          key: currentKey,
          callback: callback,
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
      floatingActionButton: Badge(
        badgeContent: Text(
          stopWatches.length.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        child: FloatingActionButton(
          backgroundColor: stopWatches.length >= 10 ? Colors.grey : null,
          onPressed: stopWatches.length >= 10
              ? null
              : () {
                  _addWatch();
                },
          tooltip: 'Yeni Kronometre Ekle',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  ScrollController scrollController = ScrollController();

  Widget buildStopWatchList() {
    final colorScheme = Theme.of(context).colorScheme;
    final orientation = MediaQuery.of(context).orientation;
    return Expanded(
      child: Scrollbar(
        interactive: true,
        thumbVisibility: stopWatches.isNotEmpty ? true : false,
        controller: scrollController,
        child: GridView(
          controller: scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          semanticChildCount: stopWatches.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.3,
            crossAxisCount: orientation == Orientation.portrait ? 1 : 2,
          ),
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
      ),
    );
  }

  Container buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //?Tüm kronometrelere aynı anda tur eklemeyi sağla.
          //ElevatedButton.icon(
          //  onPressed: stopWatches.isNotEmpty ? () {} : null,
          //  label: const Text('Hepsine Tur'),
          //  icon: const Icon(Icons.flag),
          //  style: ElevatedButton.styleFrom(
          //    minimumSize: const Size(150, 42),
          //  ),
          //),
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
