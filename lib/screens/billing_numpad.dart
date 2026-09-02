import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const List<Color> _keyColors = [
  Color(0xFF5C6BC0), // indigo
  Color(0xFF26A69A), // teal
  Color(0xFFEF5350), // red
  Color(0xFFFFA726), // orange
];

class BillingNumpad extends StatefulWidget {
  const BillingNumpad({super.key});

  @override
  State<BillingNumpad> createState() => _BillingNumpadState();
}

class _BillingNumpadState extends State<BillingNumpad> {
  final FocusNode _focusNode = FocusNode();
  String _expressionPrefix = ''; // e.g. "5+5+"
  String _currentNumberStr = '0'; // number currently being typed
  double? _pendingValue;
  String? _pendingOp;
  bool _justEvaluated = false;
  String _resultText = '0';

  String get _displayText {
    if (_justEvaluated) return _resultText;
    final prefix = _expressionPrefix;
    final current = _currentNumberStr;
    if (prefix.isEmpty && current.isEmpty) return '0';
    return '$prefix$current';
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
      if (!_currentNumberStr.contains('.')) _currentNumberStr += '.';
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

  void _tapBackspace() {
    setState(() {
      if (_justEvaluated) return;
      if (_currentNumberStr.length <= 1) {
        _currentNumberStr = '0';
      } else {
        _currentNumberStr =
            _currentNumberStr.substring(0, _currentNumberStr.length- 1);
      }
    });
  }

  double _applyOp(double a, double b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? 0 : a / b;
      default:
        return b;
    }
  }

  void _tapOperator(String op) {
    setState(() {
      final current = double.tryParse(_currentNumberStr) ?? 0;

      if (_justEvaluated) {
        _pendingValue = double.tryParse(_resultText) ?? current;
        _expressionPrefix = '$_resultText$op';
        _currentNumberStr = '0';
        _pendingOp = op;
        _justEvaluated = false;
        return;
      }

      if (_pendingValue != null && _pendingOp != null) {
        _pendingValue = _applyOp(_pendingValue!, current, _pendingOp!);
      } else {
        _pendingValue = current;
      }
      _expressionPrefix += '$_currentNumberStr$op';
      _currentNumberStr = '0';
      _pendingOp = op;
    });
  }

  void _tapEquals() {
    setState(() {
      final current = double.tryParse(_currentNumberStr) ?? 0;
      if (_pendingValue != null && _pendingOp != null) {
        final result = _applyOp(_pendingValue!, current, _pendingOp!);
        _resultText = _formatResult(result);
      } else {
        _resultText = _formatResult(current);
      }
      _pendingValue = null;
      _pendingOp = null;
      _expressionPrefix = '';
      _justEvaluated = true;
    });
  }

  String _formatResult(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final key = event.logicalKey;

    final digitKeys = {
      LogicalKeyboardKey.digit0: '0', LogicalKeyboardKey.numpad0: '0',
      LogicalKeyboardKey.digit1: '1', LogicalKeyboardKey.numpad1: '1',
      LogicalKeyboardKey.digit2: '2', LogicalKeyboardKey.numpad2: '2',
      LogicalKeyboardKey.digit3: '3', LogicalKeyboardKey.numpad3: '3',
      LogicalKeyboardKey.digit4: '4', LogicalKeyboardKey.numpad4: '4',
      LogicalKeyboardKey.digit5: '5', LogicalKeyboardKey.numpad5: '5',
      LogicalKeyboardKey.digit6: '6', LogicalKeyboardKey.numpad6: '6',
      LogicalKeyboardKey.digit7: '7', LogicalKeyboardKey.numpad7: '7',
      LogicalKeyboardKey.digit8: '8', LogicalKeyboardKey.numpad8: '8',
      LogicalKeyboardKey.digit9: '9', LogicalKeyboardKey.numpad9: '9',
    };

    if (digitKeys.containsKey(key)) {
      _tapDigit(digitKeys[key]!);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.period ||
        key == LogicalKeyboardKey.numpadDecimal) {
      _tapDot();
      return KeyEventResult.handled;
    }
    // '=' key (unshifted, same physical key as '+') now triggers addition
    if (key == LogicalKeyboardKey.add ||
        key == LogicalKeyboardKey.numpadAdd ||
        key == LogicalKeyboardKey.equal) {
      _tapOperator('+');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.minus ||
        key == LogicalKeyboardKey.numpadSubtract) {
      _tapOperator('-');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.numpadMultiply) {
      _tapOperator('×');
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.slash ||
        key == LogicalKeyboardKey.numpadDivide) {
      _tapOperator('÷');
      return KeyEventResult.handled;
    }
    // Only Enter evaluates now (equal key is reserved for '+' above)
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _tapEquals();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace) {
      _tapBackspace();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape || key == LogicalKeyboardKey.delete) {
      _tapClear();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _key(String label, {Color? color, VoidCallback? onTap}) {
    final bg = color ?? Colors.grey.shade200;
//     final fg = color != null ? Colors.white : Colors.black87;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AspectRatio(
          aspectRatio: 1.3,
          child: Material(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: onTap,
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text('Calculator', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  _displayText,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              _key('C', color: _keyColors[2], onTap: _tapClear),
              _key('⌫', color: Colors.grey.shade400, onTap: _tapBackspace),
              _key('÷', color: _keyColors[3], onTap: () => _tapOperator('÷')),
            ]),
            Row(children: [
              _key('7', onTap: () => _tapDigit('7')),
              _key('8', onTap: () => _tapDigit('8')),
              _key('9', onTap: () => _tapDigit('9')),
            ]),
            Row(children: [
              _key('4', onTap: () => _tapDigit('4')),
              _key('5', onTap: () => _tapDigit('5')),
              _key('6', onTap: () => _tapDigit('6')),
            ]),
            Row(children: [
              _key('1', onTap: () => _tapDigit('1')),
              _key('2', onTap: () => _tapDigit('2')),
              _key('3', onTap: () => _tapDigit('3')),
            ]),
            Row(children: [
              _key('0', onTap: () => _tapDigit('0')),
              _key('.', onTap: _tapDot),
              _key('=', color: _keyColors[1], onTap: _tapEquals),
            ]),
            Row(children: [
              _key('+', color: _keyColors[0], onTap: () => _tapOperator('+')),
              _key('-', color: _keyColors[0], onTap: () => _tapOperator('-')),
              _key('×', color: _keyColors[3], onTap: () => _tapOperator('×')),
            ]),
          ],
        ),
      ),
    );
  }
}

