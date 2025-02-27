import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polmitra_admin/bloc/polmitra_event/pevent_bloc.dart';
import 'package:polmitra_admin/bloc/polmitra_event/pevent_event.dart';
import 'package:polmitra_admin/bloc/polmitra_event/pevent_state.dart';
import 'package:polmitra_admin/models/event.dart';
import 'package:polmitra_admin/models/indian_state.dart';
import 'package:polmitra_admin/screens/events_screen/event_details_screen.dart';
import 'package:polmitra_admin/utils/city_state_provider.dart';
import 'package:polmitra_admin/utils/app_colors.dart';
import 'package:polmitra_admin/utils/text_builder.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // PersistentBottomSheetController? _eventBottomSheetController;

  String _searchQuery = '';
  String _selectedCity = 'All';
  String _selectedState = 'All';
  List<String> _cities = [
    'All'
  ]; // This will be populated based on the selected state
  List<String> _states = ['All']; // Populate this with the list of states

  Future<void> _fetchStatesAndCities() async {
    try {
      var states = await CityStateProvider().states;
      setState(() {
        _states = ['All'] + states.map((state) => state.statename).toList();
        _cities = ['All']; // Default cities list
      });
    } catch (e) {
      // Handle errors if necessary
      print('Error fetching states and cities: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _fetchStatesAndCities();
  }

  Future<void> _loadEvents() async {
    final bloc = context.read<EventBloc>();
    bloc.add(LoadEvents());
  }

  List<Event> _filterEvents(List<Event> eventsEntry) {
    return eventsEntry.where((event) {
      // Check if the event matches the search query, if any
      bool matchesSearchQuery = _searchQuery.isEmpty ||
          event.eventName.toLowerCase().contains(_searchQuery.toLowerCase());

      // Check if the event matches the selected state, if any
      bool matchesState =
          _selectedState == 'All' || event.state.statename == _selectedState;

      // Check if the event matches the selected city, if any
      bool matchesCity =
          _selectedCity == 'All' || event.city.cityname == _selectedCity;

      return matchesSearchQuery && matchesState && matchesCity;
    }).toList();
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          /// Name search field
          Container(
            width: 200,
            padding: const EdgeInsets.all(8),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by name',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                child: DropdownButton<String>(
                  value: _selectedState,
                  items: _states.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          width: 150,
                          child:
                              TextBuilder.getText(text: value, fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    final statesData = await CityStateProvider().states;
                    setState(() {
                      _selectedState = newValue!;

                      if (newValue != 'All') {
                        var selectedStateObj = statesData.firstWhere(
                          (state) => state.statename == newValue,
                          orElse: () => IndianState(
                              stateid: 0, statename: '', cities: []),
                        );
                        _cities = ['All'] +
                            selectedStateObj.cities
                                .map((city) => city.cityname)
                                .toList();
                      } else {
                        _cities = ['All'];
                      }
                      _selectedCity =
                          'All'; // Reset city selection when state changes
                    });
                  },
                ),
              ),
              Container(
                width: 200,
                padding: const EdgeInsets.all(8),
                child: DropdownButton<String>(
                  value: _selectedCity,
                  items: _cities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          width: 150,
                          child:
                              TextBuilder.getText(text: value, fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCity = newValue!;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventBloc, PolmitraEventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is EventsLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: _buildFilterBar(),
              ),
              Expanded(child: _buildEventList(_filterEvents(state.events))),
            ],
          );
        } else if (state is EventError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return const Center(
            child: Text('Failed to load events'),
          );
        }
      },
    );
  }

  Widget _buildEventList(List<Event> eventsEntry) {
    return ListView.builder(
      itemCount: eventsEntry.length,
      itemBuilder: (context, index) {
        final event = eventsEntry[index];
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
            child: _buildEventCard(event),
          ),
        );
      },
    );
  }

  /// Event card widget
  Widget _buildEventCard(Event event) {
    return ListTile(
        title: TextBuilder.getText(
            text: event.eventName,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            overflow: TextOverflow.ellipsis),
        subtitle: TextBuilder.getText(
            text: event.description,
            overflow: TextOverflow.ellipsis,
            fontSize: 12),

        /// Leading image
        leading: SizedBox(
          width: 80,
          child: CachedNetworkImage(
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            imageUrl: event.images.isNotEmpty
                ? event.images.first
                : 'https://via.placeholder.com/150',
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),

        /// IsActive switch
        trailing: Transform.scale(
          scale: 0.8,
          child: Switch(
            activeColor: Colors.blue,
            trackColor: WidgetStateColor.resolveWith((states) => Colors.grey),
            value: event.isActive,
            onChanged: (bool eventActiveStatus) {
              BlocProvider.of<EventBloc>(context)
                  .add(UpdateEventActiveStatus(event.id, eventActiveStatus));
            },
          ),
        ),

        /// On tap
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailsScreen(event: event),
              fullscreenDialog: true,
            )));
  }

  // void _showEventBottomSheet(Event event) {
  //   _eventBottomSheetController = showBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return EventDetailsScreen(event: event);
  //     },
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
    // _eventBottomSheetController?.close();
  }
}
