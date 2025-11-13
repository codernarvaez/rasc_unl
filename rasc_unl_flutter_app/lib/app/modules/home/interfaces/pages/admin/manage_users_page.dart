import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/auth/domain/models/user_model.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/admin/forms/user_form_dialog.dart';
import 'package:rasc_unl_flutter_app/app/modules/main_repository.dart';
import 'package:rasc_unl_flutter_app/core/dependencies/dependencies_inyection.dart';

enum UserRole { admin, user, moderator }

class ManageUsersPage extends ConsumerStatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends ConsumerState<ManageUsersPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  UserRole? _filterRole;
  bool? _filterActive;
  List<UserData>? _usersList;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
    });
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(rascUNLMainProvider);
      final users = await _fetchUsers(repository);
      if (mounted) {
        setState(() {
          _usersList = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _usersList = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<UserData>> _fetchUsers(MainRepository repository) async {
    final userModels = await repository.userRepository.getAllUsers();
    return userModels.map((userModel) {
      // Mapear UserRoleType a UserRole
      final role = userModel.rol == UserRoleType.ADMINISTRATOR
          ? UserRole.admin
          : UserRole.user;
      
      return UserData(
        id: userModel.id,
        dni: userModel.dni,
        name: userModel.name,
        lastName: userModel.lastName,
        email: userModel.email,
        rol: role,
        isActive: userModel.isActive,
        birthDate: userModel.birthDate ?? DateTime.now(),
      );
    }).toList();
  }

  List<UserData> _filterUsers(List<UserData> users) {
    return users.where((user) {
      bool matchesSearch = _searchQuery.isEmpty ||
          user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.lastName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.dni.contains(_searchQuery) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesRole = _filterRole == null || user.rol == _filterRole;
      bool matchesActive = _filterActive == null || user.isActive == _filterActive;

      return matchesSearch && matchesRole && matchesActive;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    MainRepository? repository;
    
    try {
      repository = ref.watch(rascUNLMainProvider);
    } catch (e) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFFD50000),
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
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              _buildSearchAndFilters(),
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFD50000),
                        ),
                      )
                    : _usersList == null || _usersList!.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_outline, size: 60, color: Colors.white.withOpacity(0.3)),
                                SizedBox(height: 16),
                                Text(
                                  'No se encontraron usuarios',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          )
                        : Builder(
                            builder: (context) {
                              final filteredUsers = _filterUsers(_usersList!);
                              return Column(
                                children: [
                                  _buildStats(_usersList!),
                                  SizedBox(height: 16),
                                  Expanded(child: _buildUsersList(filteredUsers)),
                                ],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateUserDialog(repository),
        backgroundColor: Color(0xFFD50000),
        icon: Icon(Icons.person_add, color: Colors.white),
        label: Text(
          'Crear Usuario',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showCreateUserDialog(MainRepository? repository) {
    if (repository == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UserFormDialog(
        onSave: (formData) async {
          try {
            // Convertir el rol de string a UserRoleType enum
            final roleType = formData.role == 'ADMINISTRATOR'
                ? UserRoleType.ADMINISTRATOR
                : UserRoleType.COMPETITOR;

            final newUser = UserModel(
              id: DateTime.now().millisecondsSinceEpoch,
              dni: formData.dni,
              name: formData.name,
              lastName: formData.lastName,
              email: formData.email,
              rol: roleType,
              isActive: true,
              birthDate: formData.birthDate,
            );

            await repository.userRepository.insertUser(newUser);

            Navigator.of(context).pop();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Usuario creado exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              await _loadUsers(); // Recargar la lista desde la BD
            }
          } catch (e) {
            Navigator.of(context).pop();
            
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error al crear usuario: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Padding(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => context.go('/home'),
          ),
          SizedBox(width: isMobile ? 4 : 8),
          Expanded(
            child: Text(
              'Gestionar Usuarios',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFD50000).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFD50000)),
            ),
            child: Builder(
              builder: (context) {
                try {
                  final repo = ref.watch(rascUNLMainProvider);
                  return FutureBuilder<List<UserData>>(
                    future: _fetchUsers(repo),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          '...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return Text(
                          '0',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 12 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }

                      return Text(
                        '${snapshot.data!.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 12 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  );
                } catch (e) {
                  return Text(
                    '...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
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
                hintText: 'Buscar por nombre, DNI o email...',
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'Todos',
                  isSelected: _filterRole == null && _filterActive == null,
                  onTap: () {
                    setState(() {
                      _filterRole = null;
                      _filterActive = null;
                    });
                  },
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Admin',
                  isSelected: _filterRole == UserRole.admin,
                  onTap: () {
                    setState(() {
                      _filterRole = _filterRole == UserRole.admin ? null : UserRole.admin;
                    });
                  },
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Moderador',
                  isSelected: _filterRole == UserRole.moderator,
                  onTap: () {
                    setState(() {
                      _filterRole = _filterRole == UserRole.moderator ? null : UserRole.moderator;
                    });
                  },
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Usuario',
                  isSelected: _filterRole == UserRole.user,
                  onTap: () {
                    setState(() {
                      _filterRole = _filterRole == UserRole.user ? null : UserRole.user;
                    });
                  },
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Activos',
                  isSelected: _filterActive == true,
                  onTap: () {
                    setState(() {
                      _filterActive = _filterActive == true ? null : true;
                    });
                  },
                ),
                SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Inactivos',
                  isSelected: _filterActive == false,
                  onTap: () {
                    setState(() {
                      _filterActive = _filterActive == false ? null : false;
                    });
                  },
                ),
              ],
            ),
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

  Widget _buildStats(List<UserData> users) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    int activeUsers = users.where((u) => u.isActive).length;
    int admins = users.where((u) => u.rol == UserRole.admin).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.check_circle,
              value: '$activeUsers',
              label: 'Activos',
              color: Colors.green,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.admin_panel_settings,
              value: '$admins',
              label: 'Admins',
              color: Color(0xFFD50000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({required IconData icon, required String value, required String label, required Color color}) {
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

  Widget _buildUsersList(List<UserData> users) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.white.withOpacity(0.3)),
            SizedBox(height: 16),
            Text(
              'No se encontraron usuarios',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 12 : 20),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return _buildUserCard(users[index]);
      },
    );
  }

  Widget _buildUserCard(UserData user) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
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
          color: user.isActive
              ? Colors.white.withOpacity(0.1)
              : Colors.red.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isMobile ? 40 : 50,
                  height: isMobile ? 40 : 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFD50000), Color(0xFF8B0000)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${user.name[0]}${user.lastName[0]}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 16 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isMobile ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.name} ${user.lastName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: isMobile ? 11 : 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getRoleColor(user.rol).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getRoleColor(user.rol)),
                  ),
                  child: Text(
                    _getRoleLabel(user.rol),
                    style: TextStyle(
                      color: _getRoleColor(user.rol),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                IconButton(onPressed: () => _showDeleteConfirmation(user), icon: Icon(Icons.delete_forever, color: Colors.red[900])),
              ],
            ),
            SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.1)),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.badge, color: Colors.white.withOpacity(0.5), size: 16),
                SizedBox(width: 8),
                Text(
                  'DNI: ${user.dni}',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                ),
                Spacer(),
                Icon(Icons.cake, color: Colors.white.withOpacity(0.5), size: 16),
                SizedBox(width: 8),
                Text(
                  _formatDate(user.birthDate),
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    label: 'Cambiar Rol',
                    icon: Icons.swap_horiz,
                    onPressed: () => _showRoleDialog(user),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    label: user.isActive ? 'Desactivar' : 'Activar',
                    icon: user.isActive ? Icons.block : Icons.check_circle,
                    color: user.isActive ? Colors.red : Colors.green,
                    onPressed: () => _toggleUserStatus(user),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label, style: TextStyle(fontSize: 13)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Color(0xFFD50000),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showRoleDialog(UserData user) {
    MainRepository? repository;
    try {
      repository = ref.read(rascUNLMainProvider);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Base de datos no disponible'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.swap_horiz, color: Color(0xFFD50000)),
            SizedBox(width: 12),
            Text(
              'Cambiar Rol',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRoleOptionDialog(
              UserRole.admin,
              'Administrador',
              'Acceso completo al sistema',
              Icons.admin_panel_settings,
              user.rol,
              (role) async {
                try {
                  // Convertir UserRole a UserRoleType
                  final roleType = role == UserRole.admin
                      ? UserRoleType.ADMINISTRATOR
                      : UserRoleType.COMPETITOR;

                  final updatedUser = UserModel(
                    id: user.id,
                    dni: user.dni,
                    name: user.name,
                    lastName: user.lastName,
                    email: user.email,
                    rol: roleType,
                    isActive: user.isActive,
                    birthDate: user.birthDate,
                  );

                  await repository!.userRepository.updateUser(updatedUser);

                  Navigator.pop(context);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rol actualizado exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await _loadUsers(); // Recargar la lista desde la BD
                  }
                } catch (e) {
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al actualizar rol: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            SizedBox(height: 12),
            _buildRoleOptionDialog(
              UserRole.user,
              'Competidor',
              'Puede participar en competencias',
              Icons.sports_score,
              user.rol,
              (role) async {
                try {
                  final roleType = role == UserRole.admin
                      ? UserRoleType.ADMINISTRATOR
                      : UserRoleType.COMPETITOR;

                  final updatedUser = UserModel(
                    id: user.id,
                    dni: user.dni,
                    name: user.name,
                    lastName: user.lastName,
                    email: user.email,
                    rol: roleType,
                    isActive: user.isActive,
                    birthDate: user.birthDate,
                  );

                  await repository!.userRepository.updateUser(updatedUser);

                  Navigator.pop(context);
                  
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Rol actualizado exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    await _loadUsers(); // Recargar la lista desde la BD
                  }
                } catch (e) {
                  Navigator.pop(context);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al actualizar rol: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOptionDialog(
    UserRole value,
    String title,
    String description,
    IconData icon,
    UserRole currentRole,
    Function(UserRole) onTap,
  ) {
    final isSelected = currentRole == value;
    
    return InkWell(
      onTap: () => onTap(value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFFD50000).withOpacity(0.2)
              : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Color(0xFFD50000)
                : Colors.white.withOpacity(0.1),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Color(0xFFD50000)
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Color(0xFFD50000), size: 28),
          ],
        ),
      ),
    );
  }

  void _toggleUserStatus(UserData user) async {
    try {
      final repository = ref.read(rascUNLMainProvider);

      // Convertir UserRole a UserRoleType
      final roleType = user.rol == UserRole.admin
          ? UserRoleType.ADMINISTRATOR
          : UserRoleType.COMPETITOR;

      final updatedUser = UserModel(
        id: user.id,
        dni: user.dni,
        name: user.name,
        lastName: user.lastName,
        email: user.email,
        rol: roleType,
        isActive: !user.isActive, // Invertir el estado
        birthDate: user.birthDate,
      );

      await repository.userRepository.updateUser(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              !user.isActive ? 'Usuario activado exitosamente' : 'Usuario desactivado exitosamente',
            ),
            backgroundColor: !user.isActive ? Colors.green : Colors.orange,
          ),
        );
        await _loadUsers(); // Recargar la lista desde la BD
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al actualizar estado: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(UserData user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '¿Eliminar Usuario?',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estás a punto de eliminar a:',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.name} ${user.lastName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'DNI: ${user.dni}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  Text(
                    'Email: ${user.email}',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              '⚠️ Esta acción no se puede deshacer. Se eliminarán todos los datos relacionados con este usuario.',
              style: TextStyle(
                color: Colors.red.withOpacity(0.9),
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user);
            },
            icon: Icon(Icons.delete_forever),
            label: Text('Eliminar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(UserData user) async {
    try {
      final repository = ref.read(rascUNLMainProvider);

      await repository.userRepository.deleteUser(user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Usuario eliminado exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        await _loadUsers(); // Recargar la lista desde la BD
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar usuario: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.admin: return Color(0xFFD50000);
      case UserRole.moderator: return Color(0xFFFF9800);
      case UserRole.user: return Color(0xFF4CAF50);
    }
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin: return 'Admin';
      case UserRole.moderator: return 'Moderador';
      case UserRole.user: return 'Usuario';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class UserData {
  final int id;
  final String dni;
  final String name;
  final String lastName;
  final String email;
  UserRole rol;
  bool isActive;
  final DateTime birthDate;

  UserData({
    required this.id,
    required this.dni,
    required this.name,
    required this.lastName,
    required this.email,
    required this.rol,
    required this.isActive,
    required this.birthDate,
  });
}