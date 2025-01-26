// lib\common\components\quantity_counter.dart

import 'package:flutter/material.dart';
import 'package:grocery_app/core/themes/app_colors.dart';

class QuantityCounter extends StatefulWidget {
  final int counterValue;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool isLoading;
  final bool canBeDeleted;
  final void Function()? onDeleteItem;
  const QuantityCounter({
    this.canBeDeleted = false,
    this.onDeleteItem,
    this.isLoading = false,
    required this.counterValue,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  @override
  State<QuantityCounter> createState() => _QuantityCounterState();
}

class _QuantityCounterState extends State<QuantityCounter> {
  int _counter = 0;

  @override
  void initState() {
    _counter = widget.counterValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final containerColor = Color(0xFFEFEFEF);
    final textColor = AppColors.blackText;
    final iconsColor = AppColors.lightYellow;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildCounterButton(
            icon: widget.canBeDeleted
                ? (_counter == 1 ? Icons.delete_rounded : Icons.remove)
                : Icons.remove,
            onPressed: widget.canBeDeleted
                ? (_counter > 1
                    ? () => updateCounterValue(--_counter)
                    : widget.onDeleteItem)
                : (_counter > 1 ? () => updateCounterValue(--_counter) : null),
            textColor: iconsColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '${_counter < 10 ? '0' : ''}$_counter',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            width: 10,
          ),
          _buildCounterButton(
            icon: Icons.add,
            onPressed:
                _counter < 10 ? () => updateCounterValue(++_counter) : null,
            textColor: iconsColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required Color textColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Icon(icon,
            size: 20,
            color: onPressed != null
                ? textColor
                : textColor.withValues(alpha: 0.3)),
      ),
    );
  }

  updateCounterValue(int i) {
    setState(() {
      _counter = i;
    });
  }
}
