import 'dart:async';

import 'package:flutter/material.dart';

import 'settings.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  List<bool> isPlaying = List.filled(10, false, growable: false);

  List<int> seconds = [];
  List<int> minutes = [];
  List<int> hours = [];

  List<String> secondsString = List.filled(10, '00', growable: false);
  List<String> minutesString = List.filled(10, '00', growable: false);
  List<String> hoursString = List.filled(10, '00', growable: false);

  List<Timer>? timer;

  late bool isOnlyOneWatch = seconds.length == 1;

  void resetAtIndex(int index) {
    timer?[index].cancel();
    setState(() {
      seconds[index] = 0;
      minutes[index] = 0;
      hours[index] = 0;
    });
  }

  void _handleOnStartStop(int index) {
    setState(() {
      isPlaying[index] = !isPlaying[index];
      isPlaying[index]
          ? _controllers[index].forward()
          : _controllers[index].reverse();
    });

    if (isPlaying[index]) {
      timer?[index] = Timer.periodic(const Duration(seconds: 1), (timer) {
        int localSeconds = seconds[index];
        int localMinutes = minutes[index];
        int localHours = hours[index];

        localSeconds++;
        if (localSeconds > 59) {
          localSeconds = 0;
          localMinutes++;
        }
        if (localMinutes > 59) {
          localMinutes = 0;
          localHours++;
        }
        setState(() {
          seconds[index] = localSeconds;
          minutes[index] = localMinutes;
          hours[index] = localHours;
          secondsString[index] =
              seconds[index] >= 10 ? '${seconds[index]}' : '0${seconds[index]}';
          minutesString[index] =
              minutes[index] >= 10 ? '${minutes[index]}' : '0${minutes[index]}';
          hoursString[index] =
              hours[index] >= 10 ? '${hours[index]}' : '0${hours[index]}';
        });
      });
    } else {
      timer?[index].cancel();
    }
  }

  void _addWatch(int index) {
    setState(() {
      isPlaying[index] = false;
      _controllers[index].reset();
      seconds.add(0);
      minutes.add(0);
      hours.add(0);
      timer?.add(Timer(const Duration(seconds: 0), () {}));
      secondsString[index] = '00';
      minutesString[index] = '00';
      hoursString[index] = '00';
    });
  }

  void _deleteWatch(int index) {
    setState(() {
      timer?[index].cancel();
      timer?.removeAt(index);
      seconds.removeAt(index);
      minutes.removeAt(index);
      hours.removeAt(index);
      secondsString[index] = '00';
      minutesString[index] = '00';
      hoursString[index] = '00';
      isPlaying[index] = false;
    });
  }

  void _deleteAll() {
    setState(() {
      int length = seconds.length;
      for (int i = length - 1; i >= 1; i--) {
        timer?[i].cancel();
        timer?.removeAt(i);
        seconds.removeAt(i);
        minutes.removeAt(i);
        hours.removeAt(i);
        isPlaying[i] = false;
        secondsString[i] = '00';
        minutesString[i] = '00';
        hoursString[i] = '00';
      }

      timer?[0].cancel();
      seconds[0] = 0;
      minutes[0] = 0;
      hours[0] = 0;
      isPlaying[0] = false;
      secondsString[0] = '00';
      minutesString[0] = '00';
      hoursString[0] = '00';
    });
  }

  @override
  void initState() {
    super.initState();
    //first stopwatch
    seconds.add(0);
    minutes.add(0);
    hours.add(0);
    timer = [];
    _controllers = [];
    //timer?.add(Timer(const Duration(seconds: 0), () {}));
    for (int i = 0; i < 10; i++) {
      _controllers.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.every((controller) {
      controller.dispose();
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    isOnlyOneWatch = seconds.length == 1;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: seconds.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextField(
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                prefixText: (index + 1).toString(),
                                border: InputBorder.none,
                                hintText: 'Başlık',
                              ),
                            ),
                          ),
                        ),
                        //const Divider(),
                        Text(
                          '${hoursString[index]}:${minutesString[index]}:${secondsString[index]}',
                          style: const TextStyle(fontSize: 64),
                        ),
                        //const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              label: const Text('Tur'),
                              icon: const Icon(Icons.flag),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                onPressed: () {
                                  _handleOnStartStop(index);
                                },
                                icon: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _controllers[index]),
                                style: IconButton.styleFrom(
                                  minimumSize: const Size(60, 60),
                                  foregroundColor: colorScheme.onPrimary,
                                  backgroundColor: colorScheme.primary,
                                  disabledBackgroundColor:
                                      colorScheme.onSurface.withOpacity(0.12),
                                  hoverColor:
                                      colorScheme.onPrimary.withOpacity(0.08),
                                  focusColor:
                                      colorScheme.onPrimary.withOpacity(0.12),
                                  highlightColor:
                                      colorScheme.onPrimary.withOpacity(0.12),
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: isOnlyOneWatch
                                  ? null
                                  : () {
                                      _deleteWatch(index);
                                      setState(() {
                                        print('object');
                                      });
                                    },
                              label: Text(
                                'Sil',
                                style: TextStyle(
                                    color: isOnlyOneWatch
                                        ? Colors.grey
                                        : Colors.red),
                              ),
                              icon: Icon(Icons.delete,
                                  color: isOnlyOneWatch
                                      ? Colors.grey
                                      : Colors.red),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: const Text('Hepsine Tur'),
                    icon: const Icon(Icons.flag),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 42),
                      //backgroundColor: Colors.red,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: isOnlyOneWatch
                        ? null
                        : () {
                            _deleteAll();
                          },
                    label: Text(
                      'Hepsini Sil',
                      style: TextStyle(
                          color: isOnlyOneWatch ? Colors.grey : Colors.white),
                    ),
                    icon: Icon(Icons.delete_forever,
                        color: isOnlyOneWatch ? Colors.grey : Colors.white),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 42),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ]),
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: seconds.length >= 10 ? Colors.grey : null,
        onPressed: seconds.length >= 10
            ? null
            : () {
                _addWatch(seconds.length);
              },
        tooltip: 'Yeni Kronometre Ekle',
        child: const Icon(Icons.add),
      ),
    );
  }
}
