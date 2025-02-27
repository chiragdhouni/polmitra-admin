import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polmitra_admin/bloc/auth/auth_bloc.dart';
import 'package:polmitra_admin/bloc/polls/polls_bloc.dart';
import 'package:polmitra_admin/bloc/polmitra_event/pevent_bloc.dart';
import 'package:polmitra_admin/bloc/users/user_bloc.dart';
import 'package:polmitra_admin/firebase_options.dart';
import 'package:polmitra_admin/screens/login/login_screen.dart';
import 'package:polmitra_admin/services/prefs_services.dart';
import 'package:polmitra_admin/services/user_service.dart';
import 'package:polmitra_admin/utils/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

final shorebirdCodePush = ShorebirdCodePush();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PrefsService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserService>(
          create: (context) => UserService(),
          lazy: true,
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) =>
                AuthBloc(FirebaseAuth.instance, FirebaseFirestore.instance),
            lazy: true,
          ),
          BlocProvider<EventBloc>(
            create: (context) {
              final userService =
                  Provider.of<UserService>(context, listen: false);
              return EventBloc(FirebaseFirestore.instance,
                  FirebaseStorage.instance, userService);
            },
            lazy: true,
          ),
          BlocProvider<PollBloc>(
            create: (context) {
              final userService =
                  Provider.of<UserService>(context, listen: false);
              return PollBloc(FirebaseFirestore.instance, userService);
            },
            lazy: true,
          ),
          BlocProvider<UserBloc>(
            create: (context) {
              return UserBloc(FirebaseFirestore.instance);
            },
            lazy: true,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Polmitra App',
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSwatch(backgroundColor: AppColors.normalWhite),
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
