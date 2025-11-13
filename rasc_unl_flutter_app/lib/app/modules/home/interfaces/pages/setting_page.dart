import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isSaving = false;

  String _formatDate(DateTime? date) {
    if (date == null) return 'No especificado';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final mainRepository = ref.watch(rascUNLMainProvider);

    // Si no hay usuario logueado, mostrar pantalla de carga
    if (currentUser == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2A2A2A),
                Color(0xFF1A1A1A),
              ],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD50000)),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A2A2A),
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: 20),
              
              // -------------------
              // Sección de Usuario
              // -------------------
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD50000).withOpacity(0.2),
                      Color(0xFF8B0000).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color(0xFFD50000).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFD50000).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Nombre completo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '${currentUser.name} ${currentUser.lastName}',
                            style: TextStyle(
                              fontSize: 22, // Ajusta el tamaño para evitar desbordamientos
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis, // Evita desbordamientos de texto
                          ),
                        ),
                        SizedBox(width: 12), // Espaciado más amplio para mejor separación
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            onPressed: () => _showEditProfileDialog(currentUser, mainRepository),
                            icon: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(10),
                            constraints: BoxConstraints(),
                            tooltip: 'Editar perfil', // Mejora la accesibilidad
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(width: 6),
                        Text(
                          currentUser.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 8),
                    
                    // Fecha de nacimiento
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cake_outlined,
                          size: 16,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(width: 6),
                        Text(
                          _formatDate(currentUser.birthDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // -------------------
              // Sección de Soporte
              // -------------------
              _buildSectionHeader('Soporte'),
              _buildMenuTile(
                icon: Icons.help_outline,
                title: 'Ayuda y Soporte',
                subtitle: 'FAQ, contacto',
                onTap: () {
                  // Navegar a ayuda
                },
              ),
              _buildMenuTile(
                icon: Icons.info_outline,
                title: 'Acerca de',
                subtitle: 'Versión 1.0.0',
                onTap: _showAboutDialog,
              ),
              
              SizedBox(height: 16),
              
              // -------------------
              // Cerrar Sesión
              // -------------------
              _buildMenuTile(
                icon: Icons.logout,
                title: 'Cerrar Sesión',
                subtitle: 'Salir de tu cuenta',
                onTap: () {
                  _showLogoutDialog();
                },
                isDestructive: true,
              ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD50000),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDestructive 
                ? Colors.red.withOpacity(0.1)
                : Color(0xFFD50000).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : Color(0xFFD50000),
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.white.withOpacity(0.3),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Color(0xFFD50000).withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFD50000)),
            SizedBox(width: 12),
            Text(
              'Acerca de',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Versión', '1.0.0'),
            SizedBox(height: 12),
            _buildInfoRow('Plataforma', 'Flutter'),
            SizedBox(height: 12),
            _buildInfoRow('Copyright', '© 2025 Tu Empresa'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cerrar',
              style: TextStyle(
                color: Color(0xFFD50000),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(dynamic currentUser, dynamic mainRepository) async {
    final TextEditingController nameController = TextEditingController(text: currentUser.name);
    final TextEditingController lastNameController = TextEditingController(text: currentUser.lastName);
    DateTime? selectedDate = currentUser.birthDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Color(0xFFD50000).withOpacity(0.3),
              width: 1,
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.edit, color: Color(0xFFD50000)),
              SizedBox(width: 12),
              Text(
                'Editar Perfil',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogTextField(
                  controller: nameController,
                  label: 'Nombres',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16),
                _buildDialogTextField(
                  controller: lastNameController,
                  label: 'Apellidos',
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.cake_outlined, color: Colors.white.withOpacity(0.5)),
                    title: Text(
                      'Fecha de Nacimiento',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      selectedDate != null 
                          ? _formatDate(selectedDate)
                          : 'Seleccionar fecha',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime(2000, 1, 1),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Color(0xFFD50000),
                                onPrimary: Colors.white,
                                surface: Color(0xFF2A2A2A),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setDialogState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isSaving 
                      ? [Colors.grey, Colors.grey.shade700]
                      : [Color(0xFFD50000), Color(0xFF8B0000)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: _isSaving ? null : () async {
                  // Validaciones
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('El nombre es requerido'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    return;
                  }

                  if (lastNameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('El apellido es requerido'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _isSaving = true;
                  });

                  try {
                    // Crear usuario actualizado
                    final updatedUser = UserModel(
                      id: currentUser.id,
                      dni: currentUser.dni,
                      rol: currentUser.rol,
                      name: nameController.text.trim(),
                      lastName: lastNameController.text.trim(),
                      email: currentUser.email,
                      isActive: currentUser.isActive,
                      birthDate: selectedDate,
                      createdAt: currentUser.createdAt,
                      updatedAt: DateTime.now(),
                    );

                    // Actualizar en el repositorio
                    await mainRepository.userRepository.updateUser(updatedUser);

                    // Actualizar el estado global del usuario
                    ref.read(currentUserProvider.notifier).setUser(updatedUser);

                    Navigator.pop(context);

                    // Mostrar confirmación
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.white),
                            SizedBox(width: 12),
                            Text('Perfil actualizado correctamente'),
                          ],
                        ),
                        backgroundColor: Color(0xFFD50000),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al actualizar perfil: $e'),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } finally {
                    setState(() {
                      _isSaving = false;
                    });
                  }
                },
                child: _isSaving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.5)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro que deseas cerrar sesión?',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Lógica para cerrar sesión
              },
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}