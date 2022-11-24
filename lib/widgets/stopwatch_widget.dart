import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multikronometre/screens/home.dart';

class SingleStopWatch extends StatefulWidget {
  final void Function() callback;
  const SingleStopWatch({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  State<SingleStopWatch> createState() => SingleStopWatchState();
}

class SingleStopWatchState extends State<SingleStopWatch>
    with TickerProviderStateMixin {
  final ScrollController stopsScrollController = ScrollController();
  late AnimationController? _controller;
  Timer? _timer;
  int splitSeconds = 0;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  bool isRunning = false;
  bool isStarted = false;

  String stringSplitSeconds = '00';
  String stringSeconds = '00';
  String stringMinutes = '00';
  String stringHours = '00';

  List<String> stops = List.empty(growable: true);

  void _reset() {
    setState(() {
      _timer?.cancel();
      splitSeconds = 0;
      seconds = 0;
      minutes = 0;
      hours = 0;
      stringSplitSeconds = '0';
      stringSeconds = '00';
      stringMinutes = '00';
      stringHours = '00';
      isRunning = false;
      isStarted = false;
      stops.clear();
    });
  }

  void onLap() {
    if (!(splitSeconds == 0 && seconds == 0 && minutes == 0 && hours == 0)) {
      setState(() {
        stops.add(
            '$stringHours:$stringMinutes:$stringSeconds.${stringSplitSeconds}0');
      });
    }
    final position = stopsScrollController.position.maxScrollExtent;
    //tur tuşuna basılınca liste görünümü en üste kaydırıyor.
    if (stopsScrollController.hasClients) {
      stopsScrollController.animateTo(
        position + 30,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleOnStartStop() {
    setState(() {
      isRunning = !isRunning;
      isRunning ? _controller?.forward() : _controller?.reverse();
    });

    if (isRunning) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        int localSplitSeconds = splitSeconds;
        int localSeconds = seconds;
        int localMinutes = minutes;
        int localHours = hours;

        localSplitSeconds++;
        if (localSplitSeconds == 10) {
          localSplitSeconds = 0;
          localSeconds++;
        }
        if (localSeconds > 59) {
          localSeconds = 0;
          localMinutes++;
        }
        if (localMinutes > 59) {
          localMinutes = 0;
          localHours++;
        }
        setState(() {
          splitSeconds = localSplitSeconds;
          seconds = localSeconds;
          minutes = localMinutes;
          hours = localHours;
          stringSplitSeconds = localSplitSeconds.toString();
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

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    isRunning ? _controller?.forward() : _controller?.reverse();
    final colorScheme = Theme.of(context).colorScheme;
    if (splitSeconds == 0 && seconds == 0 && minutes == 0 && hours == 0) {
      isStarted = false;
    } else {
      isStarted = true;
    }

    return Card(
      color: colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: TextField(
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Başlık',
                hintStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildWatch(context),
                  buildButtons(colorScheme),
                ],
              ),
              if (stops.isNotEmpty)
                const SizedBox(
                  width: 20,
                ),
              buildStopsList(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButtons(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          label: Text(
            isStarted ? 'Sıfırla' : 'Sil',
            style: const TextStyle(color: Colors.red),
          ),
          onPressed: !isStarted
              ? () {
                  stopWatches
                      .removeWhere((element) => widget.key == element.key);
                  widget.callback();
                }
              : () {
                  _reset();
                },
          icon: Icon(
            !isStarted ? Icons.delete : Icons.refresh,
            color: Colors.red,
            size: 20,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(stops.isEmpty ? 100 : 50, 30),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: stops.isEmpty ? 8.0 : 2.0),
          child: IconButton(
            onPressed: () {
              _handleOnStartStop();
            },
            icon: AnimatedIcon(
              size: 20,
              icon: AnimatedIcons.play_pause,
              progress: _controller!,
              color: Colors.white,
            ),
            style: roundIconButton(colorScheme),
          ),
        ),
        ElevatedButton.icon(
          label: const Text('Tur'),
          onPressed: !isStarted
              ? null
              : () {
                  setState(() {
                    onLap();
                  });
                },
          icon: Icon(
            Icons.flag,
            size: 20,
            color: !isStarted ? null : colorScheme.primary,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(stops.isEmpty ? 100 : 50, 30),
          ),
        ),
      ],
    );
  }

  BorderRadius styleButtonRadiusLR({bool isLeftButton = false}) {
    if (isLeftButton) {
      return const BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(16),
      );
    } else {
      return const BorderRadius.only(
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      );
    }
  }

  RichText buildWatch(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$stringHours:$stringMinutes:$stringSeconds',
            style: const TextStyle(fontSize: 46),
          ),
          TextSpan(
            text: '.$stringSplitSeconds',
            style: const TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Visibility buildStopsList() {
    return Visibility(
        visible: stops.isNotEmpty,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: stops.isEmpty ? 0 : 100,
            maxWidth: stops.isEmpty ? 0 : 105,
          ),
          child: ListView.builder(
            controller: stopsScrollController,
            reverse: true,
            itemCount: stops.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(text: '${index < 9 ? '0' : ''}${index + 1}. '),
                    TextSpan(
                      text: stops[index],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  ButtonStyle roundIconButton(ColorScheme colorScheme) {
    return IconButton.styleFrom(
      minimumSize: const Size(40, 40),
      foregroundColor: colorScheme.onPrimary,
      backgroundColor: colorScheme.primary,
      disabledBackgroundColor: colorScheme.onSurface.withOpacity(0.12),
      hoverColor: colorScheme.onPrimary.withOpacity(0.08),
      focusColor: colorScheme.onPrimary.withOpacity(0.12),
      highlightColor: colorScheme.onPrimary.withOpacity(0.12),
    );
  }
}
