import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager_app/db/category/category_db.dart';
import 'package:moneymanager_app/db/transactions/transaction_db.dart';
import 'package:moneymanager_app/models/category/category_model.dart';

import '../../models/transactions/transaction_model.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI;
    return ValueListenableBuilder(
      valueListenable: TransactionDB.instance.transactionListNOtifier,
      builder: (BuildContext ctx, List<TransactionModel> newLIst, Widget? _) {
        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemBuilder: (ctx, index) {
            final _value = newLIst[index];
            return Slidable(
              key: Key(_value.id!),
              startActionPane:
                  ActionPane(motion: const BehindMotion(), children: [
                SlidableAction(
                  onPressed: (ctx) {
                    TransactionDB.instance.deleteTransaction(_value.id!);
                  },
                  icon: Icons.delete,
                  label: 'Delete',
                  foregroundColor: Colors.red,
                  backgroundColor: Colors.transparent,
                )
              ]),
              child: Card(
                elevation: 0,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: _value.type == CategoryType.income
                        ? Colors.green
                        : Colors.red,
                    foregroundColor: Colors.white,
                    child: Text(
                      parsedDate(_value.date),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  title: Text('RS: ${_value.amount}'),
                  subtitle: Text(_value.category.name),
                ),
              ),
            );
          },
          separatorBuilder: (ctx, index) {
            return const SizedBox(
              height: 10,
            );
          },
          itemCount: newLIst.length,
        );
      },
    );
  }

  String parsedDate(DateTime date) {
    final _date = DateFormat.MMMd().format(date);
    final _splitedDate = _date.split(' ');
    return '${_splitedDate.last}\n${_splitedDate.first}';
  }
}
