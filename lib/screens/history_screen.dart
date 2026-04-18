import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../utils/theme.dart';
import '../utils/formatter.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime _selectedMonth = DateTime.now();
  String? _filterCategory;

  void _prevMonth() {
    setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1));
  }

  void _nextMonth() {
    final now = DateTime.now();
    if (_selectedMonth.year < now.year || (_selectedMonth.year == now.year && _selectedMonth.month < now.month)) {
      setState(() => _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final allCategories = provider.allCategories;
    var monthExpenses = provider.getExpensesForMonth(_selectedMonth.year, _selectedMonth.month);
    final categoryTotals = provider.getCategoryTotalsForMonth(_selectedMonth.year, _selectedMonth.month);

    if (_filterCategory != null) {
      monthExpenses = monthExpenses.where((e) => e.category == _filterCategory).toList();
    }

    // Group by date
    final Map<String, List<Expense>> grouped = {};
    for (final e in monthExpenses) {
      final key = CurrencyFormatter.formatDayShort(e.date);
      grouped[key] = [...(grouped[key] ?? []), e];
    }

    final categories = categoryTotals.keys.toList();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Riwayat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: Column(
        children: [
          // Month selector
          Container(
            color: AppTheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _prevMonth,
                  child: const Icon(Icons.chevron_left_rounded, color: AppTheme.textSecondary),
                ),
                Text(
                  CurrencyFormatter.formatMonthYear(_selectedMonth),
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                ),
                GestureDetector(
                  onTap: _nextMonth,
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: (_selectedMonth.month == DateTime.now().month && _selectedMonth.year == DateTime.now().year)
                        ? AppTheme.textMuted
                        : AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Category filter chips
          if (categories.isNotEmpty)
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip('Semua', null, allCategories),
                    ...categories.map((cat) => _filterChip(cat, cat, allCategories)),
                  ],
                ),
              ),
            ),

          Container(height: 1, color: AppTheme.border),

          // Expense list
          Expanded(
            child: monthExpenses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📭', style: TextStyle(fontSize: 56)),
                        const SizedBox(height: 16),
                        const Text('Tidak ada pengeluaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
                        const SizedBox(height: 4),
                        Text(
                          _filterCategory != null ? 'Untuk kategori $_filterCategory' : 'Bulan ini belum ada transaksi',
                          style: const TextStyle(fontSize: 13, color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100),
                    itemCount: grouped.length,
                    itemBuilder: (ctx, i) {
                      final dateLabel = grouped.keys.elementAt(i);
                      final dayExpenses = grouped[dateLabel]!;
                      final dayTotal = dayExpenses.fold(0.0, (s, e) => s + e.amount);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  dateLabel,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(dayTotal),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Expense items
                          ...dayExpenses.map((expense) {
                            // Warna tetap berdasarkan posisi kategori di allCategories
                            final color = AppTheme.getCategoryColor(expense.category, allCategories);

                            return Slidable(
                              key: Key(expense.id),
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (_) => _confirmDelete(context, provider, expense.id),
                                    backgroundColor: AppTheme.danger,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete_outline_rounded,
                                    label: 'Hapus',
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppTheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppTheme.border),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [

                                    // ICON CATEGORY
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: color.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          AppIcons.getIcon(expense.category),
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    // CATEGORY + NOTE
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Text(
                                            expense.category,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          if (expense.note.isNotEmpty)
                                            Text(
                                              expense.note,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppTheme.textMuted,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),

                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    // AMOUNT
                                    Text(
                                      CurrencyFormatter.format(expense.amount),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String? cat, List<String> allCategories) {
    final selected = _filterCategory == cat;
    final color = cat != null
        ? AppTheme.getCategoryColor(cat, allCategories)
        : AppTheme.primary;

    return GestureDetector(
      onTap: () => setState(() => _filterCategory = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.2) : AppTheme.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? color : AppTheme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (cat != null) ...[
              Image.asset(
                AppIcons.getIcon(cat),
                width: 14,
                height: 14,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? color : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ExpenseProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Pengeluaran?', style: TextStyle(color: AppTheme.textPrimary, fontSize: 16)),
        content: const Text('Data ini tidak bisa dikembalikan.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              provider.deleteExpense(id);
              Navigator.pop(ctx);
            },
            child: const Text('Hapus', style: TextStyle(color: AppTheme.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}