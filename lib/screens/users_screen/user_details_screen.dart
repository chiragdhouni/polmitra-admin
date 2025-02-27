import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:polmitra_admin/enums/user_enums.dart';
import 'package:polmitra_admin/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetailsScreen extends StatefulWidget {
  final PolmitraUser user;

  const UserDetailsScreen({required this.user, super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late final PolmitraUser user;

  @override
  void initState() {
    super.initState();
    setState(() {
      user = widget.user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'User Details',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Email: ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                      ),
                      TextSpan(
                        text: user.email,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Role: ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                      ),
                      TextSpan(
                        text: user.role,
                        style: const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                if (user.role == UserRole.karyakarta.toString()) ...[
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Points: ",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                        ),
                        TextSpan(
                          text: '${user.points}',
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Contact: ",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: user.email,
                        style: const TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            final mailtourl = 'mailto:${user.email}';
                            final uri = Uri.parse(mailtourl);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(uri);
                            }
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Active: ",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black),
                      ),
                      TextSpan(
                        text: user.isActive ? "Yes" : "No",
                        style: TextStyle(fontSize: 14, color: user.isActive ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
