import 'package:flutter/material.dart';

import '../model/Category.dart';
import 'HomeAdmin.dart';
import 'NewsManager.dart';
import 'TheGioi.dart';
import 'TrongNuoc.dart';

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
  List<User> users = [
    User('John Doe', 'john.doe@example.com', '123 Main St', '555-1234', 'password123', true),
    User('Jane Smith', 'jane.smith@example.com', '456 Elm St', '555-5678', 'password456', false),
    User('Robert Johnson', 'robert.johnson@example.com', '789 Oak St', '555-9012', 'password789', false),
  ];

  bool isMenuOpen = false;

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
      body: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: ListView.builder(
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
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteUser(index);
                    },
                  ),
                );
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

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String email = '';
        String address = '';
        String phone = '';
        String password = '';
        bool isAdmin = false;

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
  }

  void _addUser(String name, String email, String address, String phone, String password, bool isAdmin) {
    setState(() {
      users.add(User(name, email, address, phone, password, isAdmin));
    });
  }

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
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
            title: const Text('Quản lý báo trong nước'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TrongNuoc()),
              );
            },
          ),
          ListTile(
            title: const Text('Quản lý báo ngoài nước'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsTheGioi()),
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
class User {
  final String name;
  final String email;
  final String address;
  final String phone;
  final String password;
  final bool isAdmin;

  User(this.name, this.email, this.address, this.phone, this.password, this.isAdmin);
}