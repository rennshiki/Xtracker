import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<String> _customCategories = [];
  final _uuid = const Uuid();

  static const _expensesKey = 'expenses';
  static const _categoriesKey = 'custom_categories';

  final List<String> defaultCategories = [
    'Makan',
    'Transport',
    'Belanja',
    'Hiburan',
    'Kesehatan',
    'Tagihan',
    'Pendidikan',
    'Bensin',
    'Game',
    'Lainnya',
  ];

  List<String> get allCategories => [
        ...defaultCategories,
        ..._customCategories.where((c) => !defaultCategories.contains(c)),
      ];

  List<Expense> get expenses => List.unmodifiable(_expenses);

  List<Expense> getExpensesForMonth(int year, int month) {
    return _expenses
        .where((e) => e.date.year == year && e.date.month == month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  double getTotalForMonth(int year, int month) {
    return getExpensesForMonth(year, month)
        .fold(0, (sum, e) => sum + e.amount);
  }

  Map<String, double> getCategoryTotalsForMonth(int year, int month) {
    final result = <String, double>{};
    for (final e in getExpensesForMonth(year, month)) {
      result[e.category] = (result[e.category] ?? 0) + e.amount;
    }
    final sorted = Map.fromEntries(
      result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );
    return sorted;
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final expensesJson = prefs.getStringList(_expensesKey) ?? [];
    _expenses = expensesJson.map((e) => Expense.fromJson(e)).toList();

    _customCategories = prefs.getStringList(_categoriesKey) ?? [];

    notifyListeners();
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    required DateTime date,
    String note = '',
  }) async {
    final expense = Expense(
      id: _uuid.v4(),
      amount: amount,
      category: category,
      date: date,
      note: note,
    );
    _expenses.add(expense);
    _expenses.sort((a, b) => b.date.compareTo(a.date));

    if (!allCategories.contains(category)) {
      _customCategories.add(category);
    }

    await _saveData();
    notifyListeners();
  }

  Future<void> deleteExpense(String id) async {
    _expenses.removeWhere((e) => e.id == id);
    await _saveData();
    notifyListeners();
  }

  Future<void> addCustomCategory(String category) async {
    if (!allCategories.contains(category)) {
      _customCategories.add(category);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_categoriesKey, _customCategories);
      notifyListeners();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        _expensesKey, _expenses.map((e) => e.toJson()).toList());
    await prefs.setStringList(_categoriesKey, _customCategories);
  }
}
