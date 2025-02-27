import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polmitra_admin/bloc/polls/polls_bloc.dart';
import 'package:polmitra_admin/bloc/polls/polls_event.dart';
import 'package:polmitra_admin/bloc/polls/polls_state.dart';
import 'package:polmitra_admin/models/poll.dart';
import 'package:polmitra_admin/screens/polls_screen/poll_details_screen.dart';
import 'package:polmitra_admin/utils/app_colors.dart';
import 'package:polmitra_admin/utils/text_builder.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});

  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  PersistentBottomSheetController? _pollBottomSheetController;

  @override
  void initState() {
    super.initState();
    _loadPolls();
  }

  void _loadPolls() {
    BlocProvider.of<PollBloc>(context).add(LoadPolls());
  }

  bool isActive = false;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PollBloc, PollState>(
        builder: (context, state) {
          if (state is PollLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PollsLoaded) {
            return Column(
              children: [
                _buildFilterBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildPollsList(_filterPolls(state.polls)),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("Error loading polls"),
            );
          }
        },
      ),
    );
  }

  List<Poll> _filterPolls(List<Poll> pollsEntry) {
    return pollsEntry.where((poll) {
      print(poll.toMap());
      bool matchesSearchQuery =
          poll.question.toLowerCase().contains(_searchQuery);
      return matchesSearchQuery;
    }).toList();
  }

  Widget _buildPollsList(List<Poll> pollsEntry) {
    return ListView.builder(
      itemCount: pollsEntry.length,
      itemBuilder: (context, index) {
        Poll poll = pollsEntry[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.normalWhite,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkGreyColor,
                    offset: const Offset(0.0, 1.5), //(x,y)
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: _buildPollCard(index, poll)),
        );
      },
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            width: 260,
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by question',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollCard(int index, Poll poll) {
    final uploadedBy = poll.neta?.email ?? poll.netaId;

    return ListTile(
      title: TextBuilder.getText(
          text: poll.question, fontWeight: FontWeight.bold, fontSize: 16),
      subtitle: TextBuilder.getText(
          text: uploadedBy, fontWeight: FontWeight.normal, fontSize: 12),
      leading: TextBuilder.getText(
          text: "${index + 1}", fontWeight: FontWeight.bold, fontSize: 16),
      trailing: Switch(
        activeColor: Colors.blue,
        trackColor: MaterialStateColor.resolveWith((states) => Colors.grey),
        value: poll.isActive,
        onChanged: (value) {
          BlocProvider.of<PollBloc>(context)
              .add(UpdatePollActiveStatus(poll.id, value));
        },
      ),
      onTap: () => _showPollDetailsBottomSheet(poll, uploadedBy),
    );
  }

  void _showPollDetailsBottomSheet(Poll poll, String uploadedBy) {
    _pollBottomSheetController = showBottomSheet(
      context: context,
      builder: (context) {
        return PollDetailsScreen(poll: poll, uploadedBy: uploadedBy);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pollBottomSheetController?.close();
  }
}
