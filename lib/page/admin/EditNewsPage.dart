import 'package:flutter/material.dart';

import 'NewsManager.dart';

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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.newsArticle.title);
    _authorController = TextEditingController(text: widget.newsArticle.author);
    _descriptionController =
        TextEditingController(text: widget.newsArticle.description);
    _urlController = TextEditingController(text: widget.newsArticle.url);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
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
              decoration: InputDecoration(
                labelText: 'Author',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog();
              },
              child: Text('Save Changes'),
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
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                saveChanges();
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
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
    );

    // TODO: Save the updated news article to the database or update the existing one

    Navigator.pop(context, updatedNewsArticle);
  }
}
