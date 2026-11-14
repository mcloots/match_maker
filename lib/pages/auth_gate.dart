import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home.dart';
import 'login.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

// LIVE W2-06: Choose the page from the auth stream
class _AuthGateState extends State<AuthGate> {
  final Stream<User?> authStream = AuthService().authStateChanges;

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: authStream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text('Aanmelden niet beschikbaar. Herstart de app'),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      if(snapshot.hasData) {
        return HomePage(key: ValueKey(snapshot.data!.uid));
      }

      return LoginPage();
    },
  );
}
