import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String value;
  final ValueChanged<String> onValueChanged;

  const CustomTextInput({
    Key? key,
    required this.value,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late String _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value; // Initialize with the provided value
  }

  void _openDialog() async {
    TextEditingController _controller =
        TextEditingController(text: _currentValue);

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modify Value'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Enter new value'),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Dismiss without changes
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(
                  context, _controller.text), // Return entered value
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // Update value if the user pressed OK
    if (result != null) {
      setState(() {
        _currentValue = result;
      });
      widget.onValueChanged(result); // Notify the parent widget of the change
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _currentValue,
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: _openDialog,
            icon: const Icon(Icons.edit,
                color: Color.fromARGB(255, 145, 33, 243)),
          ),
        ],
      ),
    );
  }
}
