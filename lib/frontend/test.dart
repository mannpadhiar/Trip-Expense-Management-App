import 'package:flutter/material.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _newUserNameController = TextEditingController();
  final _newUserEmailController = TextEditingController();
  final List<String> _selectedMembers = [];
  bool _isAddingUser = false;

  // Dark mode color palette from provided image
  final Color darkBlack = const Color(0xFF05161A);
  final Color darkTeal = const Color(0xFF072E33);
  final Color mediumTeal = const Color(0xFF0C7075);
  final Color lightTeal = const Color(0xFF0F968C);
  final Color paleBlue = const Color(0xFF6DA5C0);
  final Color grayBlue = const Color(0xFF294D61);

  // Dummy data for demonstration - replace with actual users from Supabase
  final List<Map<String, String>> _availableUsers = [
    {'id': '1', 'name': 'John Doe', 'email': 'john@example.com'},
    {'id': '2', 'name': 'Jane Smith', 'email': 'jane@example.com'},
    {'id': '3', 'name': 'Mike Johnson', 'email': 'mike@example.com'},
  ];

  @override
  void dispose() {
    _groupNameController.dispose();
    _newUserNameController.dispose();
    _newUserEmailController.dispose();
    super.dispose();
  }

  void _createGroup() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement group creation with Supabase
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: lightTeal),
              const SizedBox(width: 12),
              const Text('Creating group...'),
            ],
          ),
          backgroundColor: darkTeal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _addNewUser() {
    if (_newUserNameController.text.isNotEmpty && _newUserEmailController.text.isNotEmpty) {
      setState(() {
        _availableUsers.add({
          'id': DateTime.now().toString(), // Temporary ID - replace with Supabase
          'name': _newUserNameController.text,
          'email': _newUserEmailController.text,
        });
        _newUserNameController.clear();
        _newUserEmailController.clear();
        _isAddingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlack,
      appBar: AppBar(
        title: const Text(
          'Create Trip Group',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: darkTeal,
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: lightTeal),
            onPressed: () {
              // TODO: Show info dialog
            },
          ),
        ],
      ),
      body: Theme(
        data: ThemeData.dark().copyWith(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: darkTeal,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: lightTeal, width: 1.5),
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Group details card
                _buildGroupDetailsCard(),
                const SizedBox(height: 20),
                // Members card
                _buildMembersCard(),
                const SizedBox(height: 28),
                // Create group button
                _buildCreateGroupButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupDetailsCard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 0,
        color: darkTeal,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Card header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [mediumTeal, darkTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: lightTeal,
                    radius: 24,
                    child: Icon(
                      Icons.groups,
                      color: darkBlack,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Trip Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Card content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _groupNameController,
                    decoration: InputDecoration(
                      labelText: 'Group Name',
                      labelStyle: TextStyle(color: lightTeal),
                      hintText: 'Enter a name for your trip group',
                      hintStyle: TextStyle(color: paleBlue.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.group, color: lightTeal),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Trip Description (Optional)',
                      labelStyle: TextStyle(color: lightTeal),
                      hintText: 'Enter a brief description of your trip',
                      hintStyle: TextStyle(color: paleBlue.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.description, color: lightTeal),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_today,
                            title: 'Start Date',
                            onTap: () {
                              // TODO: Implement date picker
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildInfoCard(
                            icon: Icons.calendar_month,
                            title: 'End Date',
                            onTap: () {
                              // TODO: Implement date picker
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: mediumTeal.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: mediumTeal),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: lightTeal, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: lightTeal,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select',
              style: TextStyle(
                color: paleBlue.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembersCard() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Card(
        elevation: 0,
        color: darkTeal,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Card header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [lightTeal, mediumTeal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: darkBlack,
                        radius: 24,
                        child: Icon(
                          Icons.people,
                          color: lightTeal,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Trip Members',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAddingUser = !_isAddingUser;
                        });
                      },
                      icon: Icon(
                        _isAddingUser ? Icons.close : Icons.person_add,
                        color: lightTeal,
                        size: 20,
                      ),
                      label: Text(
                        _isAddingUser ? 'Cancel' : 'Add',
                        style: TextStyle(color: lightTeal),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: darkBlack.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // New user form
            AnimatedCrossFade(
              firstChild: const SizedBox(height: 0),
              secondChild: _buildAddUserForm(),
              crossFadeState: _isAddingUser ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),

            // Members list
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Members',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: lightTeal,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkBlack.withOpacity(0.3),
                      border: Border.all(color: mediumTeal),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _availableUsers.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          color: mediumTeal.withOpacity(0.3),
                          indent: 16,
                          endIndent: 16,
                        ),
                        itemBuilder: (context, index) {
                          final user = _availableUsers[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _selectedMembers.contains(user['id'])
                                  ? mediumTeal.withOpacity(0.3)
                                  : Colors.transparent,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _selectedMembers.contains(user['id'])
                                    ? lightTeal
                                    : grayBlue,
                                child: Text(
                                  user['name']![0].toUpperCase(),
                                  style: TextStyle(
                                    color: _selectedMembers.contains(user['id'])
                                        ? darkBlack
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                user['name']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: _selectedMembers.contains(user['id'])
                                      ? lightTeal
                                      : Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                user['email']!,
                                style: TextStyle(
                                  color: paleBlue.withOpacity(0.7),
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Checkbox(
                                value: _selectedMembers.contains(user['id']),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedMembers.add(user['id']!);
                                    } else {
                                      _selectedMembers.remove(user['id']!);
                                    }
                                  });
                                },
                                activeColor: lightTeal,
                                checkColor: darkBlack,
                                fillColor: MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return lightTeal;
                                  }
                                  return grayBlue;
                                }),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (_selectedMembers.contains(user['id'])) {
                                    _selectedMembers.remove(user['id']!);
                                  } else {
                                    _selectedMembers.add(user['id']!);
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_selectedMembers.isNotEmpty)
                    _buildSelectedMembersChips(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddUserForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: darkBlack.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Member',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: lightTeal,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newUserNameController,
            decoration: InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: lightTeal),
              prefixIcon: Icon(Icons.person, color: lightTeal),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _newUserEmailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: lightTeal),
              prefixIcon: Icon(Icons.email, color: lightTeal),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _addNewUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: lightTeal,
              foregroundColor: darkBlack,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.add, size: 20),
            label: const Text(
              'Add Member',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMembersChips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selected Members (${_selectedMembers.length})',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: lightTeal,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedMembers.map((id) {
            final user = _availableUsers.firstWhere((u) => u['id'] == id);
            return Chip(
              avatar: CircleAvatar(
                backgroundColor: lightTeal,
                child: Text(
                  user['name']![0].toUpperCase(),
                  style: TextStyle(
                    color: darkBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              label: Text(user['name']!),
              backgroundColor: mediumTeal.withOpacity(0.3),
              labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              deleteIconColor: lightTeal,
              onDeleted: () {
                setState(() {
                  _selectedMembers.remove(id);
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: BorderSide(color: mediumTeal),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCreateGroupButton() {
    final bool hasSelectedMembers = _selectedMembers.isNotEmpty;

    return ElevatedButton(
      onPressed: hasSelectedMembers ? _createGroup : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: lightTeal,
        disabledBackgroundColor: grayBlue.withOpacity(0.3),
        disabledForegroundColor: paleBlue.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: darkBlack,
            size: 24,
          ),
          const SizedBox(width: 8),
          const Text(
            'Create Trip Group',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}