import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:polmitra_admin/models/poll.dart';
import 'package:polmitra_admin/utils/text_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class PollDetailsScreen extends StatefulWidget {
  final Poll poll;
  final String uploadedBy;

  const PollDetailsScreen({required this.poll, required this.uploadedBy, super.key});

  @override
  State<PollDetailsScreen> createState() => _PollDetailsScreenState();
}

class _PollDetailsScreenState extends State<PollDetailsScreen> {
  late final Poll _poll;
  late final String _uploadedBy;

  @override
  void initState() {
    super.initState();
    setState(() {
      _poll = widget.poll;
      _uploadedBy = widget.uploadedBy;
    });
  }

  @override
  Widget build(BuildContext context) {
    var totalResponses = _poll.responses.values.reduce((sum, element) => sum + element);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          'Poll Details',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Active: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: _poll.isActive ? "Yes" : "No",
                          style: TextStyle(color: _poll.isActive ? Colors.green : Colors.red)),
                    ],
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Uploaded By: ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: _uploadedBy,
                          style: const TextStyle(color: Colors.blue),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final scaffold = ScaffoldMessenger.of(context);
                              final mailtourl = 'mailto:$_uploadedBy';
                              final uri = Uri.parse(mailtourl);
                              if (await canLaunchUrl(uri)) {
                                launchUrl(uri);
                              } else {
                                scaffold.showSnackBar(const SnackBar(content: Text("Could not launch email client")));
                              }
                            }),
                    ],
                  ),
                ),

                /// totalResponses is the sum of all responses for the poll.
                TextBuilder.getText(
                  text: "Total Responses: $totalResponses",
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                const SizedBox(height: 10),

                /// Display the options and their respective percentages.
                Column(
                    children: _poll.options.map(
                  (option) {
                    final voteCount = _poll.responses[option.toLowerCase()] ??
                        0; // Ensure option string matches response keys exactly.
                    final double percentage = totalResponses > 0 ? (voteCount / totalResponses) : 0.0;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("$option: ${(percentage * 100).toStringAsFixed(2)}%"),
                        SizedBox(
                          height: 10,
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 10), // Spacing between bars
                      ],
                    );
                  },
                ).toList())
              ]),
        ),
      ),
    );
  }
}
