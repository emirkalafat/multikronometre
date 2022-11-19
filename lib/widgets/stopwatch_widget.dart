import 'dart:async';

import 'package:flutter/material.dart';

class SingleStopWatch extends StatefulWidget {
  //final int seconds;
  //final int minutes;
  //final int hours;
  const SingleStopWatch({
    Key? key,
    //required this.seconds,
    //required this.minutes,
    //required this.hours,
  }) : super(key: key);

  @override
  State<SingleStopWatch> createState() => SingleStopWatchState();
}

class SingleStopWatchState extends State<SingleStopWatch>
    with TickerProviderStateMixin {
  late AnimationController? _controller;
  Timer? _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isRunning = false;
  bool isStarted = false;

  String stringSeconds = '00';
  String stringMinutes = '00';
  String stringHours = '00';

  List<String> stops = List.empty(growable: true);

  void _reset() {
    setState(() {
      _timer?.cancel();
      seconds = 0;
      minutes = 0;
      hours = 0;
      stringSeconds = '00';
      stringMinutes = '00';
      stringHours = '00';
      isRunning = false;
      isStarted = false;
      stops.clear();
    });
  }

  void onLap() {
    setState(() {
      stops.add('$stringHours:$stringMinutes:$stringSeconds');
    });
  }

  void _handleOnStartStop() {
    setState(() {
      isRunning = !isRunning;
      isRunning ? _controller?.forward() : _controller?.reverse();
    });

    if (isRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        int localSeconds = seconds;
        int localMinutes = minutes;
        int localHours = hours;

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
          seconds = localSeconds;
          minutes = localMinutes;
          hours = localHours;
          stringSeconds = seconds >= 10 ? '$seconds' : '0$seconds';
          stringMinutes = minutes >= 10 ? '$minutes' : '0$minutes';
          stringHours = hours >= 10 ? '$hours' : '0$hours';
        });
      });
    } else {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _timer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    //seconds = widget.seconds;
    //minutes = widget.minutes;
    //hours = widget.hours;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    isRunning ? _controller?.forward() : _controller?.reverse();
    final colorScheme = Theme.of(context).colorScheme;
    seconds == 0 && minutes == 0 && hours == 0
        ? isStarted = false
        : isStarted = true;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    //prefixText: (widget. + 1).toString(),
                    border: InputBorder.none,
                    hintText: 'Başlık',
                  ),
                ),
              ),
            ),
            Text(
              '$stringHours:$stringMinutes:$stringSeconds',
              style: const TextStyle(fontSize: 64),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      onLap();
                    });
                  },
                  label: const Text('Tur'),
                  icon: const Icon(Icons.flag),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      _handleOnStartStop();
                    },
                    icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause, progress: _controller!),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      foregroundColor: colorScheme.onPrimary,
                      backgroundColor: colorScheme.primary,
                      disabledBackgroundColor:
                          colorScheme.onSurface.withOpacity(0.12),
                      hoverColor: colorScheme.onPrimary.withOpacity(0.08),
                      focusColor: colorScheme.onPrimary.withOpacity(0.12),
                      highlightColor: colorScheme.onPrimary.withOpacity(0.12),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: !isStarted
                      ? null
                      : () {
                          _reset();
                        },
                  label: Text(
                    'Sıfırla',
                    style:
                        TextStyle(color: !isStarted ? Colors.grey : Colors.red),
                  ),
                  icon: Icon(Icons.refresh,
                      color: !isStarted ? Colors.grey : Colors.red),
                )
              ],
            ),
            if (stops.isNotEmpty) const Divider(),
            if (stops.isNotEmpty)
              Container(
                  constraints: const BoxConstraints(
                    minHeight: 0,
                    maxHeight: 200,
                  ),
                  //duration: const Duration(milliseconds: 1000),
                  child: ListView(
                    shrinkWrap: true,
                    children: stops
                        .asMap()
                        .entries
                        .map(
                          (stop) => ListTile(
                            title: Text('${stop.key + 1}. ${stop.value}'),
                          ),
                        )
                        .toList(),
                  ))
          ],
        ),
      ),
    );
  }
}