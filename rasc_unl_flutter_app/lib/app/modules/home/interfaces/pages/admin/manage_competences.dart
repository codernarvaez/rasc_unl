import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManageCompetencesPage extends StatefulWidget {
  @override
  _ManageCompetencesPageState createState() => _ManageCompetencesPageState();
}

class _ManageCompetencesPageState extends State<ManageCompetencesPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool? _filterActive;

  // Simulación de datos
  List<CompetenceManageData> competences = [
    CompetenceManageData(
      id: 1,
      externalId: 'comp-001',
      name: 'Gran Premio 2024',
      competitionDate: DateTime(2024, 12, 15, 14, 0),
      nTurns: 10,
      isActive: true,
      createdBy: '0912345678',
      registeredUsers: [
        RegisteredUser(dni: '0923456789', name: 'Juan Pérez', registrationNumber: 1),
        RegisteredUser(dni: '0934567890', name: 'María García', registrationNumber: 2),
        RegisteredUser(dni: '0945678901', name: 'Carlos López', registrationNumber: 3),
      ],
    ),
    CompetenceManageData(
      id: 2,
      externalId: 'comp-002',
      name: 'Carrera Nocturna',
      competitionDate: DateTime(2024, 12, 20, 18, 0),
      nTurns: 8,
      isActive: true,
      createdBy: '0912345678',
      registeredUsers: [
        RegisteredUser(dni: '0956789012', name: 'Ana Martínez', registrationNumber: 1),
      ],
    ),
    CompetenceManageData(
      id: 3,
      externalId: 'comp-003',
      name: 'Desafío Extremo',
      competitionDate: DateTime(2024, 11, 5, 16, 0),
      nTurns: 12,
      isActive: false,
      createdBy: '0912345678',
      registeredUsers: [],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CompetenceManageData> get filteredCompetences {
    return competences.where((comp) {
      bool matchesSearch = _searchQuery.isEmpty ||
          comp.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          comp.externalId.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesActive = _filterActive == null || comp.isActive == _filterActive;
      
      return matchesSearch && matchesActive;
    }).toList();
  }

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
              _buildSearchAndFilters(),
              _buildStats(),
              Expanded(child: _buildCompetencesList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEditDialog(null),
        backgroundColor: Color(0xFFD50000),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text('Nueva', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
              context.go('/home')
            },
          ),
          SizedBox(width: 8),
          Text(
            'Gestionar Competencias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o ID...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.white.withOpacity(0.5)),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildFilterChip(
                label: 'Todas',
                isSelected: _filterActive == null,
                onTap: () {
                  setState(() {
                    _filterActive = null;
                  });
                },
              ),
              SizedBox(width: 8),
              _buildFilterChip(
                label: 'Activas',
                isSelected: _filterActive == true,
                onTap: () {
                  setState(() {
                    _filterActive = true;
                  });
                },
              ),
              SizedBox(width: 8),
              _buildFilterChip(
                label: 'Inactivas',
                isSelected: _filterActive == false,
                onTap: () {
                  setState(() {
                    _filterActive = false;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Color(0xFFD50000), Color(0xFF8B0000)])
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Color(0xFFD50000) : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStats() {
    int activeCount = competences.where((c) => c.isActive).length;
    int totalRegistrations = competences.fold(0, (sum, c) => sum + c.registeredUsers.length);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.event_available,
              value: '$activeCount',
              label: 'Activas',
              color: Colors.green,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.people,
              value: '$totalRegistrations',
              label: 'Inscritos',
              color: Color(0xFFD50000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompetencesList() {
    List<CompetenceManageData> displayCompetences = filteredCompetences;

    if (displayCompetences.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 80, color: Colors.white.withOpacity(0.3)),
            SizedBox(height: 16),
            Text(
              'No se encontraron competencias',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Crea una nueva competencia',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: displayCompetences.length,
      itemBuilder: (context, index) {
        return _buildCompetenceCard(displayCompetences[index]);
      },
    );
  }

  Widget _buildCompetenceCard(CompetenceManageData competence) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: competence.isActive
              ? Color(0xFFD50000).withOpacity(0.3)
              : Colors.white.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showDetailsModal(competence),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.flag, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            competence.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ID: ${competence.externalId}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: competence.isActive
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: competence.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                      child: Text(
                        competence.isActive ? 'Activa' : 'Inactiva',
                        style: TextStyle(
                          color: competence.isActive ? Colors.green : Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Divider(color: Colors.white.withOpacity(0.1)),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.5), size: 16),
                    SizedBox(width: 8),
                    Text(
                      _formatDate(competence.competitionDate),
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, color: Colors.white.withOpacity(0.5), size: 16),
                    SizedBox(width: 8),
                    Text(
                      _formatTime(competence.competitionDate),
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    ),
                    Spacer(),
                    Icon(Icons.loop, color: Colors.white.withOpacity(0.5), size: 16),
                    SizedBox(width: 8),
                    Text(
                      '${competence.nTurns} vueltas',
                      style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.people, color: Color(0xFFD50000), size: 16),
                    SizedBox(width: 8),
                    Text(
                      '${competence.registeredUsers.length} inscritos',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildCardButton(
                        label: 'Editar',
                        icon: Icons.edit,
                        onPressed: () => _showCreateEditDialog(competence),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildCardButton(
                        label: 'Eliminar',
                        icon: Icons.delete,
                        color: Colors.red,
                        onPressed: () => _showDeleteDialog(competence),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label, style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Color(0xFFD50000),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showDetailsModal(CompetenceManageData competence) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        competence.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: EdgeInsets.all(24),
                  children: [
                    _buildInfoSection('Información General', [
                      _buildInfoRow('ID Externo', competence.externalId),
                      _buildInfoRow('Fecha', _formatDate(competence.competitionDate)),
                      _buildInfoRow('Hora', _formatTime(competence.competitionDate)),
                      _buildInfoRow('Número de Vueltas', '${competence.nTurns}'),
                      _buildInfoRow('Duración Aprox.', '${competence.nTurns * 2} min'),
                      _buildInfoRow('Estado', competence.isActive ? 'Activa' : 'Inactiva'),
                      _buildInfoRow('Creado por', 'DNI: ${competence.createdBy}'),
                    ]),
                    SizedBox(height: 24),
                    _buildRegisteredUsersSection(competence),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFFD50000),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisteredUsersSection(CompetenceManageData competence) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.people, color: Color(0xFFD50000), size: 24),
            SizedBox(width: 12),
            Text(
              'Usuarios Inscritos (${competence.registeredUsers.length})',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        if (competence.registeredUsers.isEmpty)
          Container(
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.person_off,
                    size: 48,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Sin inscripciones',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...competence.registeredUsers.map((user) => Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      '#${user.registrationNumber}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
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
                        user.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'DNI: ${user.dni}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
      ],
    );
  }

  void _showCreateEditDialog(CompetenceManageData? competence) {
    final isEdit = competence != null;
    final nameController = TextEditingController(text: competence?.name ?? '');
    final turnsController = TextEditingController(text: competence?.nTurns.toString() ?? '');
    DateTime selectedDate = competence?.competitionDate ?? DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(competence?.competitionDate ?? DateTime.now());
    bool isActive = competence?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            isEdit ? 'Editar Competencia' : 'Nueva Competencia',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(nameController, 'Nombre', Icons.flag),
                SizedBox(height: 16),
                _buildDialogTextField(turnsController, 'Número de Vueltas', Icons.loop, isNumber: true),
                SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.calendar_today, color: Color(0xFFD50000)),
                  title: Text('Fecha', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  subtitle: Text(_formatDate(selectedDate), style: TextStyle(color: Colors.white, fontSize: 14)),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (date != null) {
                      setDialogState(() {
                        selectedDate = date;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.access_time, color: Color(0xFFD50000)),
                  title: Text('Hora', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                  subtitle: Text(selectedTime.format(context), style: TextStyle(color: Colors.white, fontSize: 14)),
                  onTap: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                    );
                    if (time != null) {
                      setDialogState(() {
                        selectedTime = time;
                      });
                    }
                  },
                ),
                SwitchListTile(
                  title: Text('Activa', style: TextStyle(color: Colors.white)),
                  value: isActive,
                  activeColor: Color(0xFFD50000),
                  onChanged: (value) {
                    setDialogState(() {
                      isActive = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar', style: TextStyle(color: Colors.white.withOpacity(0.6))),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || turnsController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor completa todos los campos'), backgroundColor: Colors.red),
                  );
                  return;
                }
                
                final finalDate = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                setState(() {
                  if (isEdit) {
                    competence.name = nameController.text;
                    competence.nTurns = int.parse(turnsController.text);
                    competence.competitionDate = finalDate;
                    competence.isActive = isActive;
                  } else {
                    competences.add(CompetenceManageData(
                      id: competences.length + 1,
                      externalId: 'comp-${(competences.length + 1).toString().padLeft(3, '0')}',
                      name: nameController.text,
                      competitionDate: finalDate,
                      nTurns: int.parse(turnsController.text),
                      isActive: isActive,
                      createdBy: '0912345678',
                      registeredUsers: [],
                    ));
                  }
                });
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? 'Competencia actualizada' : 'Competencia creada'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFD50000),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isEdit ? 'Actualizar' : 'Crear', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTextField(TextEditingController controller, String label, IconData icon, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: Color(0xFFD50000)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFD50000)),
        ),
      ),
    );
  }

  void _showDeleteDialog(CompetenceManageData competence) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text(
              'Confirmar Eliminación',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¿Estás seguro de que deseas eliminar la competencia?',
              style: TextStyle(color: Colors.white.withOpacity(0.8)),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    competence.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ID: ${competence.externalId}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  if (competence.registeredUsers.isNotEmpty) ...[
                    SizedBox(height: 8),
                    Text(
                      '⚠️ Tiene ${competence.registeredUsers.length} usuario(s) inscrito(s)',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Esta acción no se puede deshacer.',
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                competences.removeWhere((c) => c.id == competence.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Competencia eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
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

class CompetenceManageData {
  final int id;
  final String externalId;
  String name;
  DateTime competitionDate;
  int nTurns;
  bool isActive;
  final String createdBy;
  List<RegisteredUser> registeredUsers;

  CompetenceManageData({
    required this.id,
    required this.externalId,
    required this.name,
    required this.competitionDate,
    required this.nTurns,
    required this.isActive,
    required this.createdBy,
    required this.registeredUsers,
  });
}

class RegisteredUser {
  final String dni;
  final String name;
  final int registrationNumber;

  RegisteredUser({
    required this.dni,
    required this.name,
    required this.registrationNumber,
  });
}