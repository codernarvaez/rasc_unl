import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/competition/domain/models/competition_registration_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';
import 'package:uuid/uuid.dart';

class ParticipantFormDialog extends ConsumerStatefulWidget {
  final String competenceId;
  final CompetitionRegistrationModel? participantToEdit;

  const ParticipantFormDialog({
    Key? key,
    required this.competenceId,
    this.participantToEdit,
  }) : super(key: key);

  @override
  ConsumerState<ParticipantFormDialog> createState() => _ParticipantFormDialogState();
}

class _ParticipantFormDialogState extends ConsumerState<ParticipantFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _dorsalController = TextEditingController();
  final _nameController = TextEditingController();
  final _nParticipantsController = TextEditingController();
  
  List<UserModel> _moderators = [];
  UserModel? _selectedModerator;
  bool _isLoadingModerators = true;

  bool get isEditing => widget.participantToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _dorsalController.text = widget.participantToEdit!.dorsalNumber;
      _nameController.text = widget.participantToEdit!.name;
      _nParticipantsController.text =
          widget.participantToEdit!.nParticipants.toString();
    } else {
      _nParticipantsController.text = '1';
    }
    _loadModerators();
  }

  Future<void> _loadModerators() async {
    setState(() => _isLoadingModerators = true);
    
    try {
      final repository = ref.read(rascUNLMainProvider);
      final allUsers = await repository.userRepository.getAllUsers();
      
      // Filtrar solo moderadores activos
      final moderators = allUsers.where((user) => 
        user.role == 'MODERATOR' && user.isActive
      ).toList();
      
      // Ordenar por nombre
      moderators.sort((a, b) => 
        '${a.firstName} ${a.lastName}'.compareTo('${b.firstName} ${b.lastName}')
      );
      
      if (mounted) {
        setState(() {
          _moderators = moderators;
          _isLoadingModerators = false;
          
          // Si estamos editando, seleccionar el moderador actual
          if (isEditing) {
            _selectedModerator = moderators.firstWhere(
              (m) => m.dni == widget.participantToEdit!.userDni,
              orElse: () => moderators.first,
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingModerators = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar moderadores: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _dorsalController.dispose();
    _nameController.dispose();
    _nParticipantsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedModerator == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar un moderador'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final registration = CompetitionRegistrationModel(
      id: isEditing ? widget.participantToEdit!.id : const Uuid().v4(),
      dorsalNumber: _dorsalController.text.trim(),
      name: _nameController.text.trim(),
      nParticipants: int.parse(_nParticipantsController.text.trim()),
      userDni: _selectedModerator!.dni,
      competenceId: widget.competenceId,
      createdAt: isEditing
          ? widget.participantToEdit!.createdAt
          : DateTime.now(),
      updatedAt: DateTime.now(),
      syncStatus: 'pending',
      version: isEditing ? widget.participantToEdit!.version + 1 : 1,
      isDeleted: false,
    );

    Navigator.of(context).pop(registration);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildModeratorSelector(),
                  const SizedBox(height: 20),
                  _buildDorsalField(),
                  const SizedBox(height: 20),
                  _buildNameField(),
                  const SizedBox(height: 20),
                  _buildNParticipantsField(),
                  const SizedBox(height: 32),
                  _buildActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFD50000), Color(0xFF8B0000)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isEditing ? Icons.edit : Icons.person_add,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing
                    ? 'Editar Participante'
                    : 'Registrar Participante',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                isEditing
                    ? 'Modifica los datos del participante'
                    : 'Completa el formulario para registrar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildModeratorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person_pin, color: Color(0xFFD50000), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Moderador a Cargo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_isLoadingModerators)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFD50000),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Cargando moderadores...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          )
        else if (_moderators.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No hay moderadores disponibles',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          )
        else
          DropdownButtonFormField<UserModel>(
            value: _selectedModerator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFD50000), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              prefixIcon: Icon(
                Icons.supervisor_account,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            dropdownColor: const Color(0xFF2A2A2A),
            style: const TextStyle(color: Colors.white, fontSize: 16),
            hint: Text(
              'Selecciona un moderador',
              style: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            items: _moderators.map((moderator) {
              return DropdownMenuItem<UserModel>(
                value: moderator,
                child: Text(
                  '${moderator.firstName} ${moderator.lastName}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (UserModel? value) {
              setState(() {
                _selectedModerator = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Debes seleccionar un moderador';
              }
              return null;
            },
          ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            'Moderador responsable de este equipo',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDorsalField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.tag, color: Color(0xFFD50000), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Número de Dorsal',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _dorsalController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Ej: 101',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD50000), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            prefixIcon: Icon(
              Icons.numbers,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El número de dorsal es requerido';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.badge, color: Color(0xFFD50000), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Nombre del Equipo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: 'Ej: Equipo Rocket',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD50000), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            prefixIcon: Icon(
              Icons.groups,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El nombre del equipo es requerido';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNParticipantsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.people, color: Color(0xFFD50000), size: 20),
            const SizedBox(width: 8),
            const Text(
              'Número de Participantes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nParticipantsController,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Ej: 3',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFD50000), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            prefixIcon: Icon(
              Icons.format_list_numbered,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El número de participantes es requerido';
            }
            final number = int.tryParse(value.trim());
            if (number == null || number < 1) {
              return 'Debe ser un número mayor a 0';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            'Indica cuántas personas forman este equipo',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD50000),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isEditing ? Icons.save : Icons.add, size: 20),
              const SizedBox(width: 8),
              Text(
                isEditing ? 'Guardar' : 'Registrar',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
