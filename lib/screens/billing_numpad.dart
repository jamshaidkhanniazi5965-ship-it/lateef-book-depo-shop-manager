import 'package:flutter/material.dart';

const List<Color> _keyColors = [
  Color(0xFF5C6BC0), // indigo
  Color(0xFF26A69A), // teal
  Color(0xFFEF5350), // red
  Color(0xFFFFA726), // orange
];

/// A self-contained calculator. Not wired to cart pricing — it's a handy
/// side tool for the shop owner to do quick math while billing (e.g.
/// working out a discount or change due) without switching apps.
class BillingNumpad extends StatefulWidget {
  const BillingNumpad({super.key});

  @override
  State<BillingNumpad> createState() => _BillingNumpadState();
}

class _BillingNumpadState extends State<BillingNumpad> {
  String _expressionPrefix = ''; // e.g. "5+5+"
  String _currentNumberStr = '0';
  double? _pendingValue;
  String? _pendingOp;
  bool _justEvaluated = false;
  String _resultText = '0';

  String get _displayText {
    if (_justEvaluated) return _resultText;
    if (_expressionPrefix.isEmpty && _currentNumberStr.isEmpty) return '0';
    return '$_expressionPrefix$_currentNumberStr';
  }

  void _tapDigit(String digit) {
    setState(() {
      if (_justEvaluated) {
        _expressionPrefix = '';
        _currentNumberStr = digit;
        _pendingValue = null;
        _pendingOp = null;
        _justEvaluated = false;
      } else if (_currentNumberStr == '0') {
        _currentNumberStr = digit;
      } else {
        _currentNumberStr += digit;
      }
    });
  }

  void _tapDot() {
    setState(() {
      if (_justEvaluated) {
        _expressionPrefix = '';
        _currentNumberStr = '0.';
        _pendingValue = null;
        _pendingOp = null;
        _justEvaluated = false;
        return;
      }
      if (!_currentNumberStr.contains('.')) {
        _currentNumberStr += '.';
      }
    });
  }

  double _applyPending(double current) {
    if (_pendingValue == null || _pendingOp == null) return current;
    switch (_pendingOp) {
      case '+':
        return _pendingValue! + current;
      case '-':
        return _pendingValue! - current;
      case '×':
        return _pendingValue! * current;
      case '÷':
        return current == 0 ? 0 : _pendingValue! / current;
      default:
        return current;
    }
  }

  void _tapOperator(String op) {
    setState(() {
      final current = double.tryParse(_currentNumberStr) ?? 0;
      if (_pendingOp != null && !_justEvaluated) {
        // Chain operations: 5+5+ means evaluate 5+5 first, keep going.
        final result = _applyPending(current);
        _pendingValue = result;
        _expressionPrefix = '${_formatNumber(result)}$op';
      } else {
        _pendingValue = current;
        _expressionPrefix = '${_formatNumber(current)}$op';
      }
      _pendingOp = op;
      _currentNumberStr = '';
      _justEvaluated = false;
    });
  }

  void _tapEquals() {
    setState(() {
      final current = double.tryParse(_currentNumberStr) ?? 0;
      final result = _applyPending(current);
      _resultText = _formatNumber(result);
      _expressionPrefix = '';
      _currentNumberStr = '';
      _pendingValue = null;
      _pendingOp = null;
      _justEvaluated = true;
    });
  }

  void _tapClear() {
    setState(() {
      _expressionPrefix = '';
      _currentNumberStr = '0';
      _pendingValue = null;
      _pendingOp = null;
      _justEvaluated = false;
      _resultText = '0';
    });
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  Widget _key(String label, {Color? color, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Material(
            color: color ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap ?? () => _tapDigit(label),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: color != null ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          const Text('Calculator',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _displayText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(children: [
            _key('C', color: _keyColors[2], onTap: _tapClear),
            _key('÷', color: _keyColors[0], onTap: () => _tapOperator('÷')),
            _key('×', color: _keyColors[0], onTap: () => _tapOperator('×')),
            _key('-', color: _keyColors[0], onTap: () => _tapOperator('-')),
          ]),
          Row(children: [
            _key('7'),
            _key('8'),
            _key('9'),
            _key('+', color: _keyColors[0], onTap: () => _tapOperator('+')),
          ]),
          Row(children: [_key('4'), _key('5'), _key('6'), _key('.', onTap: _tapDot)]),
          Row(children: [
            _key('1'),
            _key('2'),
            _key('3'),
            _key('=', color: _keyColors[3], onTap: _tapEquals),
          ]),
          Row(children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: AspectRatio(
                  aspectRatio: 4,
                  child: Material(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _tapDigit('0'),
                      child: const Center(
                        child: Text('0',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
