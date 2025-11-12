import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum UserRole { admin, user, moderator }

class ManageUsersPage extends StatefulWidget {
  @override
  _ManageUsersPageState createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  UserRole? _filterRole;
  bool? _filterActive;

  // Simulación de datos
  List<UserData> users = [
    UserData(
      id: 1,
      dni: '0912345678',
      name: 'Juan',
      lastName: 'Pérez',
      email: 'juan.perez@email.com',
      rol: UserRole.admin,
      isActive: true,
      birthDate: DateTime(1990, 5, 15),
    ),
    UserData(
      id: 2,
      dni: '0923456789',
      name: 'María',
      lastName: 'García',
      email: 'maria.garcia@email.com',
      rol: UserRole.user,
      isActive: true,
      birthDate: DateTime(1995, 8, 22),
    ),
    UserData(
      id: 3,
      dni: '0934567890',
      name: 'Carlos',
      lastName: 'López',
      email: 'carlos.lopez@email.com',
      rol: UserRole.moderator,
      isActive: false,
      birthDate: DateTime(1988, 3, 10),
    ),
    UserData(
      id: 4,
      dni: '0945678901',
      name: 'Ana',
      lastName: 'Martínez',
      email: 'ana.martinez@email.com',
      rol: UserRole.user,
      isActive: true,
      birthDate: DateTime(1992, 11, 5),
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserData> get filteredUsers {
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
              Expanded(child: _buildUsersList()),
            ],
          ),
        ),
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
            'Gestionar Usuarios',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFFD50000).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFD50000)),
            ),
            child: Text(
              '${users.length} usuarios',
              style: TextStyle(
                color: Color(0xFFD50000),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
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

  Widget _buildStats() {
    int activeUsers = users.where((u) => u.isActive).length;
    int admins = users.where((u) => u.rol == UserRole.admin).length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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

  Widget _buildUsersList() {
    List<UserData> displayUsers = filteredUsers;

    if (displayUsers.isEmpty) {
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
      padding: EdgeInsets.all(20),
      itemCount: displayUsers.length,
      itemBuilder: (context, index) {
        return _buildUserCard(displayUsers[index]);
      },
    );
  }

  Widget _buildUserCard(UserData user) {
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
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
                        fontSize: 20,
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
                        '${user.name} ${user.lastName}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.email,
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Cambiar Rol',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: UserRole.values.map((role) {
            return RadioListTile<UserRole>(
              title: Text(_getRoleLabel(role), style: TextStyle(color: Colors.white)),
              value: role,
              groupValue: user.rol,
              activeColor: Color(0xFFD50000),
              onChanged: (value) {
                setState(() {
                  user.rol = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _toggleUserStatus(UserData user) {
    setState(() {
      user.isActive = !user.isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(user.isActive ? 'Usuario activado' : 'Usuario desactivado'),
        backgroundColor: user.isActive ? Colors.green : Colors.red,
      ),
    );
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