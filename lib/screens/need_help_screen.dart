import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/common_drawer.dart';

class NeedHelpScreen extends StatelessWidget {
  const NeedHelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: scaffoldKey),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/need-help'),
      body: const Center(
        child: Text('Need Help Screen'),
      ),
    );
  }
}
