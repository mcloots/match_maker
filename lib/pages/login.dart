import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isRegistering = false;
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // LIVE W2-05: Submit login or registration
  Future<void> _submit() async {
    if (isLoading || !formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final email = emailController.text;
      final password = passwordController.text;

      if(isRegistering) {
        await authService.register(email: email, password: password);
      } else {
        await authService.signIn(email: email, password: password);
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        errorMessage = error.message ?? 'Aanmelden mislukt';
      });
    } catch (_) {
      setState(() {
        errorMessage = "Er ging iets mis. Probeer opnieuw";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    isRegistering ? 'Maak een account' : 'Welkom bij Match Maker',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: emailController,
                    enabled: !isLoading,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                        return 'Vul een geldig e-mailadres in.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    enabled: !isLoading,
                    obscureText: true,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: const InputDecoration(labelText: 'Wachtwoord'),
                    validator: (value) => (value ?? '').length < 6
                        ? 'Gebruik minstens zes tekens.'
                        : null,
                  ),
                  if (errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: Text(
                      isLoading
                          ? 'Even wachten...'
                          : isRegistering ? 'Registreren' : 'Aanmelden',
                    ),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(() {
                            isRegistering = !isRegistering;
                            errorMessage = null;
                          }),
                    child: Text(
                      isRegistering
                          ? 'Al een account? Meld je aan'
                          : 'Nog geen account? Registreer',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
