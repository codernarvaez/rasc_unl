import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competence_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class PublicResultsPage extends ConsumerStatefulWidget {
  const PublicResultsPage({super.key});

  @override
  ConsumerState<PublicResultsPage> createState() => _PublicResultsPageState();
}

class _PublicResultsPageState extends ConsumerState<PublicResultsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  CompetenceModel? _selectedCompetence;
  List<CompetenceModel> _competences = [];

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCompetences();
      _startAutoRefresh();
    });
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        _loadCompetences(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCompetences({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider);
      // Fetch all competences
      final allCompetences = await repository.competenceRepository
          .getAllCompetences();

      // Filter out deleted ones if necessary, but generally we want to show all valid ones.
      // Assuming getAllCompetences returns non-deleted ones or we filter here.
      // Let's show all competences that are either active OR finished (history).
      // If a competence is inactive AND not finished, it might be a draft/hidden.
      // Let's assume we show everything for now, or maybe filter by isActive?
      // "Active" usually means "Enabled". "Finished" means "Done".
      // If we want to show results of past competitions, they might be "Inactive" (archived) or "Finished".
      // Let's show all competences where isActive is true OR isFinished is true.

      final visibleCompetences = allCompetences
          .where((c) => c.isActive || c.isFinished)
          .toList();

      // Sort by date descending (newest first)
      visibleCompetences.sort((a, b) {
        if (a.competitionDate == null) return 1;
        if (b.competitionDate == null) return -1;
        return b.competitionDate!.compareTo(a.competitionDate!);
      });

      if (mounted) {
        setState(() {
          _competences = visibleCompetences;

          if (_competences.isNotEmpty) {
            // Default to the one that is Active AND Not Finished
            try {
              _selectedCompetence = _competences.firstWhere(
                (c) => c.isActive && !c.isFinished,
              );
            } catch (e) {
              // If no active & unfinished competition found, default to the most recent one
              _selectedCompetence = _competences.first;
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Resultados RASC UNL',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (_competences.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: DropdownButton<String>(
                value: _selectedCompetence?.id,
                dropdownColor: const Color(0xFF1A1A1A),
                underline: Container(),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFFD50000),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCompetence = _competences.firstWhere(
                      (c) => c.id == newValue,
                    );
                  });
                },
                items: _competences.map<DropdownMenuItem<String>>((
                  CompetenceModel value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Text(
                      value.name,
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => context.go('/session'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFD50000),
          labelColor: const Color(0xFFD50000),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Orden de Llegada'),
            Tab(text: 'Clasificación General'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD50000)),
            )
          : _selectedCompetence == null
          ? const Center(
              child: Text(
                'No hay competencias disponibles',
                style: TextStyle(color: Colors.white),
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: [
                _ArrivalOrderView(competence: _selectedCompetence!),
                _GeneralClassificationView(competence: _selectedCompetence!),
              ],
            ),
    );
  }
}

class _ArrivalOrderView extends ConsumerStatefulWidget {
  final CompetenceModel competence;

  const _ArrivalOrderView({required this.competence});

  @override
  ConsumerState<_ArrivalOrderView> createState() => _ArrivalOrderViewState();
}

class _ArrivalOrderViewState extends ConsumerState<_ArrivalOrderView> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _results = [];
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadResults();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) {
        _loadResults(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ArrivalOrderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.competence.id != widget.competence.id) {
      _loadResults();
    }
  }

  Future<void> _loadResults({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider);

      // 1. Get registrations for this competence
      final registrations = await repository.competitionRegistrationRepository
          .getRegistrationsByCompetenceId(widget.competence.id);

      // 2. Get time records for each registration
      final List<Map<String, dynamic>> results = [];

      for (var reg in registrations) {
        final times = await repository.competitionTimeRecordRepository
            .getTimeRecordsByRegistrationId(reg.id);

        if (times.isNotEmpty) {
          // Sort times to get the best/latest? Or all times?
          // For arrival order, we usually want the total time or the finish time.
          // Assuming the last recorded time is the finish time for now, or sum if laps.
          // Let's assume single run for now or take the best time.
          // Based on InitRunClock, multiple times can be recorded (one per participant).
          // Arrival order usually implies the order they crossed the line.
          // Let's list all individual arrival times.

          for (var timeRecord in times) {
            results.add({
              'registration': reg,
              'time': timeRecord.time,
              'timestamp': timeRecord.createdAt, // Or updatedAt
            });
          }
        }
      }

      // Sort by time duration (ascending)
      results.sort(
        (a, b) => (a['time'] as Duration).compareTo(b['time'] as Duration),
      );

      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFD50000)),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No hay tiempos registrados aún',
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final result = _results[index];
        final rank = index + 1;
        final isTop3 = rank <= 3;
        final reg = result['registration'];
        final time = result['time'] as Duration;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 50).clamp(0, 1000)),
          curve: Curves.easeOutQuart,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isTop3
                  ? Color(0xFFD50000).withOpacity(0.1 + (0.05 * (4 - rank)))
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isTop3
                    ? Color(0xFFD50000).withOpacity(0.5)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isTop3 ? Color(0xFFD50000) : Colors.white10,
                    boxShadow: isTop3
                        ? [
                            BoxShadow(
                              color: Color(0xFFD50000).withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    '#$rank',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reg.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.tag,
                            size: 14,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Dorsal ${reg.dorsalNumber}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer, size: 14, color: Color(0xFFD50000)),
                      SizedBox(width: 6),
                      Text(
                        _formatDuration(time),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String threeDigitMilliseconds = duration.inMilliseconds
        .remainder(1000)
        .toString()
        .padLeft(3, "0");
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds.$threeDigitMilliseconds";
  }
}

class _GeneralClassificationView extends ConsumerStatefulWidget {
  final CompetenceModel competence;

  const _GeneralClassificationView({required this.competence});

  @override
  ConsumerState<_GeneralClassificationView> createState() =>
      _GeneralClassificationViewState();
}

class _GeneralClassificationViewState
    extends ConsumerState<_GeneralClassificationView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.leaderboard, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            'Clasificación General',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          const Text(
            'Se mostrará al finalizar la competencia',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
