import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/services/time_services.dart';

/// Provider for timer state
class TimerState {
  final int? elapsedMilliseconds;
  final bool isRunning;
  final String formattedTime;
  final CompetenceModel? competence;

  TimerState({
    this.elapsedMilliseconds,
    this.isRunning = false,
    this.formattedTime = '00:00.000',
    this.competence,
  });

  TimerState copyWith({
    int? elapsedMilliseconds,
    bool? isRunning,
    String? formattedTime,
    CompetenceModel? competence,
  }) {
    return TimerState(
      elapsedMilliseconds: elapsedMilliseconds ?? this.elapsedMilliseconds,
      isRunning: isRunning ?? this.isRunning,
      formattedTime: formattedTime ?? this.formattedTime,
      competence: competence ?? this.competence,
    );
  }
}

/// Notifier for managing timer updates
class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;

  @override
  TimerState build() {
    // Cleanup when provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });

    return TimerState();
  }

  void startTimer(CompetenceModel competence) {
    // Cancel existing timer if any
    _timer?.cancel();

    state = state.copyWith(
      competence: competence,
      isRunning: true,
    );

    // Start periodic updates every 100ms
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (state.competence == null) {
        timer.cancel();
        return;
      }

      final elapsed = TimerService.getElapsedTime(state.competence!);
      if (elapsed != null) {
        state = TimerState(
          elapsedMilliseconds: elapsed,
          isRunning: true,
          formattedTime: TimerService.formatTime(elapsed),
          competence: state.competence,
        );
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = TimerState();
  }

  void updateCompetence(CompetenceModel competence) {
    state = state.copyWith(competence: competence);
  }
}

/// Provider for timer notifier
final timerProvider = NotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});


