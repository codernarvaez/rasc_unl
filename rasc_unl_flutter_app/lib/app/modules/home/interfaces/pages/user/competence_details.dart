import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CompetenceDetailsPage extends StatefulWidget {
  final CompetenceData competence;

  const CompetenceDetailsPage({Key? key, required this.competence}) : super(key: key);

  @override
  _CompetenceDetailsPageState createState() => _CompetenceDetailsPageState();
}

class _CompetenceDetailsPageState extends State<CompetenceDetailsPage> {
  // Simulación de datos de participantes
  List<ParticipantData> participants = [
    ParticipantData(position: 1, name: 'Juan Pérez', dni: '0912345678', time: Duration(minutes: 15, seconds: 30)),
    ParticipantData(position: 2, name: 'María García', dni: '0923456789', time: Duration(minutes: 15, seconds: 45)),
    ParticipantData(position: 3, name: 'Carlos López', dni: '0934567890', time: Duration(minutes: 16, seconds: 10)),
    ParticipantData(position: 4, name: 'Ana Martínez', dni: '0945678901', time: Duration(minutes: 16, seconds: 30)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCompetenceInfo(),
                      _buildLeaderboard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
              context.go('/home')
            }
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.competence.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: widget.competence.isActive
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: widget.competence.isActive ? Colors.green : Colors.red,
              ),
            ),
            child: Text(
              widget.competence.isActive ? 'Activa' : 'Inactiva',
              style: TextStyle(
                color: widget.competence.isActive ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetenceInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFD50000).withOpacity(0.15),
              Color(0xFF8B0000).withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Color(0xFFD50000).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  Icons.calendar_today,
                  'Fecha',
                  _formatDate(widget.competence.competitionDate),
                ),
                _buildInfoItem(
                  Icons.access_time,
                  'Hora',
                  _formatTime(widget.competence.competitionDate),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  Icons.loop,
                  'Vueltas',
                  '${widget.competence.nTurns}',
                ),
                _buildInfoItem(
                  Icons.timer_outlined,
                  'Duración Aprox.',
                  '${widget.competence.nTurns * 2} min',
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(color: Colors.white.withOpacity(0.2)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  Icons.people,
                  'Participantes',
                  '${participants.length}',
                ),
                _buildInfoItem(
                  Icons.flag,
                  'Estado',
                  widget.competence.isActive ? 'Abierta' : 'Cerrada',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFD50000), size: 28),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboard() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 28),
              SizedBox(width: 12),
              Text(
                'Clasificación',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (participants.isEmpty)
            _buildEmptyLeaderboard()
          else
            ...participants.map((p) => _buildParticipantCard(p)).toList(),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(ParticipantData participant) {
    Color positionColor = _getPositionColor(participant.position);
    bool isPodium = participant.position <= 3;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPodium
            ? positionColor.withOpacity(0.08)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPodium
              ? positionColor.withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: isPodium ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: isPodium
                    ? LinearGradient(colors: [positionColor, positionColor.withOpacity(0.7)])
                    : null,
                color: isPodium ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  isPodium ? _getPositionEmoji(participant.position) : '${participant.position}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isPodium ? 24 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'DNI: ${participant.dni}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer, color: Color(0xFFD50000), size: 16),
                    SizedBox(width: 4),
                    Text(
                      _formatDuration(participant.time),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyLeaderboard() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.hourglass_empty,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
            SizedBox(height: 16),
            Text(
              'Sin resultados aún',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 1: return Color(0xFFFFD700);
      case 2: return Color(0xFFC0C0C0);
      case 3: return Color(0xFFCD7F32);
      default: return Color(0xFFD50000);
    }
  }

  String _getPositionEmoji(int position) {
    switch (position) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '$position';
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  String _formatDate(DateTime date) {
    List<String> months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}

class CompetenceData {
  final String name;
  final DateTime competitionDate;
  final int nTurns;
  final bool isActive;

  CompetenceData({
    required this.name,
    required this.competitionDate,
    required this.nTurns,
    required this.isActive,
  });
}

class ParticipantData {
  final int position;
  final String name;
  final String dni;
  final Duration time;

  ParticipantData({
    required this.position,
    required this.name,
    required this.dni,
    required this.time,
  });
}