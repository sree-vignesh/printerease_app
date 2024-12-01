import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Providers/rollno_provider.dart';
import '../Providers/serverurl.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  List<MapEntry<String, String>> _files = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFiles();
  }

  Future<void> _fetchFiles() async {
    final rollNoProvider = Provider.of<RollNoProvider>(context, listen: false);
    final serverProvider = Provider.of<ServerProvider>(context, listen: false);

    final rollNo = rollNoProvider.rollNo;
    final serverUrl = serverProvider.serverUrl;

    if (rollNo == null || serverUrl == null) {
      setState(() {
        _errorMessage = "Roll Number or Server URL is not set.";
      });
      return;
    }

    final url = Uri.parse('$serverUrl/files/$rollNo');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> &&
            data['files'] is Map<String, dynamic>) {
          final filesMap = Map<String, String>.from(data['files']);
          setState(() {
            _files = filesMap.entries
                .toList(); // Convert the map to a list of entries
            _errorMessage = null;
          });
        } else {
          setState(() {
            _errorMessage = "Unexpected response format from the server.";
          });
        }
      } else {
        setState(() {
          _errorMessage = "Failed to fetch files: ${response.reasonPhrase}";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching files: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: _errorMessage != null
              ? Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                )
              : _files.isNotEmpty
                  ? ListView.builder(
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        final entry = _files[index];
                        return Card(
                          elevation: 10, // Controls the shadow intensity
                          shadowColor: Colors.grey.withOpacity(
                              0.8), // Shadow color and transparency
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8), // Optional rounded corners
                          ),
                          child: ListTile(
                            title: Text(entry.value), // Original file name
                            subtitle: Text(entry.key), // Identifier
                            leading: const Icon(Icons.picture_as_pdf),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(entry
                                        .value), // Dynamic title with object name
                                    content: const Text("Choose an action:"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close dialog
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Add logic to view object (e.g., open a PDF)
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("View"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Add logic for "OK" action
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    )
                  : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
