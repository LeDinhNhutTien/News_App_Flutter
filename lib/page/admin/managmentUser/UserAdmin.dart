import 'package:flutter/material.dart';
import '../../PHP/UserApi.dart';
import '../../model/User.dart';
import '../HomeAdmin.dart';
import '../managmentNews/NewsManager.dart';
import '../loadNews/TrongNuoc.dart';
import 'EditUser.dart';

void main() {
  runApp(const UserAdmin());
}

class UserAdmin extends StatelessWidget {
  const UserAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late Future<List<User>> usersFuture;
  bool isMenuOpen = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    usersFuture = fetchDataDBUser();
  }

  void toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: toggleMenu,
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: FutureBuilder<List<User>>(
              future: usersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Failed to fetch data'));
                } else if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(users[index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${users[index].email}'),
                            Text('Address: ${users[index].address}'),
                            Text('Phone: ${users[index].phone}'),
                            Text('Is Admin: ${users[index].isAdmin ? 'Yes' : 'No'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editUser(users[index]);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(users[index]);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );

                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
          if (isMenuOpen) NavigationDrawer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddUserDialog(context);
        },
      ),
    );
  }
  void _editUser(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUser(user: user)),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    bool isAdmin = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String email = '';
        String address = '';
        String phone = '';
        String password = '';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add User'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      address = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Address',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      phone = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isAdmin,
                        onChanged: (value) {
                          setState(() {
                            isAdmin = value ?? false;
                          });
                        },
                      ),
                      const Text('Is Admin'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (name.isNotEmpty && email.isNotEmpty) {
                      _addUser(name, email, address, phone, password, isAdmin);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addUser(String name, String email, String address, String phone, String password, bool isAdmin) async {
    try {
      setState(() {
        _isLoading = true;
      });

      User newUser = User(
        name: name,
        email: email,
        address: address,
        phone: phone,
        password: password,
        isAdmin: isAdmin,
      );

      await saveUser(newUser);
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        usersFuture = fetchDataDBUser();
        _isLoading = false;
      });
    } catch (error) {
      print('Error adding user: $error');
      setState(() {
        _isLoading = false;
      });
      // Handle error, show a message to the user, etc.
    }
  }

  void _deleteUser(User user) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await deleteUser(user);
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        usersFuture = fetchDataDBUser();
        _isLoading = false;
      });
    } catch (error) {
      print('Error deleting user: $error');
      setState(() {
        _isLoading = false;
      });
      // Handle error, show a message to the user, etc.
    }
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            height: 0,
            color: Colors.blueGrey[800],
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Handle when the user taps on the Home menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminApp()),
              );
            },
          ),
          ListTile(
            title: const Text('Duyệt báo mới'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrongNuoc()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý người dùng'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserAdmin()),
              );
            },
          ),

          ListTile(
            title: const Text('Danh sách bài báo'),
            onTap: () {
              // Handle when the user taps on the Danh sách bài báo menu item
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsManager()),
              );
            },
          ),
        ],
      ),
    );
  }
}
