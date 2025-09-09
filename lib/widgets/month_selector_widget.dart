import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class MonthSelectorWidget extends StatelessWidget {
  final DateTime currentMonth;
  final Function(DateTime) onMonthChanged;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback? onRefresh;
  const MonthSelectorWidget({
    super.key,
    required this.currentMonth,
    required this.onMonthChanged,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.onRefresh,
  });
  void _openDatePicker(BuildContext context) {
    final initial = currentMonth;
    final years = List<int>.generate(DateTime.now().year - 1999 + 2, (i) => 2000 + i);
    int selectedYear = initial.year;
    int selectedMonth = initial.month;
    final yearController = FixedExtentScrollController(
      initialItem: years.indexOf(selectedYear),
    );
    final monthController = FixedExtentScrollController(
      initialItem: selectedMonth - 1,
    );
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return Container(
          height: 300,
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Cancel'),
                      onPressed: () => Get.back(),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Done'),
                      onPressed: () {
                        onMonthChanged(DateTime(selectedYear, selectedMonth));
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: yearController,
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          selectedYear = years[index];
                        },
                        children: [
                          for (final y in years) Center(child: Text(y.toString())),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: monthController,
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          selectedMonth = index + 1;
                        },
                        children: [
                          for (int m = 1; m <= 12; m++)
                            Center(child: Text(DateFormat('MMM').format(DateTime(2000, m)))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: onPreviousMonth,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _openDatePicker(context),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMMM yyyy').format(currentMonth),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: onNextMonth,
          ),
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: onRefresh,
              tooltip: 'Refresh',
            ),
        ],
      ),
    );
  }
}
