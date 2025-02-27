import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polmitra_admin/bloc/users/user_bloc.dart';
import 'package:polmitra_admin/bloc/users/user_event.dart';
import 'package:polmitra_admin/bloc/users/user_state.dart';
import 'package:polmitra_admin/enums/filter_options.dart';
import 'package:polmitra_admin/enums/user_enums.dart';
import 'package:polmitra_admin/models/user.dart';
import 'package:polmitra_admin/screens/users_screen/user_details_screen.dart';
import 'package:polmitra_admin/utils/text_builder.dart';

// Stateful widget for the Users Screen
class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Initial filter options
  FilterRoleOption _filterRoleOption = FilterRoleOption.all;
  FilterActiveOption _filterActive = FilterActiveOption.all;
  final TextEditingController _searchController = TextEditingController();

  PersistentBottomSheetController? _userDetailsBottomSheetController;
  List<PolmitraUser> users = [];
  List<PolmitraUser> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Load users at startup
    _searchController.addListener(_filterUsers);
  }

  // Method to load users via the UserBloc
  void _loadUsers() {
    BlocProvider.of<UserBloc>(context).add(LoadUsers());
  }

  void _filterUsers() {
    setState(() {
      filteredUsers = _applyFilters();
    });
  }

  // Method to filter the list of users based on role and active status
  List<PolmitraUser> _applyFilters() {
    String searchQuery = _searchController.text.trim().toLowerCase();
    return users.where((user) {
      bool searchMatches =
          user.name.toLowerCase().contains(searchQuery) || user.email.toLowerCase().contains(searchQuery);

      bool roleMatches;
      switch (_filterRoleOption) {
        case FilterRoleOption.superadmin:
          roleMatches = user.role == UserRole.superadmin.toString();
          break;
        case FilterRoleOption.neta:
          roleMatches = user.role == UserRole.neta.toString();
          break;
        case FilterRoleOption.karyakarta:
          roleMatches = user.role == UserRole.karyakarta.toString();
          break;
        case FilterRoleOption.all:
        default:
          roleMatches = true;
      }

      bool activeMatches;
      switch (_filterActive) {
        case FilterActiveOption.active:
          activeMatches = user.isActive;
          break;
        case FilterActiveOption.inactive:
          activeMatches = !user.isActive;
          break;
        case FilterActiveOption.all:
        default:
          activeMatches = true;
      }

      return roleMatches && activeMatches && searchMatches;
    }).toList();
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          labelText: 'Search by name or email',
          labelStyle: TextStyle(fontSize: 14),
          suffixIcon: Icon(Icons.search),
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _filterWidgetsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<FilterActiveOption>(
          value: _filterActive,
          onChanged: (value) {
            setState(() {
              _filterActive = value ?? FilterActiveOption.all;
            });
          },
          items: FilterActiveOption.values.map((option) {
            String text = option == FilterActiveOption.all
                ? 'All Users'
                : option == FilterActiveOption.active
                    ? 'Active Users'
                    : 'Inactive Users';
            return DropdownMenuItem(
              value: option,
              child: Text(text),
            );
          }).toList(),
        ),
        const SizedBox(width: 20),
        DropdownButton<FilterRoleOption>(
          value: _filterRoleOption,
          onChanged: (value) {
            setState(() {
              _filterRoleOption = value ?? FilterRoleOption.all;
            });
          },
          items: FilterRoleOption.values.map((option) {
            String text = option.toString().split('.').last.capitalize();
            return DropdownMenuItem(
              value: option,
              child: Text(text),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        buildWhen: (previous, current) {
          return current is UserLoading || current is UsersLoaded || current is UserError;
        },
        listener: (context, state) {
          if (state is UserError) {
            // Display error message
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error loading users: ${state.message}")));
          } else if (state is UsersLoaded) {
            // Display success message
            setState(() {
              users = state.users;
              filteredUsers = _applyFilters();
            });
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsersLoaded) {
            _applyFilters();
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  /// search field
                  _searchField(),

                  /// Display the filter options
                  _filterWidgetsRow(),

                  /// Display the list of users
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        PolmitraUser user = filteredUsers[index];
                        return ListTile(
                          title: TextBuilder.getText(text: user.name, fontWeight: FontWeight.bold, fontSize: 16),
                          subtitle: Text(user.email),
                          leading: const CircleAvatar(
                            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                          ),
                          trailing: Switch(
                            activeColor: Colors.blue,
                            trackColor: MaterialStateColor.resolveWith((states) => Colors.grey),
                            value: user.isActive,
                            onChanged: (value) {
                              // Update user's active status
                              BlocProvider.of<UserBloc>(context).add(UpdateUserActiveStatus(user.uid, value));
                            },
                          ),
                          onTap: () => _showUserDetailsBottomSheet(user),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is UserError) {
            // Display error message
            return Center(child: Text("Error loading users: ${state.message}"));
          } else {
            // Display message when there is no specific state
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }

  void _showUserDetailsBottomSheet(PolmitraUser user) {
    _userDetailsBottomSheetController = showBottomSheet(
      context: context,
      builder: (context) {
        return UserDetailsScreen(user: user);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _userDetailsBottomSheetController?.close();
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
