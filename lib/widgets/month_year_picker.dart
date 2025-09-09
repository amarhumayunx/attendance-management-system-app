import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
class MonthYearPicker extends StatelessWidget {
  final DateTime selectedMonth;
  final DateTime? userJoiningDate;
  final Function(DateTime) onDateSelected;
  const MonthYearPicker({
    super.key,
    required this.selectedMonth,
    this.userJoiningDate,
    required this.onDateSelected,
  });
  void _showMonthYearPicker(BuildContext context) {
    final currentYear = DateTime.now().year;
    final currentMonth = DateTime.now().month;

    // Use userJoiningDate if available, otherwise default to current year
    final minYear = userJoiningDate?.year ?? currentYear;
    final maxYear = currentYear;
    final years = List<int>.generate(maxYear - minYear + 1, (i) => minYear + i);
    int selectedYear = selectedMonth.year;
    int selectedMonthIndex = selectedMonth.month;

    if (selectedYear > maxYear) {
      selectedYear = maxYear;
      selectedMonthIndex = currentMonth;
    }
    if (selectedYear == maxYear && selectedMonthIndex > currentMonth) {
      selectedMonthIndex = currentMonth;
    }
    final yearController = FixedExtentScrollController(
      initialItem: years.indexOf(selectedYear),
    );
    final monthController = FixedExtentScrollController(
      initialItem: selectedMonthIndex - 1,
    );
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) {
        return Container(
          height: 300,
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
                      child: const Text('Cancel'),
                      onPressed: () => Get.back(),
                    ),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Done'),
                      onPressed: () {
                        final selectedDate = DateTime(selectedYear, selectedMonthIndex);
                        onDateSelected(selectedDate);
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

                          if (selectedYear == currentYear) {
                            if (selectedMonthIndex > currentMonth) {
                              selectedMonthIndex = currentMonth;
                              monthController.jumpToItem(currentMonth - 1);
                            }
                          }
                        },
                        children: [
                          for (final y in years)
                            Center(child: Text(y.toString())),
                        ],
                      ),
                    ),

                    Expanded(
                      child: CupertinoPicker(
                        scrollController: monthController,
                        itemExtent: 32,
                        onSelectedItemChanged: (index) {
                          final newMonth = index + 1;

                          if (selectedYear == currentYear && newMonth <= currentMonth) {
                            selectedMonthIndex = newMonth;
                          } else if (selectedYear < currentYear) {
                            selectedMonthIndex = newMonth;
                          }

                        },
                        children: [
                          for (int m = 1; m <= 12; m++)
                            if (!(selectedYear == currentYear && m > currentMonth))
                              Center(
                                child: Text(
                                  DateFormat('MMM').format(DateTime(2000, m)),
                                ),
                              ),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          const Text(
            'Select Month & Year',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => _showMonthYearPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('MMMM yyyy').format(selectedMonth),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white, size: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
