import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polmitra_admin/bloc/auth/auth_bloc.dart';
import 'package:polmitra_admin/bloc/auth/auth_event.dart';
import 'package:polmitra_admin/bloc/auth/auth_state.dart';
import 'package:polmitra_admin/screens/home_screen/home_screen.dart';
import 'package:polmitra_admin/services/prefs_services.dart';
import 'package:polmitra_admin/utils/border_provider.dart';
import 'package:polmitra_admin/utils/app_colors.dart';
import 'package:polmitra_admin/utils/text_builder.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final double _formLabelFontSize = 16.0;
  final _emailController = TextEditingController(text: "admin@gmail.com");
  final _passwordController = TextEditingController(text: "admin@123");
  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null && mounted) {
      Future.delayed(Durations.medium1).then(
        (value) => _navigateToHomeScreen(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          await PrefsService.setUserId(state.user.uid);
          await PrefsService.setLoginStatus(true);
          await PrefsService.setRole(state.user.role);
          await PrefsService.saveUser(state.user);
          _navigateToHomeScreen();
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset('assets/polmitra.jpg')),
                  const SizedBox(height: 40),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextBuilder.getTextStyle(
                          fontSize: _formLabelFontSize),
                      border: BorderProvider.createBorder(),
                      enabledBorder: BorderProvider.createBorder(),
                      focusedBorder: BorderProvider.createBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                    controller: _emailController,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextBuilder.getTextStyle(
                          fontSize: _formLabelFontSize),
                      border: BorderProvider.createBorder(),
                      enabledBorder: BorderProvider.createBorder(),
                      focusedBorder: BorderProvider.createBorder(),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      fixedSize: const Size(150, 45),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      backgroundColor: AppColors.vibrantSaffron,
                    ),
                    child: TextBuilder.getText(
                        text: "Login",
                        color: AppColors.normalWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    onPressed: () async {
                      // if (_formKey.currentState!.validate()) {
                      //   _formKey.currentState!.save();
                      //   // Perform login action
                      //   print('Email: $_email, Password: $_password');
                      // }
                      final bloc = context.read<AuthBloc>();
                      await PrefsService.clear();
                      bloc.add(LoginRequested(
                          email: _emailController.text,
                          password: _passwordController.text));
                      // _navigateToHomeScreen();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHomeScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomeScreen()));
  }
}
