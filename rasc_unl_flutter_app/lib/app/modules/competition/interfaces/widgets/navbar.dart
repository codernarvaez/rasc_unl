import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rasc_unl_flutter_app/app/modules/sync/presentation/widgets/sync_indicator_widget.dart';

class ModernNavBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String logoPath;
  final Color backgroundColor;

  const ModernNavBar({
    super.key,
    required this.logoPath,
    this.backgroundColor = const Color(0xFF2A2A2A),
  });

  @override
  ConsumerState<ModernNavBar> createState() => _ModernNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _ModernNavBarState extends ConsumerState<ModernNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.red.withOpacity(0.3), width: 1),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          '¿Estás seguro que deseas cerrar sesión?',
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red.shade700, Colors.red.shade900],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Lógica para cerrar sesión
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cerrar Sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Logo a la izquierda
              Hero(
                tag: 'app_logo',
                child: Container(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: widget.logoPath.isNotEmpty
                        ? Image.asset(widget.logoPath, fit: BoxFit.cover)
                        : Icon(Icons.flash_on, color: Colors.white, size: 50),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'RASC UNL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              // // Botón de cerrar sesión a la derecha
              // ScaleTransition(
              //   scale: _scaleAnimation,
              //   child: GestureDetector(
              //     onTapDown: (_) => _animationController.forward(),
              //     onTapUp: (_) {
              //       _animationController.reverse();
              //       _showLogoutDialog();
              //     },
              //     onTapCancel: () => _animationController.reverse(),
              //     child: Container(
              //       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              //       decoration: BoxDecoration(
              //         color: Colors.white.withOpacity(0.05),
              //         borderRadius: BorderRadius.circular(12),
              //         border: Border.all(
              //           color: Color(0xFFD50000).withOpacity(0.3),
              //           width: 1,
              //         ),
              //       ),
              //       child: Row(
              //         mainAxisSize: MainAxisSize.min,
              //         children: [
              //           Icon(
              //             Icons.logout_rounded,
              //             size: 22,
              //             color: Color(0xFFD50000),
              //           ),
              //           SizedBox(width: 8),
              //           Text(
              //             'Cerrar sesión',
              //             style: TextStyle(
              //               fontSize: 14,
              //               fontWeight: FontWeight.w600,
              //               color: Colors.white,
              //               letterSpacing: 0.3,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const Spacer(),
              const SyncIndicatorWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
