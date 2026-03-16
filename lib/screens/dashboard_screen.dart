import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/expense_provider.dart';
import '../utils/theme.dart';
import '../utils/formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedMonth = DateTime.now();
  int _touchedIndex = -1;
  bool _showPie = true;

  void _prevMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    if (_selectedMonth.year < now.year ||
        (_selectedMonth.year == now.year && _selectedMonth.month < now.month)) {
      setState(() {
        _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final allCategories = provider.allCategories;
    final total = provider.getTotalForMonth(_selectedMonth.year, _selectedMonth.month);
    final categoryTotals = provider.getCategoryTotalsForMonth(_selectedMonth.year, _selectedMonth.month);
    final categories = categoryTotals.keys.toList();
    final values = categoryTotals.values.toList();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            backgroundColor: AppTheme.surface,
            surfaceTintColor: Colors.transparent,
            title: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: Image.asset(
                    'assets/icons/logo.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('XTracker',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                    Text('Pencatat Pengeluaran Anda',
                        style: TextStyle(fontSize: 10, color: AppTheme.textMuted, letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppTheme.border),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Month Selector
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _prevMonth,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: AppTheme.textSecondary, size: 20),
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatMonthYear(_selectedMonth),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: _nextMonth,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: _selectedMonth.month == DateTime.now().month &&
                                    _selectedMonth.year == DateTime.now().year
                                ? AppTheme.textMuted
                                : AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Total Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF2D1F6E), Color(0xFF1A1230)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF3D2A8A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('💸', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text(
                            'Total Pengeluaran Bulan Ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        CurrencyFormatter.format(total),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Color.fromARGB(255, 255, 255, 255),
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${categoryTotals.length} kategori',
                              style: const TextStyle(fontSize: 11, color: AppTheme.primaryLight, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${provider.getExpensesForMonth(_selectedMonth.year, _selectedMonth.month).length} transaksi',
                              style: TextStyle(fontSize: 11, color: AppTheme.accent, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (categoryTotals.isNotEmpty) ...[
                  // Chart Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Breakdown Kategori',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceHigh,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  _chartToggle('assets/icons/square.png', true),
                                  _chartToggle('assets/icons/bar.png', false),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        if (_showPie)
                          _buildPieChart(categories, values, total, allCategories)
                        else
                          _buildBarChart(categories, values, allCategories),

                        const SizedBox(height: 20),

                        // Legend
                        ...categories.asMap().entries.map((entry) {
                          final i = entry.key;
                          final cat = entry.value;
                          final val = values[i];
                          final pct = total > 0 ? (val / total * 100).toStringAsFixed(1) : '0';
                          // Warna tetap berdasarkan posisi kategori di allCategories
                          final color = AppTheme.getCategoryColor(cat, allCategories);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: color.withOpacity(0.2), width: 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [color, color.withOpacity(0.7)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      AppIcons.getIcon(cat),
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cat,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        CurrencyFormatter.formatCompact(val),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$pct%',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: color,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        const Text('📭', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        const Text('Belum ada pengeluaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Tap tombol + untuk mulai mencatat', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
                      ],
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartToggle(String iconAsset, bool isPie) {
    final active = _showPie == isPie;
    return GestureDetector(
      onTap: () => setState(() => _showPie = isPie),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppTheme.primary.withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          border: active ? Border.all(color: AppTheme.primary.withOpacity(0.5)) : null,
        ),
        child: Image.asset(
          iconAsset,
          width: 18,
          height: 18,
        ),
      ),
    );
  }
  Widget _buildPieChart(List<String> cats, List<double> vals, double total, List<String> allCategories) {
    return Container(
      height: 240,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 60,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (response?.touchedSection != null) {
                      _touchedIndex = response!.touchedSection!.touchedSectionIndex;
                    } else {
                      _touchedIndex = -1;
                    }
                  });
                },
              ),
              sections: cats.asMap().entries.map((entry) {
                final i = entry.key;
                final cat = entry.value;
                final val = vals[i];
                final isTouched = _touchedIndex == i;
                // Warna tetap berdasarkan posisi di allCategories
                final color = AppTheme.getCategoryColor(cat, allCategories);
                return PieChartSectionData(
                  value: val,
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  radius: isTouched ? 70 : 60,
                  title: '',
                  borderSide: BorderSide(
                    color: isTouched ? Colors.white.withOpacity(0.3) : Colors.transparent,
                    width: 2,
                  ),
                );
              }).toList(),
              centerSpaceColor: AppTheme.surface,
            ),
          ),
          if (_touchedIndex >= 0 && _touchedIndex < cats.length)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppIcons.getIcon(cats[_touchedIndex]),
                    width: 26,
                    height: 26,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(vals[_touchedIndex] / total * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.getCategoryColor(cats[_touchedIndex], allCategories),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceHigh,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.border, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('💰', style: TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    '${cats.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    'kategori',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<String> cats, List<double> vals, List<String> allCategories) {
    final maxVal = vals.isEmpty ? 100.0 : vals.reduce((a, b) => a > b ? a : b);
    final barWidth = cats.length > 6 ? 18.0 : cats.length > 4 ? 24.0 : 32.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bar chart
        SizedBox(
          height: 220,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceEvenly,
              maxY: maxVal * 1.25,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => const Color(0xFF2A2A2A),
                  tooltipBorder: const BorderSide(color: Color(0xFF444444), width: 1),
                  tooltipRoundedRadius: 12,
                  tooltipPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  tooltipMargin: 12,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final color = AppTheme.getCategoryColor(cats[groupIndex], allCategories);
                    return BarTooltipItem(
                      '',
                      const TextStyle(),
                      children: [
                        TextSpan(
                          text: '${cats[groupIndex]}\n',
                          style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        TextSpan(
                          text: CurrencyFormatter.formatCompact(vals[groupIndex]),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                // Label atas: nilai nominal
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= vals.length) return const SizedBox();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          CurrencyFormatter.formatCompact(vals[i]),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.getCategoryColor(cats[i], allCategories)
                                .withOpacity(0.9),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Label bawah: icon kategori
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 44,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= cats.length) return const SizedBox();
                      final color = AppTheme.getCategoryColor(cats[i], allCategories);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: color.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Image.asset(
                                AppIcons.getIcon(cats[i]),
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxVal * 0.33,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppTheme.border.withOpacity(0.25),
                  strokeWidth: 1,
                  dashArray: [4, 6],
                ),
              ),
              borderData: FlBorderData(show: false),
              barGroups: cats.asMap().entries.map((entry) {
                final i = entry.key;
                final color = AppTheme.getCategoryColor(cats[i], allCategories);
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: vals[i],
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withOpacity(0.75),
                          color.withOpacity(0.4),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.5, 1.0],
                      ),
                      width: barWidth,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxVal * 1.25,
                        color: color.withOpacity(0.07),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            swapAnimationDuration: const Duration(milliseconds: 400),
            swapAnimationCurve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}