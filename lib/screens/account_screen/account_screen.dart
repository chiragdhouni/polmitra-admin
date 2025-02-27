import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:polmitra_admin/screens/login/login_screen.dart';
import 'package:polmitra_admin/services/prefs_services.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Account'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListTileTheme(
                textColor: Colors.black,
                iconColor: Colors.black,
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Edit Profile'),
                      leading: const Icon(Icons.edit),
                      onTap: () {
                        // Handle edit profile action (navigation, etc.)
                      },
                    ),
                    ListTile(
                      title: const Text('Change Password'),
                      leading: const Icon(Icons.lock),
                      onTap: () {
                        // Handle change password action (navigation, etc.)
                      },
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      leading: const Icon(Icons.exit_to_app),
                      onTap: () async {
                        final navigator = Navigator.of(context);
                        // Logout logic
                        await FirebaseAuth.instance.signOut();
                        await PrefsService.clear();
                        // Navigate back to login screen or main screen
                        navigator.pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen(),));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
