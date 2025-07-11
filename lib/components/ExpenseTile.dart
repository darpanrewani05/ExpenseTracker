import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final String amount;
  final DateTime dateTime;
  final void Function(BuildContext)? deleteTapped; // ✅ Fixed

  ExpenseTile({
    super.key,
    required this.name,
    required this.amount,
    required this.dateTime,
    required this.deleteTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          // delete button
          SlidableAction(
            onPressed: deleteTapped,
            backgroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      child: ListTile(
        title: Text(name),
        subtitle: Text(
          '${dateTime.day} / ${dateTime.month} / ${dateTime.year}',
        ),
        trailing: Text(amount),
      ),
    );
  }
}
