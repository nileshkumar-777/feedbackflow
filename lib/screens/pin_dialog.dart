import 'package:flutter/material.dart';

class PinDialog extends StatefulWidget {
  final String title;
  final bool isSetup;

  const PinDialog({super.key, required this.title, required this.isSetup});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  String _currentPin = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1F2937),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Device security is unavailable. Please use an in-app PIN (4 digits).',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          TextField(
            autofocus: true,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              letterSpacing: 16.0,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              counterText: '',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
            onChanged: (val) {
              _currentPin = val;
              if (val.length == 4 && !widget.isSetup) {
                Navigator.pop(context, _currentPin);
              }
              setState(() {});
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
        if (widget.isSetup)
          TextButton(
            onPressed: _currentPin.length == 4
                ? () => Navigator.pop(context, _currentPin)
                : null,
            child: const Text(
              'Save PIN',
              style: TextStyle(color: Color(0xFF6366F1)),
            ),
          ),
      ],
    );
  }
}
