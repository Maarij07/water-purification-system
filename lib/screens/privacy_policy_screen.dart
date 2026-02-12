import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/common_drawer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: scaffoldKey),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/privacy-policy'),
      body: const Center(
        child: Text('Privacy Policy Screen'),
      ),
    );
  }
}
