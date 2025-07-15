import 'package:expense_tracker/data/hive_database.dart';
import 'package:flutter/cupertino.dart';
import '../models/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseData extends ChangeNotifier {
  // list of all expenses
  List<ExpenseItem> overallExpenseList = [];

  // get expense list
  List<ExpenseItem> getAllExpenseList() {
    return overallExpenseList;
  }

// prepare data to display
  final db = HiveDataBase();

  void prepareData() {
    // if there exists data, get it
    if (db.readData().isNotEmpty) {
      overallExpenseList = db.readData().cast<ExpenseItem>();
    }

    // ✅ This tells Flutter to rebuild the graph and list
    notifyListeners();
  }

// add new expense
  void addNewExpense(ExpenseItem newExpense) {
    overallExpenseList.add(newExpense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

// delete expense
  void deleteExpense(ExpenseItem expense) {
    overallExpenseList.remove(expense);

    notifyListeners();
    db.saveData(overallExpenseList);
  }

  // update expense
  void updateExpense(ExpenseItem oldExpense, String newName, String newAmount, DateTime newDate) {
    int index = overallExpenseList.indexOf(oldExpense);
    if (index != -1) {
      overallExpenseList[index] = ExpenseItem(
        name: newName,
        amount: newAmount,
        dateTime: newDate, // Keep old date
      );
      db.saveData(overallExpenseList);
      notifyListeners();
    }
  }

  // get total expense for each day of current week
  List<double> calculateDailyExpenseSummary() {
    DateTime startOfWeek = startOfWeekDate(); // Sunday
    List<double> dailyTotals = List.filled(7, 0); // 7 days: Sun to Sat

    for (var expense in overallExpenseList) {
      // Clean date without time
      DateTime expenseDate = DateTime(
        expense.dateTime.year,
        expense.dateTime.month,
        expense.dateTime.day,
      );

      // Check if expense falls within current week
      if (expenseDate.isAtSameMomentAs(startOfWeek) ||
          expenseDate.isAfter(startOfWeek)) {
        int dayIndex = expenseDate.difference(startOfWeek).inDays;

        if (dayIndex >= 0 && dayIndex < 7) {
          dailyTotals[dayIndex] += double.tryParse(expense.amount) ?? 0.0;
        }
      }
    }

    return dailyTotals;
  }

// get weekday (mon,tue,etc) from a dataTime object
  String getDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thur';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

// get the date for the start of the week (sunday)
  DateTime startOfWeekDate() {
    DateTime today = DateTime.now();
    // Go backwards from today until you hit Sunday
    for (int i = 0; i < 7; i++) {
      DateTime checkDay = today.subtract(Duration(days: i));
      if (checkDay.weekday == DateTime.sunday) {
        return DateTime(
            checkDay.year, checkDay.month, checkDay.day); // return clean date
      }
    }
    return today; // fallback
  }
}
