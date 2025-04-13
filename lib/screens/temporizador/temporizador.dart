import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/lang/app_localization.dart';

class StopwatchWidget extends StatefulWidget {
  const StopwatchWidget({Key? key}) : super(key: key);

  @override
  _StopwatchWidgetState createState() => _StopwatchWidgetState();
}

class _StopwatchWidgetState extends State<StopwatchWidget> {
  final Stopwatch _stopwatch = Stopwatch();
  bool _isRunning = false;
  Duration _selectedDuration = Duration(hours: 0, minutes: 0, seconds: 0);
  late Timer _timer;

  void _toggleStopwatch() {
    setState(() {
      if (_isRunning) {
        _stopStopwatch();
      } else {
        _startStopwatch();
      }
    });
  }

  void _startStopwatch() {
    if (_stopwatch.elapsed < _selectedDuration) {
      _isRunning = true;
      _stopwatch.start();
      _startCountdown();
    }
  }

  void _stopStopwatch() {
    _isRunning = false;
    _stopwatch.stop();
    _timer.cancel();
  }

  void _startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stopwatch.elapsed >= _selectedDuration) {
        _stopStopwatch();
      } else {
        setState(() {
          _selectedDuration = _selectedDuration - Duration(seconds: 1);
        });
      }
    });
  }

  String _formatTime(Duration duration) {
    String hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  Future<void> _showDurationPicker(BuildContext context) async {
    Duration? selectedDuration = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 500.0,
          child: Column(
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDuration = Duration(minutes: 10);
                      });
                      Navigator.of(context).pop(_selectedDuration);
                    },
                    child: Text('10'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDuration = Duration(minutes: 20);
                      });
                      Navigator.of(context).pop(_selectedDuration);
                    },
                    child: Text('20'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedDuration = Duration(minutes: 30);
                      });
                      Navigator.of(context).pop(_selectedDuration);
                    },
                    child: Text('30'),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: _selectedDuration,
                  onTimerDurationChanged: (Duration newDuration) {
                    setState(() {
                      _selectedDuration = newDuration;
                    });
                  },
                ),
              ),
              CupertinoButton(
                child: Text(
                  AppLocalizations.of(context)!.translate('add') +
                      ' ${_selectedDuration.inHours}:${_selectedDuration.inMinutes.remainder(60)}:${_selectedDuration.inSeconds.remainder(60)}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                onPressed: () {
                  Navigator.of(context).pop(_selectedDuration);
                },
              ),
              CupertinoButton(
                child: Text(
                  'Limpiar',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                onPressed: () {
                  setState(() {
                    _selectedDuration = Duration.zero;
                  });
                  Navigator.of(context).pop(_selectedDuration);
                },
              ),
            ],
          ),
        );
      },
    );
    if (selectedDuration != null) {
      setState(() {
        _selectedDuration = selectedDuration;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: 210,
      height: 60,
      padding: EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        border: Border.all(width: 3.0, color: Colors.black),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              _showDurationPicker(context);
            },
            child: Text(
              _formatTime(_selectedDuration),
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onSurface,
                fontSize: 26,
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.01),
          GestureDetector(
            onTap: _toggleStopwatch,
            child: Icon(
              _isRunning ? Icons.pause : Icons.play_arrow,
              size: 40,
              color: theme.iconTheme.color,
            ),
          ),
        ],
      ),
    );
  }
}
