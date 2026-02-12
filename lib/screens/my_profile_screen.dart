import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/common_drawer.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: scaffoldKey),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/my-profile'),
      body: const Center(
        child: Text('My Profile Screen'),
      ),
    );
  }
}
