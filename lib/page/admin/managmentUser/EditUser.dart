import 'package:flutter/material.dart';
import 'package:flutter_news_app/page/admin/managmentUser/UserAdmin.dart';
import '../../PHP/UserApi.dart';
import '../../model/User.dart';

class EditUser extends StatefulWidget {
  final User user;

  const EditUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _addressController = TextEditingController(text: widget.user.address);
    _phoneController = TextEditingController(text: widget.user.phone);
    _passwordController = TextEditingController(text: widget.user.password);
    _isAdmin = widget.user.isAdmin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: _isAdmin,
                  onChanged: (value) {
                    setState(() {
                      _isAdmin = value ?? false;
                    });
                  },
                ),
                const Text('Is Admin'),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Changes'),
          content: Text('Are you sure you want to save the changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                saveChanges();
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveChanges() async {
    final updatedUser = User(
      name: _nameController.text,
      email: _emailController.text,
      address: _addressController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      isAdmin: _isAdmin,
    );
    updateUser(updatedUser,widget.user.email);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserAdmin()),
    );
  }
}
