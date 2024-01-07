import 'package:flutter/material.dart';

import '../model/NewsArticle.dart';


class EditNewsPage extends StatefulWidget {
  final NewsArticle newsArticle;

  const EditNewsPage({
    Key? key,
    required this.newsArticle,
  }) : super(key: key);

  @override
  _EditNewsPageState createState() => _EditNewsPageState();
}

class _EditNewsPageState extends State<EditNewsPage> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late TextEditingController _typeController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.newsArticle.title);
    _authorController = TextEditingController(text: widget.newsArticle.author);
    _descriptionController =
        TextEditingController(text: widget.newsArticle.description);
    _urlController = TextEditingController(text: widget.newsArticle.url);
    _typeController = TextEditingController(text: widget.newsArticle.type);
    _dateController = TextEditingController(text: widget.newsArticle.date);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _typeController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit News'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _typeController,
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Date',
              ),
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

  void saveChanges() {
    final updatedNewsArticle = NewsArticle(
      image: widget.newsArticle.image,
      title: _titleController.text,
      author: _authorController.text,
      description: _descriptionController.text,
      url: _urlController.text,
      type: _typeController.text,
      date: _dateController.text,
    );

    // TODO: Save the updated news article to the database or update the existing one

    Navigator.pop(context, updatedNewsArticle);
  }
}
