import 'package:flutter/material.dart';

class MediaControlButton extends StatefulWidget {
  final VoidCallback handleTap;
  final IconData icon;
  const MediaControlButton({
    super.key,
    required this.icon,
    required this.handleTap,
  });

  @override
  State<MediaControlButton> createState() => _MediaControlButtonState();
}

class _MediaControlButtonState extends State<MediaControlButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.handleTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(widget.icon, size: 20, color: Colors.white),
      ),
    );
  }
}
