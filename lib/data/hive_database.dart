import 'package:expense_tracker/models/expense_item.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  // reference our box
  final _myBox = Hive.box('expense_database');

  // write data
  void saveData(List<ExpenseItem> allExpense) {
    List<List<dynamic>> allExpensesFormatted = [];

    for (var expense in allExpense) {
      allExpensesFormatted.add([
        expense.name,
        expense.amount,
        expense.dateTime.toIso8601String(), // ✅ converting DateTime
      ]);
    }

    // ✅ PRINT HERE BEFORE SAVING
    print("Saving to Hive: $allExpensesFormatted");

    // save to Hive
    _myBox.put("ALL_EXPENSES", allExpensesFormatted);
  }


// read data
  List<ExpenseItem> readData() {
    List savedExpenses = _myBox.get("ALL_EXPENSES") ?? [];
    List<ExpenseItem> allExpenses = [];

    for (var item in savedExpenses) {
      allExpenses.add(
        ExpenseItem(
          name: item[0],
          amount: item[1],
          dateTime: DateTime.parse(item[2]), // ✅ important
        ),
      );
    }

    return allExpenses;
  }

}
