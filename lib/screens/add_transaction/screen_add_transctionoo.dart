import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager_app/db/category/category_db.dart';
import 'package:moneymanager_app/db/transactions/transaction_db.dart';
import 'package:moneymanager_app/models/category/category_model.dart';
import 'package:moneymanager_app/models/transactions/transaction_model.dart';

class ScreenAddTransaction extends StatefulWidget {
  static const routName = 'add-transaction';
  const ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  State<ScreenAddTransaction> createState() => _ScreenAddTransactionState();
}

class _ScreenAddTransactionState extends State<ScreenAddTransaction> {
  DateTime? _selectedDate;
  CategoryType? _selectedType;
  CategoryModel? _selectedCategoryModel;
  String? _CategoryID;

  final _purposeTextEditingController = TextEditingController();
  final _amountTextEditingController = TextEditingController();

  @override
  void initState() {
    _selectedType = CategoryType.income;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              controller: _purposeTextEditingController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                hintText: 'Purpose',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _amountTextEditingController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Radio(
                        value: CategoryType.income,
                        groupValue: _selectedType,
                        onChanged: (newList) {
                          setState(
                            () {
                              _selectedType = CategoryType.income;
                              _CategoryID = null;
                            },
                          );
                        }),
                    const Text('Income'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: CategoryType.expense,
                        groupValue: _selectedType,
                        onChanged: (newList) {
                          setState(
                            () {
                              _selectedType = CategoryType.expense;
                              _CategoryID = null;
                            },
                          );
                        }),
                    const Text('Expense'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        final selectedDateTemp = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDateTemp == null) {
                          return;
                        } else {
                          print(selectedDateTemp);
                          setState(() {
                            _selectedDate = selectedDateTemp;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : parsedDate(_selectedDate!),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all()),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text('Select Category'),
                          value: _CategoryID,
                          items: (_selectedType == CategoryType.income
                                  ? CategoryDB().incomeCategoryListListener
                                  : CategoryDB().expenseCategoryListListener)
                              .value
                              .map((e) {
                            return DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                              onTap: () {
                                _selectedCategoryModel = e;
                              },
                            );
                          }).toList(),
                          onChanged: (selectedvalue) {
                            setState(
                              () {
                                _CategoryID = selectedvalue;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  addTransaction();
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<void> addTransaction() async {
    final purposeText = _purposeTextEditingController.text;
    final amountText = _amountTextEditingController.text;

    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    // if (_CategoryID == null) {
    //   return;
    // }
    if (_selectedDate == null) {
      return;
    }
    if (_selectedCategoryModel == null) {
      return;
    }

    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }

    final model = TransactionModel(
      purpose: purposeText,
      amount: parsedAmount,
      date: _selectedDate!,
      type: _selectedType!,
      category: _selectedCategoryModel!,
    );
    await TransactionDB.instance.addTransaction(model);
    Navigator.of(context).pop();
    TransactionDB.instance.refresh();
  }

  String parsedDate(DateTime date) {
    // return DateFormat.yMd().format(date);
    final formatter = DateFormat('dd/MM/yyyy');
    final formatted = formatter.format(date);
    return formatted;
  }
}
