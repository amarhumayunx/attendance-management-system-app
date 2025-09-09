import 'package:flutter/material.dart';
class ReadOnlyRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool dark;
  const ReadOnlyRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.dark = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                color: dark ? Colors.white70 : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: dark ? Colors.white : Colors.black,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
