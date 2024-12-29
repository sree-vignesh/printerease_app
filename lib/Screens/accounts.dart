import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:printer_flutter_app/Providers/rollno_provider.dart';
import 'package:printer_flutter_app/Providers/serverurl.dart';
import 'package:printer_flutter_app/Widgets/custom_text_input.dart'; // Import the custom widget

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rollNoProvider = Provider.of<RollNoProvider>(context);
    final serverurlProvider = Provider.of<ServerProvider>(context);

    return Center(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the current values
              Text(
                rollNoProvider.rollNo ?? 'Roll Number: Not Set',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),
              Text(
                serverurlProvider.serverUrl ?? 'Server URL: Not Set',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.normal),
              ),

              const SizedBox(height: 30),

              // Replace Roll Number TextField with CustomTextInput
              CustomTextInput(
                value: rollNoProvider.rollNo ?? 'Not Set',
                onValueChanged: (newValue) {
                  rollNoProvider
                      .setRollNo(newValue.isNotEmpty ? newValue : null);
                },
              ),

              const SizedBox(height: 30),

              // Replace Server URL TextField with CustomTextInput
              CustomTextInput(
                value: serverurlProvider.serverUrl ?? 'Not Set',
                onValueChanged: (newValue) {
                  serverurlProvider
                      .setServerUrl(newValue.isNotEmpty ? newValue : null);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
