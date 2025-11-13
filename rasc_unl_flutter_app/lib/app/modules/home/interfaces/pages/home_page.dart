import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/user/init_run_clock.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/setting_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/actions_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/pages/user/init_run_clock_page.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/widgets/buttonNavigatorBar.dart';
import 'package:rasc_unl_flutter_app/app/modules/home/interfaces/widgets/navbar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIncex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      const InitRunClockPage(),
      const ActionsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ModernNavBar(
        // backgroundColor: Colors.white,
        logoPath: 'assets/images/logo.png',
      ),
      body: SafeArea(child: _pages[_currentIncex]),
      bottomNavigationBar: ButtonNavigatorBar(
        iconsList: [
          Icons.home,
          Icons.list,
          Icons.settings,
        ],

        onTap: (indexSelect) {
          setState(() {
            _currentIncex = indexSelect;
          });
        },
      ),
    );
  }
}
