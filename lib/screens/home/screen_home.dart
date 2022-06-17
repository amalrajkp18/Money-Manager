import 'package:flutter/material.dart';
import 'package:moneymanager_app/screens/add_transaction/screen_add_transctionoo.dart';
import 'package:moneymanager_app/screens/category/category_add_popup.dart';
import 'package:moneymanager_app/screens/category/screen_category.dart';
import 'package:moneymanager_app/screens/home/widget/bottom_navigaton.dart';
import 'package:moneymanager_app/screens/transactions/screen_transactions.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({Key? key}) : super(key: key);

  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);
  final _pages = const [
    ScreenTransactions(),
    ScreenCategory(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 234, 233, 233),
      appBar: AppBar(
        title: const Text('MONEY MANAGER'),
        centerTitle: true,
      ),
      bottomNavigationBar: const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selectedIndexNotifier,
            builder: (BuildContext context, int updatedIndex, _) {
              return _pages[updatedIndex];
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedIndexNotifier.value == 0) {
            print('Transaction');
            Navigator.of(context).pushNamed(ScreenAddTransaction.routName);
          } else {
            showCategoryAddPopup(context);
          }
          // final _sample = CategoryModel(
          //     id: DateTime.now().millisecondsSinceEpoch.toString(),
          //     name: 'Travel',
          //     type: CategoryType.expense);
          // CategoryDB().insertCategory(_sample);
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
