import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printer_flutter_app/Providers/rollno_provider.dart';
import 'package:printer_flutter_app/Providers/serverurl.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rollNoProvider = Provider.of<RollNoProvider>(context);
    final rollNo = rollNoProvider.rollNo ?? 'Not Set';
    final serverurlProvider = Provider.of<ServerProvider>(context);
    final _serverurl = serverurlProvider.serverUrl ?? 'Not Set';

    final TextEditingController rollNoController =
        TextEditingController(text: rollNoProvider.rollNo);
    final TextEditingController serverurlController =
        TextEditingController(text: ServerProvider().serverUrl);

    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(rollNo),
              Text(_serverurl),
              const SizedBox(height: 20),
              TextField(
                controller: rollNoController,
                decoration: const InputDecoration(
                  labelText: 'Enter Roll Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  rollNoProvider.setRollNo(rollNoController.text.isNotEmpty
                      ? rollNoController.text
                      : null);
                },
                child: const Text('Set Roll Number'),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: serverurlController,
                decoration: const InputDecoration(
                  labelText: 'Enter Server URL',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  serverurlProvider.setServerUrl(
                      serverurlController.text.isNotEmpty
                          ? serverurlController.text
                          : null);
                },
                child: const Text('Set Server URL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
