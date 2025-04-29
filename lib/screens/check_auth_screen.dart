import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:productos_app_flutter/screens/login_screen.dart';
import 'package:productos_app_flutter/screens/screens.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';

class CheckAuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: authService.readTRoken(),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) return Text('Espere...');
            if (snapshot.hasData == '') {
              Future.microtask(() => {
                    // Navigator.pushReplacementNamed(context, 'home')
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LoginScreen(),
                            transitionDuration: Duration(seconds: 0)))
                  });
            } else {
              Future.microtask(() => {
                    // Navigator.pushReplacementNamed(context, 'home')
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HomeScreen(),
                            transitionDuration: Duration(seconds: 0)))
                  });
            }

            return SizedBox.shrink(); // Return an empty widget as a fallback
          },
        ),
      ),
    );
  }
}
