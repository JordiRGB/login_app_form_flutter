import 'package:flutter/material.dart';
import 'package:productos_app_flutter/ui/input_decorations.dart';
import 'package:productos_app_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/login_form_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackgound(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),

              // ✅ Envolvemos todo el CardContainer con el Provider
              ChangeNotifierProvider(
                create: (_) => LoginFormProviderScreen(),
                child: CardContainer(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text('Login',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 30),
                      _LoginForm(), // ✅ Solo una instancia aquí
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),
              const Text(
                'Crear cuenta',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProviderScreen>(context);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: loginForm.formKey,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'jon.do@gmail.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value ?? '')
                  ? null
                  : 'El valor ingresado no es un correo';
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: '********',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_open_outlined,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'La contraseña debe de ser de 6 caracteres';
            },
          ),
          const SizedBox(height: 20),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: loginForm.isloading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!loginForm.isValidForm()) return;
                    loginForm.isLoading = true;
                    await Future.delayed(const Duration(seconds: 2));
                    Navigator.pushReplacementNamed(
                      // ignore: use_build_context_synchronously
                      context,
                      'home',
                    );
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              child: Text(
                loginForm.isloading ? 'Espere...' : 'Ingresar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
