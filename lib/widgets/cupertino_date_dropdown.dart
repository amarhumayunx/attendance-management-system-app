import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class CupertinoDateDropdown extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;
  final bool dense;
  const CupertinoDateDropdown({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.dense = false,
  });
  String _formatLabel(DateTime dt) {
    return DateFormat('dd MMM yyyy').format(dt);
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 8 : 12),
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        onPressed: () async {
          DateTime temp = selectedDate;
          await showCupertinoModalPopup(
            context: context,
            builder: (ctx) {
              return CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.dark),
                child: Container(
                  height: 260,
                  color: Colors.black,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 44,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              onPressed: () {
                                onDateChanged(temp);
                                Get.back();
                              },
                              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Expanded(
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: selectedDate,
                          onDateTimeChanged: (dt) {
                            temp = DateTime(dt.year, dt.month, dt.day);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Row(
          children: [
            Icon(CupertinoIcons.calendar, color: Colors.white, size: dense ? 16 : 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _formatLabel(selectedDate),
                style: TextStyle(color: Colors.white, fontSize: dense ? 13 : 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(CupertinoIcons.chevron_down, color: Colors.white70, size: dense ? 16 : 18),
          ],
        ),
      ),
    );
  }
}
