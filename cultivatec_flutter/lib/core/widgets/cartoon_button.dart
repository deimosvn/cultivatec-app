import 'package:flutter/material.dart';

class CartoonButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color color;
  final Color shadowColor;
  final Color textColor;
  final bool isLoading;

  const CartoonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.color = const Color(0xFFFFC64B),
    this.shadowColor = const Color(0xFFE59C1D),
    this.textColor = const Color(0xFF4A4A4A),
    this.isLoading = false,
  });

  @override
  State<CartoonButton> createState() => _CartoonButtonState();
}

class _CartoonButtonState extends State<CartoonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = false);
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        if (widget.onPressed != null && !widget.isLoading) {
          setState(() => _isPressed = false);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: EdgeInsets.only(top: _isPressed ? 6 : 0, bottom: _isPressed ? 0 : 6),
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: widget.onPressed == null ? Colors.grey.shade400 : widget.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (!_isPressed)
              BoxShadow(
                color: widget.onPressed == null ? Colors.grey.shade600 : widget.shadowColor,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  widget.text.toUpperCase(),
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
