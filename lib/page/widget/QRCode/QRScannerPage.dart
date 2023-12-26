import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class QRCodeGenerator extends StatefulWidget {
  QRCodeGenerator();

  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  String? qrData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            qrData != null
                ? QrImageView(data: qrData!, version: QrVersions.auto, size: 200.0)
                : SizedBox(height: 200.0),
            SizedBox(height: 20.0),
            Text(
              'Scan QR Code to visit:',
              style: TextStyle(fontSize: 18.0),
            ),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ContactFormDialog(
                      onFormSubmit: (name, email, phone) {
                        setState(() {
                          qrData = generateQRData(name, email, phone);
                        });
                        Navigator.of(context).pop();
                      },
                    );
                  },
                );
              },
              child: Text('Hãy tạo cho mình một mã QR'),
            ),
          ],
        ),
      ),
    );
  }

  String generateQRData(String name, String email, String phone) {
    // Tạo chuỗi dữ liệu QR code từ thông tin liên hệ
    return "Name: $name\nEmail: $email\nPhone: $phone";
  }
}

class ContactFormDialog extends StatelessWidget {
  final Function(String, String, String) onFormSubmit;

  ContactFormDialog({required this.onFormSubmit});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Contact Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            final name = nameController.text;
            final email = emailController.text;
            final phone = phoneController.text;
            onFormSubmit(name, email, phone);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}