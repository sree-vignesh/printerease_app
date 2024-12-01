import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:provider/provider.dart';
// import 'roll_no_provider.dart';
import 'package:printer_flutter_app/Providers/rollno_provider.dart';
import 'package:printer_flutter_app/Providers/serverurl.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({Key? key}) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  bool _isUploading = false;
  String? _responseMessage;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _responseMessage = null;
      });
    } else {
      print('No file selected');
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      setState(() {
        _responseMessage = 'No file selected';
      });
      return;
    }

    setState(() {
      _isUploading = true;
      _responseMessage = null;
    });
    final rollNoProvider = Provider.of<RollNoProvider>(context, listen: false);
    final rollNo = rollNoProvider.rollNo ?? 'Not Set';

    final serverUrl =
        Provider.of<ServerProvider>(context, listen: false).serverUrl;
    final uri = Uri.parse('$serverUrl/upload');
    try {
      // var uri = Uri.parse(
      //     'http://10.0.2.2:3000/upload'); // Replace with your server URL
      // var request = http.MultipartRequest('POST', uri)
      //   ..fields['rollno'] = _rollNoController.text;
      // request.files
      //     .add(await http.MultipartFile.fromPath('pdf', _selectedFile!.path));

      // var response = await request.send();
      // var uri = Uri.parse(
      //     'http://10.0.2.2:3000/upload'); // Replace with your server URL
      var request = http.MultipartRequest('POST', uri)
        ..fields['rollno'] = rollNo;

// Extract the file name from the file path
      String fileName = _selectedFile!.path.split('/').last;

// Add the file name as a field
      request.fields['filename'] = fileName;

// Add the file to the request
      request.files
          .add(await http.MultipartFile.fromPath('pdf', _selectedFile!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        setState(() {
          _responseMessage =
              'Upload successful ! \nIdentifier: ${jsonResponse['identifier']}';
        });
      } else {
        setState(() {
          _responseMessage =
              'Upload failed. \nStatus code: ${response.statusCode}';
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
    final rollNoProvider = Provider.of<RollNoProvider>(context);
    final rollNo = rollNoProvider.rollNo ?? 'Not Set';

    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: rollNo != 'Not Set'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text(rollNo),
                    // const SizedBox(height: 20),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   'Choose a PDF to upload',
                    //   style:
                    //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickFile,
                      child: const Text(
                        'Pick a PDF File',
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_selectedFile != null)
                      Text(
                          'Selected file : ${_selectedFile!.path.split('/').last}'),
                    const SizedBox(height: 20),
                    if (_selectedFile != null)
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                  ],
                )
              : const Text(
                  'Roll Number is not set. Please set your Roll Number in the Account tab.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
        ),
      ),
    );
  }
}
