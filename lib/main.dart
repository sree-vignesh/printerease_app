import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Upload',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _selectedFile;
  bool _isUploading = false;
  String? _responseMessage;

  // Function to pick the file
  TextEditingController _rollNoController = TextEditingController();
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _responseMessage = null; // Clear previous response message
      });
    } else {
      // User canceled the picker
      print('No file selected');
    }
  }

  // Function to upload the selected file
  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      setState(() {
        _responseMessage = 'No file selected';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _responseMessage = null; // Clear any previous response message
    });

    try {
      var uri = Uri.parse(
          'http://10.0.2.2:3000/upload'); // Replace with your server URL
      var request = http.MultipartRequest('POST', uri)
        ..fields['rollno'] = _rollNoController
            .text; // Add text field value (rollno) to the request
      request.files
          .add(await http.MultipartFile.fromPath('pdf', _selectedFile!.path));
      // ignore: avoid_single_cascade_in_expression_statements

      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        // If the server responds successfully
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        setState(() {
          _responseMessage =
              'Upload successful! Identifier: ${jsonResponse['identifier']}';
        });
      } else {
        setState(() {
          _responseMessage =
              'Upload failed. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseMessage = 'Error uploading file: $e';
      });
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload PDF to Server'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            TextField(
              controller: _rollNoController,
              decoration: InputDecoration(
                labelText: 'Roll Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const Text(
              'Choose a PDF to upload',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: const Text('Pick a PDF File'),
            ),
            const SizedBox(height: 20),
            if (_selectedFile != null)
              Text('Selected file: ${_selectedFile!.path.split('/').last}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile,
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : const Text('Upload PDF'),
            ),
            const SizedBox(height: 20),
            if (_responseMessage != null)
              Text(
                _responseMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}
