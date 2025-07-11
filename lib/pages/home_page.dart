import 'package:expense_tracker/components/ExpenseTile.dart';
import 'package:expense_tracker/components/bar_graph.dart';
import 'package:expense_tracker/data/expense_data.dart';
import 'package:expense_tracker/models/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameContoller = TextEditingController();
  final newExpenseAmountController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // Add this at class level

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseData>(context, listen: false).prepareData();
  }

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add new expense'),
// In the dialog:
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameContoller,
              decoration: InputDecoration(hintText: "Expense Name"),
            ),
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Expense Amount"),
            ),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                  "Pick Date: ${selectedDate.toLocal().toString().split(' ')[0]}"),
            )
          ],
        ),
        actions: [
          MaterialButton(onPressed: save, child: Text('Save')),
          MaterialButton(onPressed: cancel, child: Text('Cancel')),
        ],
      ),
    );
  }

  // delete expense
  void deleteExpense(ExpenseItem expense) {
    Provider.of<ExpenseData>(context, listen: false).deleteExpense(expense);
  }

  void save() {
    // only save expense if all fields are filled
    if (newExpenseNameContoller.text.isNotEmpty &&
        newExpenseAmountController.text.isNotEmpty) {
      ExpenseItem newExpense = ExpenseItem(
        name: newExpenseNameContoller.text,
        amount: newExpenseAmountController.text,
        dateTime: selectedDate, // ✅ Use picked date instead of now()
      );

      Provider.of<ExpenseData>(context, listen: false)
          .addNewExpense(newExpense);
    }

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameContoller.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) {
        double weekTotal = value
            .calculateDailyExpenseSummary()
            .fold(0, (sum, item) => sum + item);
        return Scaffold(
          backgroundColor: Colors.grey[300],
          floatingActionButton: FloatingActionButton(
            onPressed: addNewExpense,
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.black,
          ),
          body: Column(
            children: [
              const SizedBox(height: 60),

              // Week Total aligned with chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                  children: [
                    Text(
                      'Week Total: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${weekTotal.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Space between total and graph
              // Bar Chart
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  height: 200,
                  child: MyBarGraph(
                    weeklySummary: value.calculateDailyExpenseSummary(),
                  ),
                ),
              ),
              // Expense List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: value.getAllExpenseList().length,
                  itemBuilder: (context, index) {
                    final item = value.getAllExpenseList()[index];
                    return ExpenseTile(
                      name: item.name,
                      amount: item.amount,
                      dateTime: item.dateTime,
                      deleteTapped: (Context) =>
                          deleteExpense(value.getAllExpenseList()[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
