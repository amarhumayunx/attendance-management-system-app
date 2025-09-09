import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrscanner/core/models/user_model.dart';
class CupertinoDepartmentPicker extends StatelessWidget {
  final Department selected;
  final void Function(Department) onSelected;
  final String Function(Department) getLabel;
  final bool dense;
  const CupertinoDepartmentPicker({
    super.key,
    required this.selected,
    required this.onSelected,
    required this.getLabel,
    this.dense = false,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: dense ? 8 : 12),
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        onPressed: () async {
          await showCupertinoModalPopup(
            context: context,
            builder: (ctx) {
              return CupertinoTheme(
                data: const CupertinoThemeData(brightness: Brightness.dark),
                child: CupertinoActionSheet(
                  title: const Text('Select Department'),
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  actions: Department.values.map((dept) {
                    return CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                        onSelected(dept);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (dept == selected) Icon(CupertinoIcons.check_mark, size: dense ? 16 : 18, color: Colors.white),
                          if (dept == selected) const SizedBox(width: 8),
                          Text(getLabel(dept)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
        child: Row(
          children: [
            Icon(CupertinoIcons.building_2_fill, color: Colors.white, size: dense ? 16 : 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                getLabel(selected),
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
