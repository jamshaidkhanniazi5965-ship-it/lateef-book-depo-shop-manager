import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String _timesSign = '\u00D7';
const String _divideSign = '\u00F7';

const Color _clearColor = Color(0xFFEF5350);
const Color _opColor = Color(0xFFFFA726);
const Color _equalsColor = Color(0xFF17A398);

/// A self-contained calculator. Not wired to cart pricing - it's a handy
/// side tool for the shop owner to do quick math while billing.
/// Supports keyboard input: digits, . , + or = , - , * (Shift+8) for
/// multiply, / for divide, Enter for result, Backspace to delete a digit.
class BillingNumpad extends StatefulWidget {
  const BillingNumpad({super.key});

  @override
  State<BillingNumpad> createState() => _BillingNumpadState();
}

class _BillingNumpadState extends State<BillingNumpad> {
  final FocusNode _focusNode = FocusNode();

  String _expressionPrefix = '';
  String _currentNumberStr = '0';
  double? _pendingValue;
  String? _pendingOp;
  bool _justEvaluated = false;
  String _resultText = '0';

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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

  void _tapBackspace() {
    setState(() {
      if (_justEvaluated) {
        _tapClear();
        return;
      }
      if (_currentNumberStr.isNotEmpty) {
        _currentNumberStr =
            _currentNumberStr.substring(0, _currentNumberStr.length - 1);
      }
      if (_currentNumberStr.isEmpty) _currentNumberStr = '0';
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
      case _timesSign:
        return _pendingValue! * current;
      case _divideSign:
        return current == 0 ? 0 : _pendingValue! / current;
      default:
        return current;
    }
  }

  void _tapOperator(String op) {
    setState(() {
      final current = double.tryParse(_currentNumberStr) ?? 0;
      if (_pendingOp != null && !_justEvaluated) {
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

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      _tapEquals();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.escape) {
      _tapClear();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.backspace) {
      _tapBackspace();
      return KeyEventResult.handled;
    }

    final char = event.character;
    if (char == null) return KeyEventResult.ignored;

    if (RegExp(r'^[0-9]$').hasMatch(char)) {
      _tapDigit(char);
      return KeyEventResult.handled;
    }
    if (char == '.') {
      _tapDot();
      return KeyEventResult.handled;
    }
    if (char == '+' || char == '=') {
      _tapOperator('+');
      return KeyEventResult.handled;
    }
    if (char == '-') {
      _tapOperator('-');
      return KeyEventResult.handled;
    }
    if (char == '*') {
      _tapOperator(_timesSign);
      return KeyEventResult.handled;
    }
    if (char == '/') {
      _tapOperator(_divideSign);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  Widget _key(String label, {Color? color, VoidCallback? onTap, Widget? child}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: AspectRatio(
          aspectRatio: 1.25,
          child: Material(
            color: color ?? Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            elevation: color != null ? 1.5 : 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap ?? () => _tapDigit(label),
              child: Center(
                child: child ??
                    Text(
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
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: GestureDetector(
        onTap: () => _focusNode.requestFocus(),
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(left: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            children: [
              const Text('Calculator',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF14213D),
                  borderRadius: BorderRadius.circular(12),
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
                _key('C', color: _clearColor, onTap: _tapClear),
                _key('', color: Colors.grey.shade300, onTap: _tapBackspace,
                    child: const Icon(Icons.backspace_outlined, color: Colors.black54, size: 20)),
                _key('+', color: _opColor, onTap: () => _tapOperator('+')),
              ]),
              Row(children: [
                _key('7'),
                _key('8'),
                _key('9'),
                _key(_divideSign, color: _opColor, onTap: () => _tapOperator(_divideSign)),
              ]),
              Row(children: [
                _key('4'),
                _key('5'),
                _key('6'),
                _key(_timesSign, color: _opColor, onTap: () => _tapOperator(_timesSign)),
              ]),
              Row(children: [
                _key('1'),
                _key('2'),
                _key('3'),
                _key('-', color: _opColor, onTap: () => _tapOperator('-')),
              ]),
              Row(children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: AspectRatio(
                      aspectRatio: 2.7,
                      child: Material(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _tapDigit('0'),
                          child: const Center(
                            child: Text('0',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _key('.', onTap: _tapDot),
                _key('=', color: _equalsColor, onTap: _tapEquals),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

